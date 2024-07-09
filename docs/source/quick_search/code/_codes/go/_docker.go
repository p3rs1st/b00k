package main

import (
	"context"
	"fmt"
	"io"
	"os"

	"github.com/docker/docker/api/types/container"
	"github.com/docker/docker/api/types/image"
	"github.com/docker/docker/client"
	"github.com/docker/docker/container"
	"github.com/docker/docker/image"
)

func Client() (*client.Client, error) {
	// 设置远程docker
	os.Setenv("DOCKER_HOST", "tcp://127.0.0.1:2375")
	// client.WithApiVersionNegotiation()防止服务端与客户端docker版本不一致
	return client.NewClientWithOpts(client.FromEnv, client.WithAPIVersionNegotiation())
}

func DockerRun(imageID string) (string, error) {
	ctx := context.Background()
	client, err := Client()
	if err != nil {
		return "", err
	}
	reader, err := client.ImagePull(ctx, imageID, image.PullOptions{})
	if err == nil {
		// 必须要将返回的ReadCloser读取出来才能够完成镜像拉取
		_, err = io.Copy(io.Discard, reader)
	}
	if err != nil {
		return "", err
	}
	defer reader.Close()
	createResp, err := client.ContainerCreate(
		ctx, &container.Config{Image: imageID}, &container.HostConfig{}, nil, nil, "")
	if err != nil {
		return "", err
	}
	if err = client.ContainerStart(ctx, createResp.ID, container.StartOptions{}); err != nil {
		return "", err
	}
	return createResp.ID, nil
}

func DockerWait(containerID string) error {
	ctx := context.Background()
	client, err := Client()
	if err != nil {
		return err
	}

	waitChan, errChan := client.ContainerWait(ctx, containerID, container.WaitConditionNotRunning)
	select {
	case waitResp := <-waitChan:
		fmt.Println(waitResp)
	case err := <-errChan:
		fmt.Println(err)
		return err
	}
	return nil
}
