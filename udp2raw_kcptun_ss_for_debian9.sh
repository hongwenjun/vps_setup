#!/bin/bash

PASSWORD=srgb.xyz

# 客户端配置参考(前两个可以路由运行,但是最后一个最好不要,路由性能有限,会让你觉得网络卡炸的.)
#
# udp2raw -c -r35.231.111.220:40002 -l0.0.0.0:40003 -kxxx --raw-mode faketcp -a --cipher-mode none --auth-mode simple
# kcp-client  -l :9527 -r 10.0.0.1:40003 -key "xxx" -crypt none -mode fast3
# SS 客户端 => 混淆:aes-256-gcm,IP:127.0.0.1:9527,密码:刚才设置的密码.


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
wget https://github.com/xtaci/kcptun/releases/download/v20180316/kcptun-linux-amd64-20180316.tar.gz
tar xf kcptun-linux-amd64-20180316.tar.gz 
mv server_linux_amd64 /usr/bin/kcp-server
rm kcptun-linux-amd64-20180316.tar.gz 
rm client_linux_amd64
rm server_linux_amd64

#下载UDP2RAW
wget https://github.com/wangyu-/udp2raw-tunnel/releases/download/20180225.0/udp2raw_binaries.tar.gz
tar xf udp2raw_binaries.tar.gz
mv udp2raw_amd64 /usr/bin/udp2raw
rm udp2raw* -rf
rm version.txt

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

ss-server -s 127.0.0.1 -p 40000 -k ${PASSWORD} -m aes-256-gcm -t 300 >> /var/log/ss-server.log &
kcp-server -t "127.0.0.1:40000" -l "127.0.0.1:40001" --mode fast3 --key "${PASSWORD}" --crypt "none"  >> /var/log/kcp-server.log &
udp2raw -s -l0.0.0.0:40002 -r 127.0.0.1:40001 -kxxx --raw-mode faketcp -a --cipher-mode none --auth-mode simple  >> /var/log/udp2raw.log &

exit 0
EOF

chmod +x /etc/rc.local
systemctl restart rc-local
