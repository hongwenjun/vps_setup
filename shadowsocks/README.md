- [蘭雅sRGB![](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/youtube.png)频道](https://www.youtube.com/channel/UCupRwki_4n87nrwP0GIBUXA/videos) &nbsp;&nbsp;&nbsp;可以观看相关脚本工具的演示视频!

### 一键安装shadowsocks-libev脚本 For Linux X64 (Debian 8/9/10 Ubuntu 16/18/19 Centos 7)
```
#  极速安装脚本，纯净编译支持多种Linux系统
wget -qO- git.io/fhExJ | bash

# 纯净编译脚本 For Debian / Ubuntu / Centos
https://git.io/ss.ss
```

### 使用: 添加命令行到 /etc/rc.local
```
# -p 端口 -k 密码 -m 协议 -s 服务IP                # IPv6 支持参数 -s ::0
ss-server -s 0.0.0.0 -p 40000 -k ${PASSWORD} -m aes-256-gcm -t 300 -s ::0 >> /var/log/ss-server.log &
```
### 基于alipine构建的shadowsocks-libev服务 -- Docker安装
    https://hub.docker.com/r/taterli/shadowsocks-tiny

### V2Ray和Shadowsocks配置显示二维码  短网址: https://git.io/v2ray.ss
![](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/v2ray/v2ray.ss.png)

----

## 手工编译安装命令行方法
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
# rm shadowsocks-libev -rf
```
----
## 极速安装脚本，纯净编译支持多种Linux系统 源码示例
```
#!/bin/bash
# ss-libev  install.sh   URL: https://git.io/ss.inst
# Usage: wget -qO- git.io/ss.inst | bash

# Pure Compilation Script For Debian / Ubuntu.     URL: https://git.io/ss.ss
# Download the binary release of Pure Compilation. URL: https://git.io/ss.tgz

wget -O ~/ss.tgz https://git.io/ss.tgz
cd / && tar xvf  ~/ss.tgz

echo "/usr/local/lib" > /etc/ld.so.conf.d/ss-libev.conf
ldconfig

export PATH=$PATH:/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

ss-server -h

function print_info {
        echo -n -e '\e[1;36m'
        echo -n $1
        echo -e '\e[0m'
}

echo -e ":: Usage: \c"
print_info " ss-server -s 0.0.0.0 -p 8888 -k pw1234  -m aes-256-gcm -t 300 -s ::0 &  "

```
