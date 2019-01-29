#!/bin/bash

PASSWORD=srgb.xyz

# 客户端配置参考(前两个可以路由运行,但是最后一个最好不要,路由性能有限,会让你觉得网络卡炸的.)
# 在本地windows 运行udp2raw 和 kcp-client，假设server ip是144.202.95.95：
# ./udp2raw -c -r144.202.95.95:8855 -l0.0.0.0:4000 -k"passwd" --raw-mode faketcp
# ./kcp-client -r "127.0.0.1:4000" -l ":3322" -mode fast2 -mtu 1300
# SS 客户端 => 混淆:aes-256-gcm, IP:127.0.0.1:3322, 密码:刚才设置的密码.
# 加速的 SSH登陆  # ssh -p 3322 root@127.0.0.1

# 远程服务器参数参考 ss-server   udp2raw  kcp-server 参考
# ss-server -s 127.0.0.1 -p 40000 -k xxx -m aes-256-gcm -t 300
# udp2raw -s -l0.0.0.0:8855 -r 127.0.0.1:4000 -k "passwd" --raw-mode faketcp
# kcp-server -t "127.0.0.1:40000" -l ":4000" -mode fast2 -mtu 1300

# 加速SSH使用参数
# kcp-server -t "127.0.0.1:22"  -l ":4000"  -mode fast2 -mtu 1300




# 安装基本软件
apt update
apt install -y gcc g++ git gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake libmbedtls-dev libsodium-dev

#下载代码
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive

#编译安装
./autogen.sh
./configure
make
make install
cd ..
rm shadowsocks-libev -rf

#下载KCPTUN
wget https://github.com/xtaci/kcptun/releases/download/v20190109/kcptun-linux-amd64-20190109.tar.gz
tar xf kcptun-linux-amd64-20190109.tar.gz 
mv server_linux_amd64 /usr/bin/kcp-server
rm kcptun-linux-amd64-20190109.tar.gz 
rm client_linux_amd64
rm server_linux_amd64

#下载UDP2RAW
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


#安装到启动项

cat <<EOF >/etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

#  SS+KCP+UDP2RAW 加速  端口  8855
ss-server -s 127.0.0.1 -p 40000 -k ${PASSWORD} -m aes-256-gcm -t 300 >> /var/log/ss-server.log &
kcp-server -t "127.0.0.1:40000" -l ":4000" -mode fast2 -mtu 1300  >> /var/log/kcp-server.log &
udp2raw -s -l0.0.0.0:8855 -r 127.0.0.1:4000 -k "passwd" --raw-mode faketcp  >> /var/log/udp2raw.log &

# WireGuard + UDP2RAW 伪装 TCP  预留端口  8866
udp2raw -s -l0.0.0.0:8866 -r 127.0.0.1:9009 -k "passwd" --raw-mode faketcp  >> /var/log/wg_udp2raw.log &

exit 0
EOF

chmod +x /etc/rc.local
systemctl restart rc-local
