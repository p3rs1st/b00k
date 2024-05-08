#!/bin/bash
set -e

# 可修改参数
redis_image=redis          # redis镜像
redis_container_name=redis # redis容器名称
redis_port=6379            # redis映射到宿主机的端口
# 可修改参数结束

ARGS=$(getopt -o "" -l "redis_image:,redis_container_name:,redis_port:" -- "$@")

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

function run_docker_redis() {
  docker pull ${redis_image}
  redis_name_option=$(test -n "${redis_container_name}" && echo "--name ${redis_container_name}")
  redis_port_option=$(test -n "${redis_port}" && echo "-p ${redis_port}:6379")

  # shellcheck disable=SC2086
  docker run -itd ${redis_name_option} ${redis_port_option} ${redis_image}
}

if ! run_docker_redis; then
  echo "启动redis容器失败"
  exit 1
fi
