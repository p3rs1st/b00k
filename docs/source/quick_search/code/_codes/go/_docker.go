package main

import (
	"archive/tar"
	"bytes"
	"context"
	"fmt"
	"io"
	"os"
	"path"

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

func DockerCopy(containerID, containerPath, hostPath string) error {
	ctx := context.Background()
	client, err := Client()
	if err != nil {
		return err
	}
	// 拷贝单个文件
	// 拷贝进去必须为tar压缩包
	file, err := os.OpenFile(hostPath, os.O_RDONLY, 0755)
	if err != nil {
		return err
	}
	// 拷贝的目标地址需要为指定为目录路径，拷贝后会自动解压到目录路径下
	if err = client.CopyToContainer(ctx, containerID, path.Dir(containerPath), file, container.CopyToContainerOptions{}); err != nil {
		return fmt.Errorf("copy file to container error: %w", err)
	}
	// 拷贝出来是tar压缩包，需要自行解压
	reader, _, err := client.CopyFromContainer(context.Background(), containerID, srcPath)
	if err != nil {
		return err
	}
	// 下面适用于拷贝单文件时的场景
	tarReader := tar.NewReader(reader)
	if _, err = tarReader.Next(); err != nil {
		return err
	}
	buf := bytes.NewBufferString("")
	if _, err = io.Copy(buf, tarReader); err != nil {
		return err
	}
	fmt.Println(buf.String())
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
