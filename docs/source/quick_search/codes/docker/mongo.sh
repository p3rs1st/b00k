#!/bin/bash
set -e

# 可修改参数
mongo_image=mongo          # mongo镜像
mongo_container_name=mongo # mongo容器名称
mongo_port=27017           # mongo映射到宿主机的端口
# 可修改参数结束

ARGS=$(getopt -o "" -l "mongo_image:,mongo_container_name::,mongo_port::" -- "$@")

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

function run_docker_mongo() {
  docker pull ${mongo_image}
  mongo_name_option=$(test -n "${mongo_container_name}" && echo "--name ${mongo_container_name}")
  mongo_port_option=$(test -n "${mongo_port}" && echo "-p ${mongo_port}:27017")

  # shellcheck disable=SC2086
  docker run -itd ${mongo_name_option} ${mongo_port_option} ${mongo_image}
}

if ! run_docker_mongo; then
  echo "启动mongo容器失败"
  exit 1
fi
