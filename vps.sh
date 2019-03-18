#!/bin/bash

# 默认安装 WireGuard Shadowsocks V2Ray 服务端三合一脚本
default_install(){

    # 一键安装wireguard 脚本
    wget -qO- git.io/fptwc | bash

    # V2Ray官方一键脚本
    bash <(curl -L -s https://install.direct/go.sh)

    # 一键安装shadowsocks-libev脚本
    wget -qO- git.io/fhExJ | bash

    # 安装 WireGuard+Speeder+Udp2Raw 和 SS+Kcp+Udp2RAW 配置
    bash wgmtu setup
}

display_conf(){
    echo
    echo
    echo_SkyBlue "# ======================================="
    echo_GreenBG "# V2ray 服务端配置 /etc/v2ray/config.json"
    cat /etc/v2ray/config.json
    echo
    echo_SkyBlue "# WG+Speed+Udp2Raw 和 SS+Kcp+Udp2RAW 配置 /etc/rc.local"
    cat vps_setup.log
    echo_GreenBG "# WireGuard 客户端配置 /etc/wireguard/client.conf"
    cat /etc/wireguard/client.conf
}

# 设置菜单
start_menu(){
    clear
    echo_GreenBG ">  开源项目:  https://github.com/hongwenjun/vps_setup  "
    echo_SkyBlue ">  1. 默认安装 WireGuard Shadowsocks V2Ray 服务端三合一"
    echo_SkyBlue ">  2. 选择安装 WireGuard 多用户服务端"
    echo_SkyBlue ">  3. 选择安装 Shadowsocks 编译/更新"
    echo_SkyBlue ">  4. 卸载 WireGuard Shadowsocks V2ray 服务"
    echo_Yellow  ">  5. 显示 WireGuard V2ray 和 rc.local 配置"
    echo_Yellow  ">  6. 退出"
    echo_Yellow  ">  7. WireGuard 管理命令 ${RedBG} bash wgmtu "
    echo_Yellow  ">  8. 选择安装${GreenBG} Shadowsocks 和 V2Ray 配置显示二维码"
    read -p "请输入数字:" num
    case "$num" in
        1)
        default_install
        ;;
        2)
        wget -qO- git.io/fptwc | bash
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
        bash <(curl -L -s https://git.io/wgmtu)
        wget -O wgmtu https://git.io/wgmtu  >/dev/null 2>&1
        ;;
        8)
        bash <(curl -L -s https://git.io/v2ray.ss)
        ;;
        *)
        default_install
        ;;
        esac
}

# 显示文字颜色
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

start_menu

