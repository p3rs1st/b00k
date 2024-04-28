# 构建第一步 build基本文件
FROM golang:alpine AS build

ENV GIN_MODE=release
ENV PORT=9000

WORKDIR /usr/src/app

COPY go.mod go.sum ./
RUN go env -w GOPROXY=https://goproxy.cn,direct
RUN go mod download && go mod verify

# 拷贝使用的相关文件, 如配置文件
COPY . .
RUN go build -v -o app ./main.go

# 构建第二步 仅拷贝必要文件
# alpine为包含基本功能的最小单位
FROM alpine

COPY --from=build /usr/src/app /

EXPOSE $PORT

ENTRYPOINT ["/app"]
