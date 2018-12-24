#!/bin/bash

# 服务器 IP 和 端口
port=$(wg | grep 'listening port:' | awk '{print $3}')
serverip=$(curl -4 icanhazip.com)
host=$(hostname -s)

#定义文字颜色
Green="\033[32m"  && Red="\033[31m" && GreenBG="\033[42;37m" && RedBG="\033[41;37m" && Font="\033[0m"

#定义提示信息
Info="${Green}[信息]${Font}"  &&  OK="${Green}[OK]${Font}"  &&  Error="${Red}[错误]${Font}"

# 转到wg配置文件目录
cd /etc/wireguard
cp wg0.conf  conf.wg0.bak

echo -e   "${RedBG}重置 WireGuard 客户端配置数量，方便修改过端口或者机场大佬${Font}"
echo -e "${GreenBG}    开源项目：https://github.com/hongwenjun/vps_setup    ${Font}"
echo

echo -e "${GreenBG} 请输入客户端配置数量 ${Font}"
read -p "请输入数字(3--218): " num_x

if [[ ${num_x} -ge 3 ]] && [[ ${num_x} -le 218 ]]; then
 wg_num=OK
else
  num_x=5
fi

# 删除原1号配置，让IP和配置号对应; 保留原来服务器的端口等配置
rm  /etc/wireguard/wg_${host}_*   >/dev/null 2>&1
head -n 13  conf.wg0.bak > wg0.conf

# 修改用户配置数量
for i in `seq 2 250`
do
    ip=10.0.0.${i}
    wg genkey | tee cprivatekey | wg pubkey > cpublickey

    cat <<EOF >>wg0.conf
[Peer]
PublicKey = $(cat cpublickey)
AllowedIPs = $ip/32

EOF

    cat <<EOF >wg_${host}_$i.conf
[Interface]
PrivateKey = $(cat cprivatekey)
Address = $ip/24
DNS = 8.8.8.8

[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF
    cat /etc/wireguard/wg_${host}_$i.conf| qrencode -o wg_${host}_$i.png

    if [ $i -ge $num_x ]; then
        break
    fi
done

# 重启wg服务器
wg-quick down wg0  >/dev/null 2>&1
wg-quick up wg0    >/dev/null 2>&1
wg

cat /etc/wireguard/client.conf
cat /etc/wireguard/wg_${host}_2.conf
cat /etc/wireguard/wg_${host}_3.conf
echo -e "${RedBG}   一键安装 WireGuard 脚本 For Debian_9 Ubuntu Centos_7   ${Font}"
echo -e "${GreenBG}     开源项目：https://github.com/hongwenjun/vps_setup    ${Font}"
echo
echo -e "# ${Info} 使用${GreenBG} bash wg5 ${Font} 命令，可以临时网页下载配置和二维码"
echo -e "# ${Info} 使用${GreenBG} bash wgmtu ${Font} 命令，重置客户端数量，设置服务器端MTU数值或服务端口号 "
