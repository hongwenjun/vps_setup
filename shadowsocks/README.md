# 一键安装shadowsocks-libev脚本 For Debian_9  Ubuntu  Centos_7
```
# 一键安装shadowsocks-libev 也可下载使用update参数
wget -qO- git.io/fhExJ | bash

```
### 使用: 添加命令行到 /etc/rc.local
```
# -p 端口 -k 密码 -m 协议 -s 服务ip
ss-server -s 127.0.0.1 -p 40000 -k ${PASSWORD} -m aes-256-gcm -t 300 >> /var/log/ss-server.log &
```
### 基于alipine构建的shadowsocks-libev服务 -- Docker安装
  https://hub.docker.com/r/taterli/shadowsocks-tiny

-----
### Debian 9 & Ubuntu 18 安装编译环境和运行库
```
apt update
apt install -y gcc g++ git gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake libmbedtls-dev libsodium-dev
```

### Cetons 安装编译环境和运行库
```
yum install epel-release git -y
yum install gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto c-ares-devel libev-devel libsodium-devel mbedtls-devel -y
```

### 下载shadowsocks代码
```
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive
```
### 编译安装ss-server
```
./autogen.sh
./configure
make
make install
cd ..
rm shadowsocks-libev -rf
```
