#!/bin/bash

# 修改ss-server密码，SS默认不能直接访问，修改第26行  ss-server -s 0.0.0.0 (把原来127.0.0.1 改成4个0)
PASSWORD=srgb.xyz

# 停止原先服务
systemctl stop rc-local

# 安装所需运行库
apt update
apt install -y  libev-dev libc-ares-dev  libmbedtls-dev libsodium-dev

# 下载 ss-server
wget https://raw.githubusercontent.com/hongwenjun/vps_setup/master/ss-server
chmod +x  ss-server  &&  mv ss-server /usr/local/bin/ss-server

# 下载KCPTUN
wget https://github.com/xtaci/kcptun/releases/download/v20181114/kcptun-linux-amd64-20181114.tar.gz
tar xf kcptun-linux-amd64-20181114.tar.gz
mv server_linux_amd64 /usr/bin/kcp-server
rm kcptun-linux-amd64-20181114.tar.gz
rm client_linux_amd64
rm server_linux_amd64

# 下载UDP2RAW
wget https://github.com/wangyu-/udp2raw-tunnel/releases/download/20181113.0/udp2raw_binaries.tar.gz
tar xf udp2raw_binaries.tar.gz
mv udp2raw_amd64 /usr/bin/udp2raw
rm udp2raw* -rf
rm version.txt


sysctl_config() {
    sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
    echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
    sysctl -p >/dev/null 2>&1
}

# 开启 BBR
sysctl_config
lsmod | grep bbr

#安装到启动项 适合debian 9 x64
cat <<EOF >/etc/rc.local
#!/bin/sh -e
#
# rc.local

# SS+KCP+UDP2RAW 加速  端口  8855
ss-server -s 127.0.0.1 -p 40000 -k ${PASSWORD} -m aes-256-gcm -t 300 >> /var/log/ss-server.log &
kcp-server -t "127.0.0.1:40000" -l ":4000" -mode fast2 -mtu 1300  >> /var/log/kcp-server.log &
udp2raw -s -l0.0.0.0:8855 -r 127.0.0.1:4000 -k "passwd" --raw-mode faketcp  >> /var/log/udp2raw.log &

exit 0
EOF

chmod +x /etc/rc.local
systemctl restart rc-local

cat /etc/rc.local

