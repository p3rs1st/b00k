服务
====

inotify
-------

监控文件系统的的变化并将通知相应事件

.. code-block:: bash
    :caption: command
    :linenos:

    # 持续监控，-m持续监控，-q静默模式，-r递归文件夹，-e指定监控事件
    # ERRLOG保存错误日志
    inotifywait ${SOURCE} -mqr -e modify,close_write,move,create,delete,delete_self 2>>${ERRLOG} | while read -r -a splited; do
        if [[ ${splited[0]} == "${SOURCE}"* ]]; then
            # 正常输出为路径 + 事件
            echo ${splited[*]}
        else
            # 异常输出开头不是路径
            echo "stderr:" "${splited[@]}" >>"${ERRLOG}"
        fi
    done

openssl
-------

加解密
``````

.. code-block:: bash
    :caption: command
    :linenos:

    # 加密，加密算法为ALG，秘钥为KEY，迭代次数ITER
    openssl enc -e ${ALG} -k ${KEY} -iter ${ITER} -in ${SOURCE} -out ${DEST}
    # 解密
    openssl enc -e ${ALG} -k ${KEY} -iter ${ITER} -in ${SOURCE} -out ${DEST} -d


rsync
-----

用于本地与本地或本地与远程之间的文件夹同步，命令参考 `阮一峰 <https://www.ruanyifeng.com/blog/2020/08/rsync.html>`__

.. code-block:: bash
    :caption: command
    :linenos:

    # 本地同步
    rsync -r ${SOURCE1} ${SOURCE2} ${DESTINATION}
    # 参数列表
    # -a 同步元信息
    # --delete 同步且删除，默认同步不会删除文件
    # ssh同步
    rsync -a ${SOURCE} ${USER}@{HOST}:${DESTINATION}
    # rsync同步，要求远程运行rsync daemon
    rsync -a ${SOURCE} ${HOST}::${MODULE}/${DESTINATION}
    # MODULE为rsync daemon指定的资源名，通过下述命令查看可用MODULE列表
    rsync rsync://${IP}
    # 增量备份，将COMPARE与SOURCE比较，将diff文件拷贝到TARGET，nodiff文件生成硬链接
    rsync -a --delete --link-dest ${COMPARE} ${SOURCE} ${TARGET}

Kafka
-----

.. code-block:: bash
    :caption: command
    :linenos:

    # 创建话题
    kafka-topics.sh --create \
        --topic ${TOPIC} \
        --replication-factor 3 \ # 副本数
        --partitions 1 \ # 分区数
        --bootstrap-server ${KAFKA1},${KAFKA2},${KAFKA3} # kafka broker，ip:port

    # 删除话题
    kafka-topics.sh --delete \
        --topic ${TOPIC} \
        --bootstrap-server ${KAFKA1},${KAFKA2},${KAFKA3} # kafka broker，ip:port


Maxwell
-------

CDC(change data capture)应用，通过成为mysql的从节点读取mysql的binlog，将发生变化的数据以JSON格式写入流平台如Kafka、Redis消息队列等

使用简单，参考 `官方文档 <https://maxwells-daemon.io/>`__

使用案例：进程监听数据表状态列的改变并进行业务处理，使用maxwell监测状态列的改变后通过消息队列转交给监听进程，监听进程不需要定期拉取数据库

Nginx
-----


.. code-block:: bash
    :caption: command
    :linenos:

    # 测试配置文件
    nginx -t
    # 重新加载配置
    nginx -s reload


.. literalinclude:: _codes/server/nginx.conf
    :caption: nginx常用配置
    :linenos:
