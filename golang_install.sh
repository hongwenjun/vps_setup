#!/usr/bin/env bash

# linux下golang环境搭建自动脚本  by 蘭雅sRGB

# 下载释放go语言安装包

go_tar_gz="go1.12.linux-amd64.tar.gz"

go_url="https://dl.google.com/go/${go_tar_gz}"

wget --no-check-certificate -O ${go_tar_gz}  ${go_url}
tar -xvf  ${go_tar_gz}
rm  ${go_tar_gz}


# go语言 添加环境变量

cat <<EOF >> ~/.profile
export GOROOT=/root/go
export GOPATH=/root/go/work
export PATH=$PATH:/root/go/bin

EOF

source ~/.profile
mkdir -p /root/go/work

# 测试go语言安装

mkdir -p ~/helloworld
cd ~/helloworld

cat <<EOF >> helloworld.go

// Test that we can do page 1 of the C book.

package main

func main() {
    print("hello, world\n")
}
EOF

go build

./helloworld
