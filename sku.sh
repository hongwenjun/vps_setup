#!/bin/bash

# 修改ss-server密码，SS默认不能直接访问，修改第26行  ss-server -s 0.0.0.0 (把原来127.0.0.1 改成4个0)
PASSWORD=srgb.xyz

# 停止原先服务
systemctl stop rc-local

# 安装所需运行库
apt update
apt install -y  libev-dev libc-ares-dev  libmbedtls-dev libsodium-dev

# 下载 ss-server
# wget https://raw.githubusercontent.com/hongwenjun/vps_setup/master/ss-server
cp ss-server  /usr/local/bin/ss-server


# 下载KCPTUN
wget https://github.com/xtaci/kcptun/releases/download/v20181114/kcptun-linux-amd64-20181114.tar.gz
tar xf kcptun-linux-amd64-20181002.tar.gz 
mv server_linux_amd64 /usr/bin/kcp-server
rm kcptun-linux-amd64-20181002.tar.gz 
rm client_linux_amd64
rm server_linux_amd64

# 下载UDP2RAW
wget https://github.com/wangyu-/udp2raw-tunnel/releases/download/20181113.0/udp2raw_binaries.tar.gz
tar xf udp2raw_binaries.tar.gz
mv udp2raw_amd64 /usr/bin/udp2raw
rm udp2raw* -rf
rm version.txt

#安装到启动项 适合debian 9 x64

cat <<EOF >/etc/rc.local
#!/bin/sh -e
#
# rc.local

# SS+KCP+UDP2RAW 加速  端口  8855
ss-server -s 127.0.0.1 -p 40000 -k ${PASSWORD} -m aes-256-gcm -t 300 >> /var/log/ss-server.log &
kcp-server -t "127.0.0.1:40000" -l ":4000" -mode fast2 -mtu 1300  >> /var/log/kcp-server.log &
udp2raw -s -l0.0.0.0:8855 -r 127.0.0.1:4000 -k "passwd" --raw-mode faketcp  >> /var/log/udp2raw.log &

# WireGuard + UDP2RAW 伪装 TCP  预留端口  8866
udp2raw -s -l0.0.0.0:8866 -r 127.0.0.1:9009 -k "passwd" --raw-mode faketcp  >> /var/log/wg_udp2raw.log &

exit 0
EOF

chmod +x /etc/rc.local
systemctl restart rc-local

cat /etc/rc.local

