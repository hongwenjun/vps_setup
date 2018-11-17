#!/bin/bash

# 配置步骤 WireGuard服务端


cd /etc/wireguard
# 然后开始生成 密匙对(公匙+私匙)。
wg genkey | tee sprivatekey | wg pubkey > spublickey
wg genkey | tee cprivatekey1 | wg pubkey > cpublickey1
wg genkey | tee cprivatekey2 | wg pubkey > cpublickey2
wg genkey | tee cprivatekey3 | wg pubkey > cpublickey3
wg genkey | tee cprivatekey4 | wg pubkey > cpublickey4
wg genkey | tee cprivatekey5 | wg pubkey > cpublickey5


# 获得服务器ip
serverip=$(curl -4 icanhazip.com)


# 生成服务端 多用户配置文件
cat <<EOF >wg0.conf
[Interface]
PrivateKey = $(cat sprivatekey)
Address = 10.0.0.1/24 
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = 9009
DNS = 8.8.8.8
MTU = 1300

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
MTU = 1300

[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:9009
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF

cat <<EOF >client_2.conf
[Interface]
PrivateKey = $(cat cprivatekey2)
Address = 10.0.0.8/24
DNS = 8.8.8.8
MTU = 1300

[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:9009
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF

cat <<EOF >client_3.conf
[Interface]
PrivateKey = $(cat cprivatekey3)
Address = 10.0.0.18/24
DNS = 8.8.8.8
MTU = 1300

[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:9009
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF


cat <<EOF >client_4.conf
[Interface]
PrivateKey = $(cat cprivatekey4)
Address = 10.0.0.88/24
DNS = 8.8.8.8
MTU = 1300

[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:9009
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF


cat <<EOF >client_5.conf
[Interface]
PrivateKey = $(cat cprivatekey5)
Address = 10.0.0.188/24
DNS = 8.8.8.8
MTU = 1300

[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:9009
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF



# 重启wg服务器
wg-quick down wg0
wg-quick up wg0
wg

# 打包客户端 配置
tar cvf  wg5clients.tar client*
curl --upload-file ./wg5clients.tar  https://transfer.sh/wg5clients.tar

echo '按提示的网址下载客户端包，保留2星期'

