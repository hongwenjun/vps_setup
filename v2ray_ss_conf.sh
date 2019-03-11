#!/bin/bash

v2ray_port=8000
UUID=$(cat /proc/sys/kernel/random/uuid)
serverip=$(curl -4 ip.sb)

ss_port=40000
cur_dir=$(pwd)

# 修改端口号
setport(){
    echo_SkyBlue ":: 1.请修改 V2ray 服务器端端口号，默认:${RedBG} ${v2ray_port} "
    read -p "请输入数字(100--60000): " num

    if [[ ${num} -ge 100 ]] && [[ ${num} -le 60000 ]]; then
       v2ray_port=$num
    fi

    echo_SkyBlue ":: 2.请修改 Shadowsocks 服务器端端口号，默认: ${RedBG} ${ss_port} "
    read -p "请输入数字(100--60000): " num

    if [[ ${num} -ge 100 ]] && [[ ${num} -le 60000 ]]; then
       ss_port=$num
    fi
}

conf_shadowsocks(){
    old_ss_port=$(cat /etc/rc.local | grep ss-server | awk '{print $5}')
    ss_passwd=$(cat /etc/rc.local | grep ss-server | awk '{print $7}')

	sed -i "s/${old_ss_port}/${ss_port}/g"  "/etc/rc.local"
	sed -i "s/ss-server -s 127.0.0.1/ss-server -s 0.0.0.0/g"  "/etc/rc.local"
	systemctl restart rc-local

	#  ss://<<base64_shadowsocks.conf>>
	echo "aes-256-gcm:${ss_passwd}@${serverip}:${ss_port}" | tee ${cur_dir}/base64_shadowsocks.conf
}

conf_v2ray(){
# vmess://<<base64_v2ray_vmess.json>>
cat <<EOF | tee ${cur_dir}/base64_v2ray_vmess.json
{
  "v": "2",
  "ps": "v2ray",
  "add": "${serverip}",
  "port": "${v2ray_port}",
  "id": "${UUID}",
  "aid": "64",
  "net": "kcp",
  "type": "srtp",
  "host": "",
  "path": "",
  "tls": ""
}
EOF

# v2ray服务端mKcp配 /etc/v2ray/config.json
cat <<EOF >/etc/v2ray/config.json
{
  "inbounds": [
    {
      "port": $v2ray_port,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${UUID}",
            "level": 1,
            "alterId": 64
          }
        ]
      },
      "streamSettings": {
        "tcpSettings": {},
        "quicSettings": {},
        "tlsSettings": {},
        "network": "kcp",
        "kcpSettings": {
          "mtu": 1350,
          "tti": 50,
          "header": {
            "type": "srtp"
          },
          "readBufferSize": 2,
          "writeBufferSize": 2,
          "downlinkCapacity": 100,
          "congestion": false,
          "uplinkCapacity": 100
        },
        "wsSettings": {},
        "httpSettings": {},
        "security": "none"
      }
    }
  ],
  "log": {
    "access": "/var/log/v2ray/access.log",
    "loglevel": "info",
    "error": "/var/log/v2ray/error.log"
  },
  "routing": {
    "rules": [
      {
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "type": "field",
        "outboundTag": "blocked"
      }
    ]
  },
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "tag": "blocked",
      "settings": {}
    }
  ]
}
EOF

systemctl restart v2ray
}


# 定义文字颜色
Green="\033[32m"  && Red="\033[31m" && GreenBG="\033[42;37m" && RedBG="\033[41;37m"
Font="\033[0m"  && Yellow="\033[0;33m" && SkyBlue="\033[0;36m"

echo_SkyBlue(){
    echo -e "${SkyBlue}$1${Font}"
}
echo_Yellow(){
    echo -e "${Yellow}$1${Font}"
}

# 显示手机客户端二维码
conf_QRcode(){
     ss_b64=$(base64 ${cur_dir}/base64_shadowsocks.conf)
     shadowsocks_ss="ss://${ss_b64}"

     v2_b64=$(base64 ${cur_dir}/base64_v2ray_vmess.json)
     v2ray_vmess="vmess://${v2_b64}"

     echo_SkyBlue ":: Shadowsocks 服务器二维码,请手机扫描!"
     echo $shadowsocks_ss | qrencode -o - -t UTF8
     echo_Yellow $shadowsocks_ss
     echo
     echo_SkyBlue ":: V2rayNG 手机配置二维码,请手机扫描!"
     echo $v2ray_vmess | tr -d " " | qrencode -o - -t UTF8
     echo_Yellow  ":: V2rayN Windows 客户端 Vmess 协议配置"
     echo $v2ray_vmess | tr -d " "
}

clear
if [ ! -e 'base64_v2ray_vmess.json' ]; then
    echo_SkyBlue  ":: Shadowsocks 和 V2Ray 简易配置: 生成和显示二维码  By 蘭雅sRGB "
    echo_Yellow   ":: 首次配置保存文件 base64_v2ray_vmess.json, 如再次配置请先手工删除!"
    setport
    conf_shadowsocks
    conf_v2ray
fi

# 输出ss和v2ray配置和二维码
conf_QRcode
