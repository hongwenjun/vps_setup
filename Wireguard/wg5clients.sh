#!/bin/bash

#    WireGuard VPN多用户服务端  自动配置脚本

#    本脚本(WireGuard 多用户配置)一键安装短网址
#    wget -qO- https://git.io/fpnQt | bash


#    本脚本适合已经安装 WireGuard VPN 的vps
#    如果你的vps没有安装 WireGuard ，可以用下行命令先安装

#    一键安装wireguard 脚本 debian 9
#    wget -qO- git.io/fptwc | bash

#############################################################

# 定义修改端口号，适合已经安装WireGuard而不想改端口
port=9009
mtu=1200
host=$(hostname -s)

ip_list=(2 8 18 88 188 118 158 198 168 186)

# 获得服务器ip，自动获取
serverip=$(curl -4 icanhazip.com)

#############################################################

# 转到wg配置文件目录
cd /etc/wireguard

# 然后开始生成 密匙对(公匙+私匙)。
wg genkey | tee sprivatekey | wg pubkey > spublickey
wg genkey | tee cprivatekey | wg pubkey > cpublickey

# 生成服务端配置文件
cat <<EOF >wg0.conf
[Interface]
PrivateKey = $(cat sprivatekey)
Address = 10.0.0.1/24 
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = $port
DNS = 8.8.8.8
MTU = $mtu

[Peer]
PublicKey = $(cat cpublickey)
AllowedIPs = 10.0.0.2/32

EOF


# 生成简洁的客户端配置
cat <<EOF >client.conf
[Interface]
PrivateKey = $(cat cprivatekey)
Address = 10.0.0.2/24
DNS = 8.8.8.8
MTU = $mtu
#  PreUp =  start   .\route\routes-up.bat
#  PostDown = start  .\route\routes-down.bat

[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF

# 安装二维码插件
apt -y install qrencode


# 添加 1-9 多用户配置子程序
for i in {1..9}
do
    ip=10.0.0.${ip_list[$i]}
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
MTU = $mtu

[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF
    cat /etc/wireguard/wg_${host}_$i.conf| qrencode -o wg_${host}_$i.png
done


#  vultr 服务商的主机默认网卡是 ens3，使用下面命令修改配置
if [ $host == "vultr" ]; then
    sed -i "s/eth0/ens3/g"  /etc/wireguard/wg0.conf
fi


# 重启wg服务器
wg-quick down wg0
wg-quick up wg0
wg


cat <<EOF >wg5
# 打包10个客户端配置，手机扫描二维码2号配置，PC使用1号配置

next() {
    printf "# %-70s\n" "-" | sed 's/\s/-/g'
}

host=$(hostname -s)

cd  /etc/wireguard/
tar cvf  wg5clients.tar  client*  wg_*
cat /etc/wireguard/wg_${host}_1.conf | qrencode -o - -t ansi256
echo "# 手机扫描二维码2号配置，PC使用配置复制下面文本"

cat /etc/wireguard/client.conf       && next
cat /etc/wireguard/wg_${host}_1.conf   && next
cat /etc/wireguard/wg_${host}_2.conf   && next
cat /etc/wireguard/wg_${host}_3.conf   && next
cat /etc/wireguard/wg_${host}_4.conf   && next

echo "#  wg 查看有效的客户端；删除客户端使用  wg set wg0 peer xxxx_填对应IP的公钥_xxxx remove"
echo "#  再次显示本文本使用 bash wg5 命令，通过下面2种方式获得其他的配置文件，IP也可以用服务器IP"
file=$(md5sum /etc/wireguard/client.conf)  && file=${file:0:6}.tar
echo "#  请浏览器访问   http://10.0.0.1:8000/$file  下载配置文件，需要先连上WG服务器"
echo "#  scp root@10.0.0.1:/etc/wireguard/wg5clients.tar   wg5clients.tar"
cp /etc/wireguard/wg5clients.tar  ~/$file
cd ~  && python -m SimpleHTTPServer 8000 

EOF
cp wg5 ~/wg5
bash wg5
