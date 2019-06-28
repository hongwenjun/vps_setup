#!/bin/bash

# wireguard-install
# WireGuard  installer for Ubuntu 18.04 LTS, Debian 9 and CentOS 7.

# This script will let you setup your own VPN server in no more than a minute, even if you haven't used WireGuard before. 
# It has been designed to be as unobtrusive and universal as possible.


# 一键安装wireguard 脚本
wget -qO- git.io/fptwc | bash


# WireGuard VPN多用户服务端 自动配置脚本 支持IPV6

#############################################################

let port=$RANDOM/2+9999
mtu=1420
ip_list=(2 5 8 178 186 118 158 198 168 9)
ipv6_range="fd08:620c:4df0:65eb::"


# 安装 bash wgmtu 脚本用来设置服务器
wget -O ~/wgmtu  https://raw.githubusercontent.com/hongwenjun/vps_setup/english/wgmtu.sh

# 定义文字颜色
Green="\033[32m"  && Red="\033[31m" && GreenBG="\033[42;37m" && RedBG="\033[41;37m"
Font="\033[0m"  && Yellow="\033[0;33m" && SkyBlue="\033[0;36m"

echo_SkyBlue(){
    echo -e "${SkyBlue}$1${Font}"
}
echo_Yellow(){
    echo -e "${Yellow}$1${Font}"
}
echo_GreenBG(){
    echo -e "${GreenBG}$1${Font}"
}
echo_RedBG(){
    echo -e "${RedBG}$1${Font}"
}

#############################################################

if [[ $# > 0 ]]; then
    num="$1"
    if [[ ${num} -ge 100 ]] && [[ ${num} -le 60000 ]]; then
       port=$num
    fi
fi

host=$(hostname -s)
# 获得服务器ip，自动获取
if [ ! -f '/usr/bin/curl' ]; then
    apt update && apt install -y curl
fi

if [ ! -e '/var/ip_addr' ]; then
   echo -n $(curl -4 ip.sb) > /var/ip_addr
fi
serverip=$(cat /var/ip_addr)

# 安装二维码插件
if [ ! -f '/usr/bin/qrencode' ]; then
    apt -y install qrencode
fi

#############################################################

# 打开ip4/ipv6防火墙转发功能
sysctl_config() {
    sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
    sed -i '/net.ipv6.conf.all.forwarding/d' /etc/sysctl.conf
    sed -i '/net.ipv6.conf.default.accept_ra/d' /etc/sysctl.conf

    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    echo "net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.conf
    echo "net.ipv6.conf.default.accept_ra=2" >> /etc/sysctl.conf
    sysctl -p >/dev/null 2>&1
}
sysctl_config

# wg配置文件目录 /etc/wireguard
mkdir -p /etc/wireguard
chmod 777 -R /etc/wireguard
cd /etc/wireguard

# 然后开始生成 密匙对(公匙+私匙)。
wg genkey | tee sprivatekey | wg pubkey > spublickey
wg genkey | tee cprivatekey | wg pubkey > cpublickey

# 生成服务端配置文件
cat <<EOF >wg0.conf
[Interface]
PrivateKey = $(cat sprivatekey)
Address = 10.0.0.1/24,  ${ipv6_range}1/64
PostUp   = iptables -I FORWARD -i wg0 -j ACCEPT; iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT; ip6tables -I FORWARD -i wg0 -j ACCEPT; ip6tables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
ListenPort = $port
DNS = 8.8.8.8, 2001:4860:4860::8888
MTU = $mtu

[Peer]
PublicKey = $(cat cpublickey)
AllowedIPs = 10.0.0.188/32,  ${ipv6_range}188

EOF

# 生成简洁的客户端配置
cat <<EOF >client.conf
[Interface]
PrivateKey = $(cat cprivatekey)
Address = 10.0.0.188/24,  ${ipv6_range}188/64
DNS = 8.8.8.8, 2001:4860:4860::8888
#  MTU = $mtu
#  PreUp =  start   .\route\routes-up.bat
#  PostDown = start  .\route\routes-down.bat

[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF

# 添加 2-9 号多用户配置
for i in {2..9}
do
    ip=10.0.0.${ip_list[$i]}
    ip6=${ipv6_range}${ip_list[$i]}
    wg genkey | tee cprivatekey | wg pubkey > cpublickey

    cat <<EOF >>wg0.conf
[Peer]
PublicKey = $(cat cpublickey)
AllowedIPs = $ip/32, $ip6

EOF

    cat <<EOF >wg_${host}_$i.conf
[Interface]
PrivateKey = $(cat cprivatekey)
Address = $ip/24, $ip6/64
DNS = 8.8.8.8, 2001:4860:4860::8888

[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF
    cat /etc/wireguard/wg_${host}_$i.conf | qrencode -o wg_${host}_$i.png
done


# 重启wg服务器
wg-quick down wg0
wg-quick up wg0


next() {
    printf "# %-70s\n" "-" | sed 's/\s/-/g'
}

echo -e  "# Windows 客户端配置，请复制配置文本"
cat /etc/wireguard/client.conf       && next
cat /etc/wireguard/wg_${host}_2.conf   && next
cat /etc/wireguard/wg_${host}_3.conf   && next

echo_GreenBG  "#  WireGuard Management Command."
echo_SkyBlue  "Usage: ${GreenBG} bash wgmtu ${SkyBlue} [ setup | remove | vps | bench | -U ] "
echo_SkyBlue                      "                    [ v2ray | vnstat | log | trace | -h ] "