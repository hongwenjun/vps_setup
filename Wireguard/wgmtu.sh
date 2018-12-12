#!/bin/bash

# 定义文字颜色
Green="\033[32m"  && Red="\033[31m" && GreenBG="\033[42;37m" && RedBG="\033[41;37m" && Font="\033[0m"

# 修改mtu数值
setmtu(){
    echo -e "${GreenBG}WireGuard 修改服务器端MTU值，最大效率加大网速，默认值 MTU = 1420 "
    echo -e "WireGuard 客户端可以MTU参数自动，请修改电脑客户端TunSafe配置把MTU行注释掉。${Font}"
    read -p "请输入数字(1200--1500): " num

    if [[ ${num} -ge 1200 ]] && [[ ${num} -le 1500 ]]; then
       mtu=$num
    else
       mtu=1420
    fi

    wg-quick down wg0
    sed -i "s/MTU = .*$/MTU = ${mtu}/g"  /etc/wireguard/wg0.conf

    wg-quick up wg0

    echo -e "${RedBG}    服务器端MTU值已经修改!    ${Font}"

}


# 修改端口号
setport(){
    echo -e "${GreenBG}修改 WireGuard 服务器端端口号，客户端要自行修改${Font}"
    read -p "请输入数字(100--60000): " num

    if [[ ${num} -ge 100 ]] && [[ ${num} -le 60000 ]]; then
       port=$num
       wg-quick down wg0
       sed -i "s/ListenPort = .*$/ListenPort = ${port}/g"  /etc/wireguard/wg0.conf
       wg-quick up wg0
       echo -e "${RedBG}    端口号已经修改!    ${Font}"
    else
       echo -e "${RedBG}    没有修改端口号!    ${Font}"
    fi

}

wgconf()
{
    echo -e "${RedBG}:: 显示手机客户端二维码  (如改端口,请先菜单5重置客户端配置)  ${Font}"
    read -p "请输入数字(2-9)，默认2号: " x

    if [[ ${x} -ge 2 ]] && [[ ${x} -le 9 ]]; then
       i=$x
    else
       i=2
    fi

    host=$(hostname -s)

    cat /etc/wireguard/wg_${host}_$i.conf | qrencode -o - -t UTF8

    echo -e "${GreenBG}:: 配置文件: wg_${host}_$i.conf 生成二维码，请用手机客户端扫描使用 ${Font}"

}

wg_clients()
{
    echo -e "${RedBG}:: 注意原来的客户端配置都会删除，按 Ctrl+ C 可以紧急撤销  ${Font}"
    read -p "请任意键继续:" xx
    wget -O ~/wg100  https://git.io/fp6r0    >/dev/null 2>&1
    bash ~/wg100
}

udp2raw()
{
    wget -qO- https://git.io/fpKnF | bash
    echo -e "${RedBG}:: WireGuard 使用 Udp2Raw 需要把 MTU 设置成1200-1300  ${Font}"
    echo -e "${GreenBG}:: 您可以在本脚本基础上，修改成加速脚本！... 你懂的！${Font}"
}

# 隐藏功能:从源VPS克隆服务端配置，共用客户端配置
scp_conf()
{
    echo -e "${RedBG}:: 警告: 警告: 警告: VPS服务器已经被GFW防火墙关照，按 Ctrl+ C 可以紧急逃离！  ${Font}"
    echo  "隐藏功能:从源VPS克隆服务端配置，共用客户端配置"
    read -p "请输入源VPS的IP地址(域名):"  vps_ip
    cmd="scp root@${vps_ip}:/etc/wireguard/*  /etc/wireguard/. "
    echo -e "${RedBG}#  ${cmd}  ${Font}   现在运行scp命令，按提示输入yes，原vps的root密码"
    ${cmd}

    wg-quick down wg0   >/dev/null 2>&1
    wg-quick up wg0     >/dev/null 2>&1
    echo -e "${RedBG}    WG服务器端，已经使用源vps的配置启动!    ${Font}"
}

# 设置菜单
start_menu(){
    echo -e "${RedBG}   一键安装 WireGuard 脚本 For Debian_9 Ubuntu Centos_7   ${Font}"
    echo -e "${GreenBG}    开源项目：https://github.com/hongwenjun/vps_setup    ${Font}"
    echo -e "${Green}>  1. 显示手机客户端二维码"
    echo -e ">  2. 修改 WireGuard 服务器端 MTU 值"
    echo -e ">  3. 修改 WireGuard 端口号  (如改端口,菜单5重置客户端配置)"
    echo -e ">  4. 安装Udp2Raw服务TCP伪装 WireGuard 服务端设置"
    echo -e ">  5. 重置 WireGuard 客户端配置和数量，方便修改过端口或者机场大佬"
    echo -e ">  6. 退出设置${Font}"
    echo
    read -p "请输入数字(1-6):" num
    case "$num" in
        1)
        wgconf
        ;;
        2)
        setmtu
        ;;
        3)
        setport
        ;;
        4)
        udp2raw
        ;;
        5)
        wg_clients
        ;;
        6)
        exit 1
        ;;
        88)
        scp_conf
        ;;
        *)
        echo
        echo "请输入正确数字"
        ;;
        esac
}

start_menu
