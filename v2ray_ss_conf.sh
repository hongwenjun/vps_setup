#!/bin/bash
# Easy Install Shadowsocks & V2Ray : Generate and display QR_code  URL: https://git.io/v2ray_ss.sh

# Usage:  bash <(curl -L -s https://git.io/v2ray_ss.sh)

let v2ray_port=$RANDOM+9999
UUID=$(cat /proc/sys/kernel/random/uuid)

ss_port=40000
ss_passwd=$(date | md5sum  | head -c 6)
cur_dir=$(pwd)

if [ ! -e '/var/ip_addr' ]; then
   echo -n $(curl -4 ip.sb) > /var/ip_addr
fi
serverip=$(cat /var/ip_addr)

# Modify Port Number
setport(){
    echo_SkyBlue ":: 1. Please Modify the V2ray Server Port Number, Random Port: ${RedBG} ${v2ray_port} "
    read -p "Please Enter the Number, Press Enter to not Modify(100--60000): " num

    if [[ ${num} -ge 100 ]] && [[ ${num} -le 60000 ]]; then
       v2ray_port=$num
    fi
}

# debian 9 bbr Setting open
sysctl_config() {
    sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
    echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
    sysctl -p >/dev/null 2>&1
}


ss_enable(){
    cat <<EOF >/etc/rc.local
#!/bin/sh -e
ss-server -s 0.0.0.0 -p 40000 -k ${ss_passwd} -m aes-256-gcm -t 300  -s ::0 >> /var/log/ss-server.log &

exit 0
EOF
}

conf_shadowsocks(){

    echo_SkyBlue ":: 2. Please Modify the Shadowsocks Server Port Number, Random Port: ${RedBG} ${ss_port} "
    read -p "Please Enter the Number, Press Enter to not Modify(100--60000): " num

    if [[ ${num} -ge 100 ]] && [[ ${num} -le 60000 ]]; then
       ss_port=$num
    fi

    echo_SkyBlue ":: 3. Please Modify the Password of Shadowsocks, Random Password: ${RedBG} ${ss_passwd} "
    read -p "Now, You can change the Password, Press Enter to not Modify: "  new

    if [[ ! -z "${new}" ]]; then
        ss_passwd="${new}"
        echo -e "Now, New Password: ${GreenBG} ${ss_passwd} ${Font}"
    fi

    # If Shadowsocks not install, Now install.
    if [ ! -e '/usr/local/bin/ss-server' ]; then
        sysctl_config
        ss_enable
        bash <(curl -L -s git.io/fhExJ)
    fi

    old_ss_port=$(cat /etc/rc.local | grep ss-server | awk '{print $5}')
    old_passwd=$(cat /etc/rc.local | grep ss-server | awk '{print $7}')
    method=$(cat /etc/rc.local | grep ss-server | awk '{print $9}')

	sed -i "s/${old_ss_port}/${ss_port}/g"   "/etc/rc.local"
    sed -i "s/${old_passwd}/${ss_passwd}/g"  "/etc/rc.local"
	sed -i "s/ss-server -s 127.0.0.1/ss-server -s 0.0.0.0/g"  "/etc/rc.local"

    systemctl stop rc-local
    # Simple Judgment System:  Debian / Centos
    if [ -e '/etc/redhat-release' ]; then
        mv /etc/rc.local /etc/rc.d/rc.local
        ln -s /etc/rc.d/rc.local /etc/rc.local
        chmod +x /etc/rc.d/rc.local
        systemctl enable rc-local
    else
        chmod +x /etc/rc.local
        systemctl enable rc-local
    fi

	systemctl restart rc-local

    echo_Yellow ":: Info: Shadowsocks Server, Encrypt_Method / Password / IP / Port"
	# ss://<<base64_shadowsocks.conf>>
	echo "${method}:${ss_passwd}@${serverip}:${ss_port}" | tee ${cur_dir}/base64_shadowsocks.conf
	echo
}

conf_v2ray(){
    # If V2ray not install, Now install.
    if [ ! -e '/etc/v2ray/config.json' ]; then
        bash <(curl -L -s https://install.direct/go.sh)
    fi

    echo_SkyBlue ":: Info: V2ray Server, IP / Port / UUID"
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

echo

# v2ray Server mKcp config_file: /etc/v2ray/config.json
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


# Definition Display Text Color
Green="\033[32m"  && Red="\033[31m" && GreenBG="\033[42;37m" && RedBG="\033[41;37m"
Font="\033[0m"  && Yellow="\033[0;33m" && SkyBlue="\033[0;36m"

echo_SkyBlue(){
    echo -e "${SkyBlue}$1${Font}"
}
echo_Yellow(){
    echo -e "${Yellow}$1${Font}"
}

# Display Mobile client QR_code
conf_QRcode(){

     st="$(cat ${cur_dir}/base64_shadowsocks.conf)"
     ss_b64=$(echo -n $st | base64)
     shadowsocks_ss="ss://${ss_b64}"

     v2_b64=$(base64 -w0 ${cur_dir}/base64_v2ray_vmess.json)
     v2ray_vmess="vmess://${v2_b64}"

     echo_SkyBlue ":: Shadowsocks Client Configuration for Mobile QR_code!"
     echo -n $shadowsocks_ss | qrencode -o - -t UTF8
     echo_Yellow $shadowsocks_ss
     echo
     echo_SkyBlue ":: V2rayNG Client Configuration for Mobile QR_code!"
     echo -n $v2ray_vmess  | qrencode -o - -t UTF8
     echo_SkyBlue  ":: V2rayN Windows Client Vmess Protocol Configuration"
     echo $v2ray_vmess
     echo
     echo_Yellow  ":: Usage: ${RedBG} bash <(curl -L -s https://git.io/v2ray_ss.sh) setup ${Font} to Modified Port Password and UUID"
}

# Set v2ray port and UUID
set_v2ray_ss(){
    setport
    conf_shadowsocks
    conf_v2ray
}

clear
# Run the script for the first time, set the port and UUID
if [ ! -e 'base64_v2ray_vmess.json' ]; then

    # Simple Judgment System:  Debian / Centos
    if [ -e '/etc/redhat-release' ]; then
        yum update -y && yum install -y  qrencode wget vim
    else
        apt update && apt install -y  qrencode
    fi

    set_v2ray_ss
fi

# Parameter 'setup' setting port and UUID
if [[ $# > 0 ]]; then
    key="$1"
    case $key in
        setup)
        set_v2ray_ss
        ;;
    esac
fi

echo_SkyBlue  ":: Easy Install Shadowsocks & V2Ray : Generate and display QR_code  By 蘭雅sRGB "
echo_Yellow   ":: Usage:  bash <(curl -L -s https://git.io/v2ray_ss.sh) "

# Output ss and v2ray configuration and QR code
conf_QRcode 2>&1 | tee ${cur_dir}/v2ray_ss.log

