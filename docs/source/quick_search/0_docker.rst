docker
======

Command
-------

+----------------------------------------------------+----------------------+
| 命令                                               | 说明                 |
+====================================================+======================+
| docker images                                      | 查看所有本地镜像     |
+----------------------------------------------------+----------------------+
| docker pull IMAGE[:TAG]                            | 拉取远程镜像         |
+----------------------------------------------------+----------------------+
| docker rmi [IMAGE]                                 | 删除镜像             |
+----------------------------------------------------+----------------------+
| docker ps -a                                       | 查看运行中(所有)容器 |
+----------------------------------------------------+----------------------+
| docker start/stop/restart [CONTAINER]              | 启动/停止/重启容器   |
+----------------------------------------------------+----------------------+
| docker rm [CONTAINER]                              | 删除容器             |
+----------------------------------------------------+----------------------+
||                                                   || 在容器中执行命令    |
|| docker exec -it [CONTAINER] [COMMAND]             || -i: 打开stdin       |
||                                                   || -t: 分配一个终端    |
+----------------------------------------------------+----------------------+
| docker inspect [CONTAINER]                         | 检视容器             |
+----------------------------------------------------+----------------------+
| docker logs [CONTAINER]                            | 查看容器日志         |
+----------------------------------------------------+----------------------+
| docker port [CONTAINER]                            | 查看容器端口信息     |
+----------------------------------------------------+----------------------+
||                                                   || 构建容器            |
|| docker build [-t NAME[:TAG]] [-f DOCKERFILE] PATH || -t: 镜像名、标签    |
||                                                   || -f: Dockerfile路径  |
||                                                   || PATH:构建结果目录   |
+----------------------------------------------------+----------------------+
| docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]   | 拷贝新镜像名         |
+----------------------------------------------------+----------------------+
| docker load [-i FILE]                              | 导入tar文件的镜像    |
+----------------------------------------------------+----------------------+
| docker save [-o FILE] IMAGE [IMAGE...]             | 将镜像保存为tar文件  |
+----------------------------------------------------+----------------------+

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

Dockerfile
----------

Golang基础Dockerfile
````````````````````

.. literalinclude:: _codes/docker/golang.dockerfile
    :language: dockerfile
    :linenos:

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

    [Service]
    ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375 --containerd=/run/containerd/containerd.sock

    # 编辑结束
