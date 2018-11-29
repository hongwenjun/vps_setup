#!/bin/bash

#定义文字颜色
Green="\033[32m"  && Red="\033[31m" && GreenBG="\033[42;37m" && RedBG="\033[41;37m" && Font="\033[0m"


echo -e "${GreenBG}WireGuard 修改服务器端MTU值，最大效率加大网速，默认值 MTU = 1420 "
echo -e "WireGuard 客户端可以MTU参数自动，请修改电脑客户端TunSafe配置把MTU行注释掉。${Font}"
read -p "请输入数字{RedBG}(1200--1500):${Font} " num

if [[ ${num} -ge 1200 ]] && [[ ${num} -le 1500 ]]; then
   mtu=$num
else
   mtu=1420	
fi
	
wg-quick down wg0
sed -i "s/MTU = .*$/MTU = ${mtu}/g"  /etc/wireguard/wg0.conf

wg-quick up wg0
