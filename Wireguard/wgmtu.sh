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
    
    echo -e "${RedBG}服务器端MTU值已经修改!${Font}"   
    
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
       echo -e "${RedBG}端口号已经修改!${Font}"   
    else
       echo -e "${RedBG}没有修改端口号!${Font}"             
    fi

}

wgconf(){
bash wg5
}

# 设置菜单
start_menu(){
    echo -e "${Green}1. 显示客户端配置文本，临时网页下载客户端"
    echo -e "2. 修改 WireGuard 服务器端 MTU 值"
    echo -e "3. 修改 WireGuard 端口号"
    echo -e "4. 退出设置${Font}"
    echo
    read -p "请输入数字(1-4):" num
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
	exit 1
	;;
	*)
	clear
	echo "请输入正确数字"
	;;
    esac
}

start_menu
