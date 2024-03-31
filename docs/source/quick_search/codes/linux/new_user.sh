#!/bin/bash
set -e

# 可修改参数
user=user # 用户名
# 可修改参数结束

useradd ${user} # 创建新用户
passwd ${user}  # 设置密码

# 拷贝基本环境
mkdir /home/${user}
cp /etc/skel/.b* /home/${user}
cp /etc/skel/.p* /home/${user}
chown -R ${user} /home/${user}
chmod 770 /home/${user}
usermod -s /bin/bash ${user}
