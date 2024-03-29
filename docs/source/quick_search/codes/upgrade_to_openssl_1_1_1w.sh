#!/bin/bash
set -e

# 可修改参数
workdir=/usr/local/src                 # 工作目录
openssl_savedir=/opt/openssl-1.1.1     # openssl保存地址
python=python3.9                       # 待更新openssl版本的python命令
python_srcdir=/usr/local/src/python3.9 # 待更新openssl版本的python源码位置
# 高级参数
oldopenssl_reservepath= # 旧openssl备份地址
# 可修改参数结束

function install_openssl_1_1_1w() {
    if openssl version | grep 1.1.1w >/dev/null; then
        echo "openssl 1.1.1w已存在"
        return 0
    fi

    cd ${workdir}
    if [ -d "openssl-OpenSSL_1_1_1w" ] >/dev/null; then
        echo "openssl-OpenSSL_1_1_1w文件夹已存在，不再下载"
    else
        if [ -e "OpenSSL_1_1_1w.tar.gz" ] >/dev/null; then
            echo "OpenSSL_1_1_1w.tar.gz文件已存在，不再下载"
        else
            wget https://github.com/openssl/openssl/archive/refs/tags/OpenSSL_1_1_1w.tar.gz
        fi
        tar zxvf OpenSSL_1_1_1w.tar.gz
    fi

    cd openssl-OpenSSL_1_1_1w
    ./config --prefix=${openssl_savedir}
    make && make install
    mv /usr/bin/openssl "${oldopenssl_reservepath}"
    ln -s /opt/openssl-1.1.1/bin/openssl /usr/bin/openssl
    ln -s /opt/openssl-1.1.1/lib/libssl.so.1.1 /usr/lib64/libssl.so.1.1
    ln -s /opt/openssl-1.1.1/lib/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1

    openssl version | grep 1.1.1w >/dev/null
    return $?
}

function apply_openssl_1_1_1w_to_python() {
    cd ${python_srcdir}
    ./configure --with-openssl=${openssl_savedir} prefix=${workdir}
    make && make install

    python3.9 -c "import ssl; print(ssl.OPENSSL_VERSION)" | grep 1.1.1w
    return $?
}

if ! install_openssl_1_1_1w; then
    echo "安装openssl 1.1.1w失败"
    exit 1
fi

if [ -d ${python_srcdir} ]; then
    apply_openssl_1_1_1w_to_python
else
    echo "python源码目录不存在, 后续将跳过更新python的openssl版本"
fi
