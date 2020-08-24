# transmission.sh

#!/bin/bash
# 一键安装 transmission 服务

username=admin

# 密码随机，脚本提供修改
passwd=$(date | md5sum  | head -c 6)

rpcport=9091
peerport=51413
downloads=/var/rclone

############################################
# 定义文字颜色
Green="\033[32m"  && Red="\033[31m" && GreenBG="\033[42;37m" && RedBG="\033[41;37m"
Font="\033[0m"  && Yellow="\033[0;33m" && SkyBlue="\033[0;36m"

echo -e "${GreenBG}   一键安装 transmission 服务脚本   ${Yellow}"

echo -e ":: 随机生成密码: ${RedBG} ${passwd} ${Font} 现在可修改; "
read -p ":: 请输入你要的密码(按回车不修改): " -t 30 new

if [[ ! -z "${new}" ]]; then
    passwd="${new}"
    echo -e "${SkyBlue}:: 修改后新密码: ${GreenBG} ${passwd} ${Font}"
fi


# 程序安装
apt update && apt -y install transmission transmission-daemon git 

# 停止服务
systemctl stop  transmission-daemon

# 生成 transmission 配置

cat <<EOF > /etc/transmission-daemon/settings.json
{
   "alt-speed-down": 50,
   "alt-speed-enabled": false,
   "alt-speed-time-begin": 540,
   "alt-speed-time-day": 127,
   "alt-speed-time-enabled": false,
   "alt-speed-time-end": 1020,
   "alt-speed-up": 50,
   "bind-address-ipv4": "0.0.0.0",
   "bind-address-ipv6": "::",
   "blocklist-enabled": false,
   "blocklist-url": "http://www.example.com/blocklist",
   "cache-size-mb": 4,
   "dht-enabled": false,
   "download-dir": "${downloads}",
   "download-queue-enabled": true,
   "download-queue-size": 50,
   "encryption": 1,
   "idle-seeding-limit": 30,
   "idle-seeding-limit-enabled": false,
   "incomplete-dir": "${downloads}",
   "incomplete-dir-enabled": false,
   "lpd-enabled": false,
   "message-level": 1,
   "peer-congestion-algorithm": "",
   "peer-id-ttl-hours": 6,
   "peer-limit-global": 960,
   "peer-limit-per-torrent": 120,
   "peer-port": ${peerport},
   "peer-port-random-high": 65535,
   "peer-port-random-low": 49152,
   "peer-port-random-on-start": false,
   "peer-socket-tos": "default",
   "pex-enabled": false,
   "port-forwarding-enabled": true,
   "preallocation": 1,
   "prefetch-enabled": true,
   "queue-stalled-enabled": true,
   "queue-stalled-minutes": 30,
   "ratio-limit": 2,
   "ratio-limit-enabled": false,
   "rename-partial-files": true,
   "rpc-authentication-required": true,
   "rpc-bind-address": "0.0.0.0",
   "rpc-enabled": true,
   "rpc-host-whitelist": "",
   "rpc-host-whitelist-enabled": true,
   "rpc-password": "${passwd}",
   "rpc-port": ${rpcport},
   "rpc-url": "/transmission/",
   "rpc-username": "${username}",
   "rpc-whitelist": "0.0.0.0",
   "rpc-whitelist-enabled": false,
   "scrape-paused-torrents-enabled": true,
   "script-torrent-done-enabled": false,
   "script-torrent-done-filename": "",
   "seed-queue-enabled": false,
   "seed-queue-size": 10,
   "speed-limit-down": 100,
   "speed-limit-down-enabled": false,
   "speed-limit-up": 100,
   "speed-limit-up-enabled": false,
   "start-added-torrents": true,
   "trash-original-torrent-files": false,
   "umask": 18,
   "upload-slots-per-torrent": 14,
   "utp-enabled": true
}

EOF


# 建立下载目录，添加程序权限
mkdir -p ${downloads}
chown debian-transmission:debian-transmission  ${downloads}

# 启动服务
systemctl restart  transmission-daemon

###  tr-web-control 安装中文语言包
TransmissionWeb=/usr/share/transmission/web
cd $TransmissionWeb
cp index.html index.original.html

git clone https://github.com/ronggang/transmission-web-control.git
cp -r transmission-web-control/src/*   $TransmissionWeb
rm transmission-web-control -rf

# 安装流量统计
bash <(curl -L -s https://git.io/fxxlb) setup

# 浏览器中输入网址管理
echo -e    http://$(curl -4 ip.sb):9091
echo -e "${GreenBG}:: transmission 网页管理地址和密码   ${Yellow}"
echo -e "${SkyBlue}:: 用户名  ${RedBG} ${username} ${SkyBlue} 密码  ${RedBG} ${passwd} ${Font} "

