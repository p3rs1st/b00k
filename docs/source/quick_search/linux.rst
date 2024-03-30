Linux
=====

升级openssl到1.1.1w
-------------------

**升级原因**: 使用python3时可能因为urllib3的版本过高导致与openssl1.0.x不兼容(如使用requests)，可以通过指定安装urll3b的版本为1.26或升级openssl到1.1.1

**OpenSSL3与OpenSSL1**: OpenSSL1是单线程架构、支持TLS1.2及以下，OpenSSL3是多线程架构、支持TLS1.3，、安全性更高、代码不兼容OpenSSL1

.. literalinclude:: codes/upgrade_to_openssl_1_1_1w.sh
    :caption: 升级openssl到1.1.1w并应用到python
    :language: sh
    :linenos:
