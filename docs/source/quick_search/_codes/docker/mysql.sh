#!/bin/bash
set -e

# 可修改参数
mysql_image=mysql     # mysql镜像
mysql_container_name= # mysql容器名称
mysql_password=       # mysql密码
mysql_port=3306       # mysql映射到宿主机的端口
# 可修改参数结束

ARGS=$(getopt -o "" -l "mysql_image:,mysql_container_name::,mysql_password::,mysql_port::" -- "$@")

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

function run_docker_mysql() {
  docker pull ${mysql_image}
  mysql_name_option=$(test -n "${mysql_container_name}" && echo "--name ${mysql_container_name}")
  mysql_port_option=$(test -n "${mysql_port}" && echo "-p ${mysql_port}:3306")
  mysql_password_option=$(test -n "${mysql_password}" && echo "-e MYSQL_ROOT_PASSWORD=${mysql_password}" || echo "-e MYSQL_ALLOW_EMPTY_PASSWORD=true")

  # shellcheck disable=SC2086
  docker run -itd ${mysql_name_option} ${mysql_port_option} ${mysql_password_option} ${mysql_image}
}

if ! run_docker_mysql; then
  echo "启动mysql容器失败"
  exit 1
fi
