#!/bin/bash

echo -e "WireGuard 修复MTU过低，导致网速下降，修改WG服务器端MTU值，默认值 MTU = 1420"
echo -e "WireGuard 客户端可以MTU参数自动，请把客户段的MTU行注释掉。"
read -p "请输入数字(1200--1500): " num

if [[ ${num} -ge 1200 ]] && [[ ${num} -le 1500 ]]; then
   mtu=$num
else
   mtu=1420	
fi
	
wg-quick down wg0
sed -i "s/MTU = .*$/MTU = ${mtu}/g"  /etc/wireguard/wg0.conf

wg-quick up wg0
