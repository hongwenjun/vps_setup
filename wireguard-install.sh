#!/bin/bash
# WireGuard  installer for Ubuntu 18.04 LTS, Debian 9 and CentOS 7.

# Usage:  wget -qO- https://git.io/wireguard.sh | bash

# This script will let you setup your own VPN server in no more than a minute, even if you haven't used WireGuard before.
# It has been designed to be as unobtrusive and universal as possible.

wireguard_install(){
    if [ -e /etc/centos-release ]; then
        DISTRO="CentOS"
    elif [ -e /etc/debian_version ]; then
        DISTRO=$( lsb_release -is )
    else
        echo "Your distribution is not supported (yet)"
        exit
    fi

    if [ "$DISTRO" == "Ubuntu" ]; then
        apt update
        apt install software-properties-common -y
        echo .read | add-apt-repository ppa:wireguard/wireguard
        apt update
        apt install linux-headers-$(uname -r) wireguard resolvconf qrencode -y

    elif [ "$DISTRO" == "Debian" ]; then
        echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list
        printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' > /etc/apt/preferences.d/limit-unstable
        apt update
        apt install linux-headers-$(uname -r) wireguard resolvconf iptables qrencode -y

    elif [ "$DISTRO" == "CentOS" ]; then
        curl -Lo /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
        yum install -y epel-release
        yum install -y wireguard-dkms wireguard-tools
        yum -y install qrencode iptables-services

        systemctl stop firewalld  && systemctl disable firewalld
        systemctl enable iptables && systemctl start iptables
        iptables -F  && service iptables save && service iptables restart

    fi

    mkdir -p /etc/wireguard
    cd /etc/wireguard
    wg genkey | tee sprivatekey | wg pubkey > spublickey
    wg genkey | tee cprivatekey | wg pubkey > cpublickey
    chmod 777 -R /etc/wireguard
    systemctl enable wg-quick@wg0
}

if [ ! -f '/usr/bin/wg' ]; then
    wireguard_install
fi

# WireGuard VPN  Multi-user Configuration Script, Support IPV6
#############################################################
let port=$RANDOM/2+9999
mtu=1420
ip_list=(2 5 8 178 186 118 158 198 168 9)
ipv6_range="fd08:620c:4df0:65eb::"


#  Get WireGuard Management Command : bash wgmtu
wget -O ~/wgmtu  https://raw.githubusercontent.com/hongwenjun/vps_setup/english/wgmtu.sh

# Definition Display Text Color
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

if [ ! -f '/usr/bin/curl' ]; then
    apt update && apt install -y curl
fi
# Auto Get Server IP addr
if [ ! -e '/var/ip_addr' ]; then
   echo -n $(curl -4 ip.sb) > /var/ip_addr
fi
serverip=$(cat /var/ip_addr)

#############################################################

# Open ip4/ipv6 firewall forwarding function
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

# Wg configuration Path:  /etc/wireguard
mkdir -p /etc/wireguard
chmod 777 -R /etc/wireguard
cd /etc/wireguard

# Start generating a key pair (public key + private key)
wg genkey | tee sprivatekey | wg pubkey > spublickey
wg genkey | tee cprivatekey | wg pubkey > cpublickey

# Generate a server configuration file
cat <<EOF >wg0.conf
[Interface]
PrivateKey = $(cat sprivatekey)
Address = 10.0.0.1/24,  ${ipv6_range}1/64
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = $port
DNS = 8.8.8.8, 2001:4860:4860::8888
MTU = $mtu

[Peer]
PublicKey = $(cat cpublickey)
AllowedIPs = 10.0.0.188/32,  ${ipv6_range}188

EOF

# Generate a clean client configuration
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

# Add 2-9 multi-user configuration
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

# If the vps network card is not eth0, modify it to the actual network card
ni=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
if [ $ni != "eth0" ]; then
    sed -i "s/eth0/${ni}/g"  /etc/wireguard/wg0.conf
fi

# restart WG server
wg-quick down wg0
wg-quick up wg0

# WG Operating status &
wg
ls /etc/wireguard/wg_*

next() {
    printf "# %-70s\n" "-" | sed 's/\s/-/g'
}

echo
echo_SkyBlue  ":: Windows Client configuration, Please copy the conf text."
cat /etc/wireguard/client.conf       && next
cat /etc/wireguard/wg_${host}_2.conf   && next
cat /etc/wireguard/wg_${host}_3.conf   && next

echo_RedBG   " One-Step Automated Install WireGuard Script For Debian_9 Ubuntu Centos_7 "
echo_GreenBG "      Open Source Project: https://github.com/hongwenjun/vps_setup        "

echo_Yellow  ":: WireGuard Management Command."
echo_SkyBlue  "Usage: ${GreenBG} bash wgmtu ${SkyBlue} [ setup | remove | vps | bench | -U ] "
echo_SkyBlue                      "                    [ v2ray | vnstat | log | trace | -h ] "
