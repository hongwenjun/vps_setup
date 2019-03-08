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
    cat /etc/rc.local
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
    echo_SkyBlue ">  5. 显示 WireGuard V2ray 和 rc.local 配置"
    echo_SkyBlue ">  6. 退出"
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
        *)
        default_install
        ;;
        esac
}

# 显示文字颜色
GreenBG="\033[42;37m" && Font="\033[0m" && SkyBlue="\033[0;36m"
echo_GreenBG(){
    echo -e "${GreenBG}$1${Font}"
}
echo_SkyBlue(){
    echo -e "${SkyBlue}$1${Font}"
}

start_menu

