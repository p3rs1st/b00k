待整理笔记
==========

待补充内容
----------

* 将 `原笔记 <https://p3rs1st.github.io/camille>`_ 迁移过来
* 如何升级openssl到1.1.1 以及openssl3与openssl1区别

相关方法::

   1. 进入一个目录如/usr/local/src
   2. wget https://github.com/openssl/openssl/archive/refs/tags/OpenSSL_1_1_1w.tar.gz下载
   3. tar zxvf openssl-OpenSSL_1_1_1w.tar.gz
   4. cd openssl-OpenSSL_1_1_1w
   5. ./config --prefix=/opt/openssl-1.1.1
   6. make && make install
   7. mv /usr/bin/openssl /usr/bin/oldopenssl
   8. ln -s /opt/openssl-1.1.1/bin/openssl /usr/bin/openssl
   9. ln -s /opt/openssl-1.1.1/lib/libssl.so.1.1 /usr/lib64/
   10. ln -s /opt/opnessl-1.1.1/lib/libcrypto.so.1.1 /usr/lib64/
   11. 进入Python的解压路径如/usr/local/src/Python-3.9.18
   12. ./configure --with-openssl=/opt/openssl-1.1.1
   13. make && make install
   14. python指定版本 python3.9 -c "import ssl; print(ssl.OPENSSL_VERSION)"查询是否为1.1.1

* maxwell的作用以及使用方式
* kafka基本使用与意义
* sqlalchemy2使用
* db守护进程的这种与后端服务分离的设计方式
* python gunicorn日志配置
* python format: black flake8
* mysqldump导入导出指令
* pre commit
* python 装饰器
* 网络请求设计在输入多余信息时给出提示，在使用默认时给出提示，更多用失败地方式告诉使用者失败而不是准备默认值
* docker开启远程操作
* 在mac上开启docker远程连接
* zk集群、kafka集群、mysql主从
* 常用功能函数集合
* docker内stderr如何同时输出到文件和控制台以及优劣问题
* 软删除
* pytest mock在from import情况下会失效 `相关博客 <https://blog.csdn.net/qq_19446965/article/details/109018594>`_



.. autosummary::
   :toctree: generated
