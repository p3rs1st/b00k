#!/bin/bash

sudo su
cd ~
curl -O http://ftp.gnu.org/gnu/glibc/glibc-2.28.tar.gz
tar zxf glibc-2.28.tar.gz
cd glibc-2.28/
mkdir build
cd build/
../configure --prefix=/usr/local/glibc-2.28
make -j2
make install

# make install WSL下出现报错
mkdir /usr/lib/wsl/lib2
ln -s /usr/lib/wsl/lib/* /usr/lib/wsl/lib2
ldconfig

# 每次重启后不自动还原
vi /etc/wsl.conf

# 编辑内容
# [automount]
# ldconfig = false
# 编辑内容结束
# make install end

# 修改libc.so.6连接后无法直接使用任何命令, 需要在命令前面加上LD_PRELOAD的形式

cd /lib/x86_64-linux-gnu
cp /usr/local/glibc-2.28/lib/ld-2.28.so .
cp /usr/local/glibc-2.28/lib/libc-2.28.so .
unlink ld-linux-x86-64.so.2
ln -s ld-2.28.so ld-linux-x86-64.so.2
unlink libc.so.6
LD_PRELOAD=libc-2.27.so ln -s libc-2.28.so libc.so.6
LD_PRELOAD=/lib/x86_64-linux-gnu/libc-2.27.so unlink /lib64/ld-linux-x86-64.so.2
/lib/x86_64-linux-gnu/ld-2.28.so /bin/ln -s /lib/x86_64-linux-gnu/ld-2.28.so /lib64/ld-linux-x86-64.so.2
strings /lib/x86_64-linux-gnu/libc.so.6 | grep GLIBC_2.28 # 查看是否安装成功
