Linux
=====

工具配置
--------

ssh
```

ssh生成密钥对
:::::::::::::

根据指定算法alg生成标题为comment的秘钥:

``ssh-keygen [-t alg] [-C comment]``

ssh config
::::::::::

.. literalinclude:: codes/linux/ssh_config
    :caption: ~/.ssh/config文件示例
    :language: text

ssh服务端添加客户端公钥
:::::::::::::::::::::::

1. ``chmod 700 /home/${user}``
2. ``/home/${user}/.ssh/authorized_keys`` 下新增一行客户端公钥文件内容

脚本工具
--------

解析命令输入选项
````````````````
.. literalinclude:: codes/linux/getopt.sh
    :caption: 示例代码
    :language: sh
    :linenos:



升级openssl到1.1.1w
```````````````````

**升级原因**: 使用python3时可能因为urllib3的版本过高导致与openssl1.0.x不兼容(如使用requests)，可以通过指定安装urll3b的版本为1.26或升级openssl到1.1.1

**OpenSSL3与OpenSSL1**: OpenSSL1是单线程架构、支持TLS1.2及以下，OpenSSL3是多线程架构、支持TLS1.3，、安全性更高、代码不兼容OpenSSL1

.. literalinclude:: codes/linux/upgrade_to_openssl_1_1_1w.sh
    :caption: 升级openssl到1.1.1w并应用到python
    :language: sh
    :linenos:

wsl安装glibc_2.28
`````````````````

过程中出现命令不可用的情况，使用
``LD_PRELOAD=/lib/x86_64-linux-gnu/libc-2.27.so COMMAND``
调用COMMAND命令

.. literalinclude:: codes/linux/wsl_install_glibc_2_28.sh
    :language: sh
    :linenos:
