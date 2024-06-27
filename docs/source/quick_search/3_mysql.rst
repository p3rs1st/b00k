mysql
=====

command
-------

mysqldump
`````````

导出数据库内容

.. code-block:: bash

    # 注意替换变量
    # 导出数据库${database}到${file}
    mysqldump -h ${host} -P ${port} -u ${user} -p${passwd} ${database} >${file}
    # 相应的导入
    mysql -u ${user} -p${passwd} ${database} <${file}

sql
---

mysql8的密码插件问题
````````````````````

从MySQL8.0.4开始，默认的密码认证插件从 ``mysql_native_password`` 变为 ``caching_sha2_password`` ，导致一些客户端无法连接（如Sequel Pro）

.. literalinclude:: _codes/mysql/add_user_mysql_native_password.sql
    :caption: 新增用户支持mysql_native_password
    :language: sql
