#!/usr/bin/env bash
#Phicomm K2 brook 安装脚本运行

# 主机型号	Phicomm K2
# 固件版本	PandoraBox 16.11 Mod By LEAN 2016-11-05-git-45c5b40 / LuCI Master (git-16.274.06460-a91d7ee)

K2_BROOK="https://github.com/txthinking/brook/releases/download/v20180909/brook_linux_mipsle"



# 修改成 brook 服务器实际的 IP 端口 和密码
SERVER_IP=1.2.3.4
PORT=9999
PASSWORD=brook9999

cd /tmp  &&  wget --no-check-certificate -O brook   ${K2_BROOK}
chmod +x  brook  &&  ./brook client -l 0.0.0.0:2080 -i 127.0.0.1 -s  ${SERVER_IP}:${PORT}  -p  ${PASSWORD}  &
top -b -n 1 | grep brook


###-------------------- brook 使用示例 ----------------------------------###
# https://github.com/txthinking/brook

# wget  -qO  /usr/local/bin/brook https://github.com/txthinking/brook/releases/download/v20180909/brook
# chmod +x   /usr/local/bin/brook
# brook server -l :9999 -p brook9999  &

# Run as a brook server
# brook server -l :9999 -p password

# Run as brook client, start a socks5 proxy socks5://127.0.0.1:1080
# brook client -l 127.0.0.1:1080 -i 127.0.0.1 -s server_address:port -p password

# Run as brook client, start a http(s) proxy http(s)://127.0.0.1:8080
# brook client -l 127.0.0.1:8080 -i 127.0.0.1 -s server_address:port -p password --http
