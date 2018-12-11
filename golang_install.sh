#!/usr/bin/env bash

# linux下golang环境搭建自动脚本  by 蘭雅sRGB

# 下载释放go语言安装包

go_tar_gz="go1.11.2.linux-amd64.tar.gz"

go_url="https://dl.google.com/go/${go_tar_gz}"

wget --no-check-certificate -O ${go_tar_gz}  ${go_url}
tar -xvf  ${go_tar_gz}
mv go   /usr/local/.
rm  ${go_tar_gz}


# go语言 添加环境变量

cat <<EOF >> /etc/profile

export PATH="$PATH:/usr/local/go/bin"

EOF

source /etc/profile


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
