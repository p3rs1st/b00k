服务
====

Maxwell
-------

CDC(change data capture)应用，通过成为mysql的从节点读取mysql的binlog，将发生变化的数据以JSON格式写入流平台如Kafka、Redis消息队列等

使用简单，参考 `官方文档 <https://maxwells-daemon.io/>`__

Nginx
-----

Command
```````

+-----------------+--------------+
| 命令            | 说明         |
+=================+==============+
| nginx -t        | 测试配置文件 |
+-----------------+--------------+
| nginx -s reload | 重新加载配置 |
+-----------------+--------------+


.. literalinclude:: _codes/server/nginx.conf
    :caption: nginx常用配置
    :linenos:
