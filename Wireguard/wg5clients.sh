#!/bin/bash

#    WireGuard VPN多用户服务端  自动配置脚本

#    本脚本(WireGuard 多用户配置)一键安装短网址
#    wget -qO- https://git.io/fpnQt | bash


#    本脚本适合已经安装 WireGuard VPN 的vps
#    如果你的vps没有安装 WireGuard ，可以用下行命令先安装

#    一键安装wireguard 脚本 debian 9
#    wget -qO- git.io/fptwc | bash

#   vultr 服务商的主机默认网卡是 ens3，脚本执行完成，还要替换网卡名
#   sed -i "s/eth0/ens3/g"  /etc/wireguard/wg0.conf

#############################################################

# 定义修改端口号，适合已经安装WireGuard而不想改端口
port=9009



# 获得服务器ip，自动获取
serverip=$(curl -4 icanhazip.com)

#############################################################

# 转到wg配置文件目录
cd /etc/wireguard

# 然后开始生成 密匙对(公匙+私匙)。
wg genkey | tee sprivatekey | wg pubkey > spublickey
wg genkey | tee cprivatekey1 | wg pubkey > cpublickey1
wg genkey | tee cprivatekey2 | wg pubkey > cpublickey2
wg genkey | tee cprivatekey3 | wg pubkey > cpublickey3
wg genkey | tee cprivatekey4 | wg pubkey > cpublickey4
wg genkey | tee cprivatekey5 | wg pubkey > cpublickey5


# 生成服务端 多用户配置文件
cat <<EOF >wg0.conf
[Interface]
PrivateKey = $(cat sprivatekey)
Address = 10.0.0.1/24 
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = $port
DNS = 8.8.8.8
MTU = 1200

[Peer]
PublicKey = $(cat cpublickey1)
AllowedIPs = 10.0.0.2/32

[Peer]
PublicKey = $(cat cpublickey2)
AllowedIPs = 10.0.0.8/32

[Peer]
PublicKey = $(cat cpublickey3)
AllowedIPs = 10.0.0.18/32

[Peer]
PublicKey = $(cat cpublickey4)
AllowedIPs = 10.0.0.88/32

[Peer]
PublicKey = $(cat cpublickey5)
AllowedIPs = 10.0.0.188/32

EOF


# 生成简洁的客户端配置
cat <<EOF >client.conf
[Interface]
PrivateKey = $(cat cprivatekey1)
Address = 10.0.0.2/24
DNS = 8.8.8.8
MTU = 1200
PreUp =  start   .\route\routes-up.bat
PostDown = start  .\route\routes-down.bat

[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF

cat <<EOF >client_2.conf
[Interface]
PrivateKey = $(cat cprivatekey2)
Address = 10.0.0.8/24
DNS = 8.8.8.8
MTU = 1200

[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF

cat <<EOF >client_3.conf
[Interface]
PrivateKey = $(cat cprivatekey3)
Address = 10.0.0.18/24
DNS = 8.8.8.8
MTU = 1200

[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF


cat <<EOF >client_4.conf
[Interface]
PrivateKey = $(cat cprivatekey4)
Address = 10.0.0.88/24
DNS = 8.8.8.8
MTU = 1200

[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF


cat <<EOF >client_5.conf
[Interface]
PrivateKey = $(cat cprivatekey5)
Address = 10.0.0.188/24
DNS = 8.8.8.8
MTU = 1200

[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF

# 安装二维码插件
apt -y install qrencode
cat /etc/wireguard/client.conf | qrencode -o client.png
cat /etc/wireguard/client_2.conf | qrencode -o client_2.png
cat /etc/wireguard/client_3.conf | qrencode -o client_3.png
cat /etc/wireguard/client_4.conf | qrencode -o client_4.png
cat /etc/wireguard/client_5.conf | qrencode -o client_5.png

# 重启wg服务器
wg-quick down wg0
wg-quick up wg0
wg


cat <<EOF >wg5
# 打包5个客户端配置，手机扫描二维码2号配置，PC使用1号配置
cd  /etc/wireguard/
tar cvf  wg5clients.tar client*
cat /etc/wireguard/client_2.conf | qrencode -o - -t ansi256
echo "# 手机扫描二维码2号配置，PC使用1号配置请复制下面文本"
cat /etc/wireguard/client.conf
echo "#  你有2种方式获得5个配置，可以使用下面2种命令行，再次显示本文本使用 bash wg5"
echo "#  scp root@10.0.0.1:/etc/wireguard/wg5clients.tar   wg5clients.tar"
echo "#  curl --upload-file ./wg5clients.tar  https://transfer.sh/wg5clients.tar"

EOF
cp wg5 ~/wg5
bash wg5
