#!/bin/bash

# 安装所需运行库
apt update
apt install -y  libev-dev libc-ares-dev  libmbedtls-dev libsodium-dev

# 下载 ss-server
wget https://raw.githubusercontent.com/hongwenjun/vps_setup/master/ss-server
chmod +x  ss-server  &&  mv ss-server /usr/local/bin/ss-server

sysctl_config() {
    sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
    echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
    sysctl -p >/dev/null 2>&1
}

# 开启 BBR
sysctl_config
lsmod | grep bbr

# 定义文字颜色
Green="\033[32m"  && Red="\033[31m" && GreenBG="\033[42;37m" && RedBG="\033[41;37m" && Font="\033[0m"

echo -e "${RedBG}:: 注意 一键安装 SS+Kcp+Udp2Raw 脚本 快速安装 只适合 debian 9 ,其他系统，须编译安装 SS ${Font}"
echo   "# 设置 WireGuard + Speeder + Udp2Raw 和 Shadowsocks + Kcp + Udp2RAW 一键脚本"
echo -e  "${GreenBG} wget -qO- https://git.io/fpKnF | bash  ${Font} 或者 使用 ${RedBG} bash wgmtu   菜单进入${Font}"
