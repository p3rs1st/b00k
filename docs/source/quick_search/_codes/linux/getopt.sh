#!/bin/bash
# -o 指定短选项，-l指定长选项，长选项之间逗号分隔
# 选项后面不跟冒号表示没有参数
# 选项后面跟一个冒号表示必须有一个参数
# 选项后面跟两个冒号表示可选参数，短选项的可选参数需要紧贴选项-cop，长选项的可选参数需要使用'=' --longopt3=op
set -e

ARGS=$(getopt -o "a:bc::" -l "long-opt1:,long_opt2,longopt3::" -- "$@")

eval set -- "${ARGS}"

while true; do
    case $1 in
    -a | --long-opt1)
        echo "短选项或长选项后面跟一个参数, 参数为${2}"
        shift 2
        ;;
    -b)
        echo "短选项后面不跟参数"
        shift 1
        ;;
    -c | --longopt3)
        case $2 in
        "")
            echo "短选项或长选项后面跟零个可选参数"
            shift 2
            ;;
        *)
            echo "短选项或长选项后面跟一个可选参数, 参数为${2}"
            shift 2
            ;;
        esac
        ;;
    --long_opt2)
        echo "长选项后面不跟参数"
        shift 1
        ;;
    --)
        shift
        break
        ;;
    esac
done
