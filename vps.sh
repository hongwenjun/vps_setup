#!/bin/bash

# 一键安装wireguard 脚本
wget -qO- git.io/fptwc | bash

# V2Ray官方一键脚本
bash <(curl -L -s https://install.direct/go.sh)

# 一键安装shadowsocks-libev脚本(编译安装)
bash <(curl -L -s git.io/fhExJ) update

# 安装 WireGuard+Speeder+Udp2Raw 和 SS+Kcp+Udp2RAW 配置
bash wgmtu setup
