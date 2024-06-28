docker
======

Command
-------

.. code-block::
    :caption: command
    :linenos:

    # 查看所有本地镜像
    docker images
    # 拉取远程镜像
    docker pull ${IMAGE}
    # 删除镜像
    docker rmi ${IMAGE}[:${TAG}]
    # 查看运行中(所有)容器
    docker ps -a
    # 启动/停止/重启容器
    docker start/stop/restart ${CONTAINER}
    # 删除容器
    docker rm ${CONTAINER}
    # 在容器中执行命令，-i打开stdin，-t分配终端
    docker exec -it ${CONTAINER} ${COMMAND}
    # 检视容器
    docker inspect ${CONTAINER}
    # 查看容器日志
    docker logs ${CONTAINER}
    # 查看容器端口信息
    docker port ${CONTAINER}
    # 构建容器，-t: 镜像名、标签，-f: Dockerfile路径，PATH:构建结果目录
    docker build -t ${IMAGE}[:${TAG}] [-f ${DOCKERFILE}] ${PATH}
    # 拷贝新镜像名
    docker tag ${SOURCE_IMAGE}[:${TAG}] ${TARGET_IMAGE}[:${TAG}]
    # 导入tar文件的镜像
    docker load [-i ${FILE}]
    # 将镜像保存为tar文件
    docker save [-o ${FILE}] ${IMAGE} [${IMAGE1}...]

Compose
-------

MySQL
`````

.. literalinclude:: _codes/docker_compose/mysql.yml
    :caption: mysql.yml
    :language: yaml
    :linenos:

.. literalinclude:: _codes/docker_compose/mysql/master.cnf
    :caption: mysql/master.cnf
    :language: ini
    :linenos:

.. literalinclude:: _codes/docker_compose/mysql/slave.cnf
    :caption: mysql/slave.cnf
    :language: ini
    :linenos:

.. literalinclude:: _codes/docker_compose/mysql/postprocess.sql
    :caption: docker compose启动后处理
    :language: sql
    :linenos:

Zookeeper
`````````

.. literalinclude:: _codes/docker_compose/zookeeper.yml
    :caption: zookeeper.yml
    :language: yaml
    :linenos:

.. literalinclude:: _codes/docker_compose/zookeeper/master_myid
    :caption: zookeeper/master_myid
    :language: ini
    :linenos:

.. literalinclude:: _codes/docker_compose/zookeeper/slave1_myid
    :caption: zookeeper/slave1_myid
    :language: ini
    :linenos:

.. literalinclude:: _codes/docker_compose/zookeeper/slave2_myid
    :caption: zookeeper/slave2_myid
    :language: ini
    :linenos:

.. literalinclude:: _codes/docker_compose/zookeeper/zoo.cfg
    :caption: zookeeper/master_myid
    :language: cfg
    :linenos:

Kafka
`````

所有的KAFKA_ZOOKEEPER_CONNECT需要改为可访问的zookeeper地址

.. literalinclude:: _codes/docker_compose/kafka.yml
    :caption: kafka.yml
    :language: yaml
    :linenos:

Dockerfile
----------

ssh server by centos
````````````````````

.. literalinclude:: _codes/docker/sshserver.dockerfile
    :language: dockerfile
    :linenos:

Golang基础Dockerfile
````````````````````

.. literalinclude:: _codes/docker/golang.dockerfile
    :language: dockerfile
    :linenos:

配置
----

macos以privileged启动容器报错 ``Failed to get D-Bus connection: No such file or directory``

.. code-block:: bash
    :linenos:

    vi ~/Library/Group\ Containers/group.com.docker/settings.json

    # 编辑开始
    {
        "deprecatedCgroupv1": true
    }
    # 编辑结束

    # 重启docker


容器启动脚本
------------

MongoDB
```````

.. literalinclude:: _codes/docker/mongo.sh
    :language: bash
    :linenos:

MySQL
`````

.. literalinclude:: _codes/docker/mysql.sh
    :language: bash
    :linenos:

Redis
`````

.. literalinclude:: _codes/docker/redis.sh
    :language: bash
    :linenos:


远程访问
--------

linux
`````

.. code-block:: bash

    vi /usr/lib/systemd/system/docker.service

    # 编辑开始

    ${Service}
    ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375 --containerd=/run/containerd/containerd.sock

    # 编辑结束
