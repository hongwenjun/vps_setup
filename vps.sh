#!/bin/bash
# Three-in-One-Step Automated Install WireGuard Shadowsocks V2Ray on Server. URL: https://git.io/vps.setup

# Usage:  bash <(curl -L -s https://git.io/vps.setup)

# Default Three-in-One-Step Automated Installation
default_install(){

    # WireGuard installer
    wget -qO- https://git.io/wireguard.sh | bash

    # Install WireGuard+Speeder+Udp2Raw and SS+Kcp+Udp2RAW Configuration
    bash wgmtu setup

    # Install Shadowsocks & V2Ray
    bash <(curl -L -s https://git.io/v2ray_ss.sh)

}

display_conf(){
    echo
    echo
    echo_SkyBlue "# ======================================="
    echo_GreenBG "# V2ray Server Configuration: /etc/v2ray/config.json"
    cat /etc/v2ray/config.json
    echo
    echo_SkyBlue "# WG+Speed+Udp2Raw and SS+Kcp+Udp2RAW Configuration: /etc/rc.local"
    cat vps_setup.log
    echo_GreenBG "# WireGuard Client Configuration: /etc/wireguard/client.conf"
    cat /etc/wireguard/client.conf
}

base_tools(){
    # Simple Judgment System:  Debian / Centos
    if [ -e '/etc/redhat-release' ]; then
        yum update -y && yum install -y  wget curl vim ca-certificates
    else
        apt update && apt install -y  wget curl vim  ca-certificates
    fi
}

wget_curl(){
    if [[ ! -e /usr/bin/wget ]]; then
        base_tools
    fi
    if [[ ! -e /usr/bin/curl ]]; then
        base_tools
    fi
}

# Setting Menu
start_menu(){
    clear
    echo_GreenBG ">     Open Source Project: https://github.com/hongwenjun/vps_setup    "
    echo_SkyBlue ">  1. Default Three-in-One-Step Automated WireGuard Shadowsocks V2Ray "
    echo_SkyBlue ">  2. Choose to install WireGuard VPN Multi-user Configuration "
    echo_SkyBlue ">  3. Compile install / Update ${RedBG} shadowsocks-libev ${Font}"
    echo_SkyBlue ">  4. Uninstall WireGuard Shadowsocks V2ray Service"
    echo         "-------------------------------------------------------"
    echo_Yellow  ">  5. Display WireGuard V2ray and rc.local Configuration"
    echo_Yellow  ">  6. Exit"
    echo_Yellow  ">  7. WireGuard Management Command: ${RedBG} bash wgmtu "
    echo_Yellow  ">  8. Choose to install ${GreenBG} Shadowsocks and V2Ray ${Yellow} Generate and Display QR_code"
    read -p "Please Enter the Number to Choose (Press Enter to Default):" num
    case "$num" in
        1)
        default_install
        ;;
        2)
        wget -qO- https://git.io/wireguard.sh | bash
        ;;
        3)
        bash <(curl -L -s git.io/fhExJ) update
        ;;
        4)
        bash <(curl -L -s https://install.direct/go.sh) --remove
        bash wgmtu remove
        ;;
        5)
        display_conf
        ;;
        6)
        exit 1
        ;;
        7)
        #  Get WireGuard Management Command : bash wgmtu
        wget -O ~/wgmtu  https://raw.githubusercontent.com/hongwenjun/vps_setup/english/wgmtu.sh
        bash wgmtu
        ;;
        8)
        bash <(curl -L -s https://git.io/v2ray_ss.sh)
        ;;
        *)
        default_install
        ;;
        esac
}

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

# Now, install wg ss v2 wget curl
wget_curl
start_menu

