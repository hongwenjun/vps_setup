#!/bin/bash
# autonet.sh  自动修改interfaces 网卡自动加载

lspci | grep Ethernet
ni=$(ip addr | grep -E en[a-zA-Z0-9] | head -n 1 | awk -F ': '  '{print $2}')
sed -i "s/enp[a-zA-Z0-9]*/${ni}/g"  /etc/network/interfaces
ifup $ni
