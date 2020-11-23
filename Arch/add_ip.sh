#!/bin/bash

# dhcpcd 启动后延迟 2秒 再添加一个静态IP
sleep 2

ip link set enp0s3 up
ip addr add 192.168.1.111/24 dev enp0s3
ip route add default via 192.168.1.1


help(){
    echo -e "${SkyBlue}:: Source: ${Green} Arch Linux 添加 一个静态IP  add_ip.sh  ${Font}By 蘭雅sRGB"
    echo -e "${SkyBlue}:: Usage: ${GreenBG} bash add_ip.sh ${Yellow} [service] ${Font}"
    echo
}

system_def(){
    Green="\033[32m"  && Red="\033[31m" && GreenBG="\033[42;37m" && RedBG="\033[41;37m"
    Font="\033[0m"  && Yellow="\033[0;33m" && SkyBlue="\033[0;36m"
}

systemd_service(){
    # 安装启动服务
    cat <<EOF >/usr/lib/systemd/system/add_ip.service
[Unit]
Description=add_ip.sh Service
Requires=dhcpcd.service

[Service]
Type=forking
User=root
ExecStart=nohup sh /root/add_ip.sh &

[Install]
WantedBy=multi-user.target

EOF
    chmod +x  /root/add_ip.sh
    systemctl enable add_ip.service
    systemctl start  add_ip.service
    systemctl status add_ip.service
}

# 脚本命令参数
system_def
if [[ $# > 0 ]]; then
    key="$1"
    case $key in
        service)
          systemd_service
        ;;
    esac
fi
help
