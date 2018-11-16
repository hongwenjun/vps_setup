#!/usr/bin/env bash
#Phicomm K2 brook 安装脚本运行

# 主机型号	Phicomm K2
# 固件版本	PandoraBox 16.11 Mod By LEAN 2016-11-05-git-45c5b40 / LuCI Master (git-16.274.06460-a91d7ee)

K2_BROOK="https://github.com/txthinking/brook/releases/download/v20180909/brook_linux_mipsle"

cd /tmp  &&  wget --no-check-certificate -O brook   ${K2_BROOK}
chmod +x  brook  &&  ./brook client -l 0.0.0.0:2080 -i 127.0.0.1 -s  1.2.3.4:1234  -p  password  &
top -b -n 1 | grep brook


###-------------------------------------------------------------###
# https://github.com/txthinking/brook

# Run as a brook server
# brook server -l :9999 -p password

# Run as brook client, start a socks5 proxy socks5://127.0.0.1:1080
# brook client -l 127.0.0.1:1080 -i 127.0.0.1 -s server_address:port -p password

# Run as brook client, start a http(s) proxy http(s)://127.0.0.1:8080
# brook client -l 127.0.0.1:8080 -i 127.0.0.1 -s server_address:port -p password --http
