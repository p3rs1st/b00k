#!/bin/bash
set -e

# 可修改参数
workdir=/usr/local/src                 # 工作目录
openssl_savedir=/opt/openssl-1.1.1     # openssl保存地址
python_cmd=python3.9                   # 待更新openssl版本的python命令
python_srcdir=/usr/local/src/python3.9 # 待更新openssl版本的python源码位置
python_installdir=/usr/local/python3.9 # python安装到的目录
# 高级参数
oldopenssl_reservepath= # 旧openssl备份地址
# 可修改参数结束

ARGS=$(getopt -o "" -l "workdir:,openssl_savedir:,python_cmd:,python_srcdir:,oldopenssl_reservepath:,python_installdir:" -- "$@")

eval set -- "${ARGS}"

while true; do
  case $1 in
  --)
    shift
    break
    ;;
  *)
    declare "${1:2}"="$2"
    shift 2
    ;;
  esac
done

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
  if [ -n "${oldopenssl_reservepath}" ]; then
    mv /usr/bin/openssl "${oldopenssl_reservepath}"
  else
    rm /usr/bin/openssl
  fi
  ln -s /opt/openssl-1.1.1/bin/openssl /usr/bin/openssl
  ln -s /opt/openssl-1.1.1/lib/libssl.so.1.1 /usr/lib64/libssl.so.1.1
  ln -s /opt/openssl-1.1.1/lib/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1

  if ! openssl version | grep 1.1.1w >/dev/null; then
    echo "安装openssl1.1.1w失败"
  fi
  return $?
}

function apply_openssl_1_1_1w_to_python() {
  if ${python_cmd} -c "import ssl; print(ssl.OPENSSL_VERSION)" | grep 1.1.1w; then
    echo "python已有openssl1.1.1w"
    return 0
  fi
  cd ${python_srcdir}
  ./configure --prefix=${python_installdir} --with-openssl=${openssl_savedir}
  make && make install

  if ! ${python_cmd} -c "import ssl; print(ssl.OPENSSL_VERSION)" | grep 1.1.1w; then
    echo "python更新openssl失败, 请查看urllib3版本是否更新"
  fi
  return $?
}

install_openssl_1_1_1w

if [ -d ${python_srcdir} ]; then
  apply_openssl_1_1_1w_to_python
else
  echo "python源码目录不存在, 后续将跳过更新python的openssl版本"
fi
