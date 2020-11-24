#!/bin/bash

SERVER_IP=188.188.188.188
PORT=1999
PASSWORD=wg2999
SS_PORT=40000
SOCKS5_PORT=1080

start(){
  # SS + KcpTun + Udp2RAW
    udp2raw -c -r$SERVER_IP:$PORT -l0.0.0.0:4000 -k $PASSWORD --raw-mode  faketcp -a >> /var/log/udp2raw.log &
    kcp-client -r 127.0.0.1:4000 -l :$SS_PORT --key $PASSWORD -mode fast2 -mtu 1300  >> /var/log/kcp-client.log  2>&1 &

  # ss-local -s 服务器IP地址  -p 服务器端口  -b 绑定本地IP  -l 本地端口  -k 密码  -m 加密方式 [-c 配置文件]
    ss-local -s 127.0.0.1 -p $SS_PORT -b 0.0.0.0 -l $SOCKS5_PORT -k $PASSWORD -m aes-256-gcm  -t 300 >> /var/log/ss-local.log &

  # status
}

stop(){
    killall -9 kcp-client
    killall -9 udp2raw
    killall -9 ss-local
}

restart(){
    stop
    start
}

help(){
    echo -e "${SkyBlue}:: Source: ${Green}https://git.io/sskcp.sh  ${Font}By 蘭雅sRGB"
    echo -e "${SkyBlue}:: Usage: ${GreenBG} bash sskcp.sh ${Yellow} [start|stop|restart|service|set] ${Font}"
    echo
}

status(){
    # log 和 命令行参数
    cat /var/log/udp2raw.log | tail
    cat /var/log/kcp-client.log | tail
    cat /var/log/ss-local.log | tail
    echo

    if [[ -e /etc/openwrt_release ]]; then
       ps | grep  -e udp2raw -e kcp-client -e ss-local
    else
       ps ax | grep --color=auto -e udp2raw -e kcp-client -e ss-local
    fi
    echo
}

setconf()
{
    echo -e "${SkyBlue}:: 修改脚本sskcp.sh记录参数，按${RedBG}<Enter>${SkyBlue}不修改! ${Yellow}"
    head -n 6 sskcp.sh | tail -n 4  &&  echo -e "${SkyBlue}"

    read -p ":: 1.请输入远程服务器IP: "  sv_ip
    read -p ":: 2.请输入udp2raw 端口: "  port
    read -p ":: 3.请输入套接转发密码: "  passwd
    read -p ":: 4.请输入 SS 服务端口: "  ss_port

    if [[ ! -z "${sv_ip}" ]]; then
        sed -i "s/^SERVER_IP=.*/SERVER_IP=${sv_ip}/g"  "sskcp.sh"
    fi
    if [[ ! -z "${port}" ]]; then
        sed -i "s/^PORT=.*/PORT=${port}/g"  "sskcp.sh"
    fi
    if [[ ! -z "${passwd}" ]]; then
        sed -i "s/^PASSWORD=.*/PASSWORD=${passwd}/g"  "sskcp.sh"
    fi
    if [[ ! -z "${ss_port}" ]]; then
        sed -i "s/^SS_PORT=.*/SS_PORT=${ss_port}/g"  "sskcp.sh"
    fi

    echo -e "${Yellow}" && head -n 7 sskcp.sh | tail -n 5 &&  echo -e "${Font}"
}

system_def(){
	Green="\033[32m"  && Red="\033[31m" && GreenBG="\033[42;37m" && RedBG="\033[41;37m"
	Font="\033[0m"  && Yellow="\033[0;33m" && SkyBlue="\033[0;36m"
}

systemd_service(){
    # 安装启动服务
    cat <<EOF >/usr/lib/systemd/system/sskcp.service
[Unit]
Description=sskcp.sh Service
After=network.target

[Service]
Type=forking
User=root
ExecStart=nohup /root/sskcp.sh start &
ExecReload=sh /root/sskcp.sh stop

[Install]
WantedBy=multi-user.target

EOF
	chmod +x  /root/sskcp.sh
	systemctl enable sskcp.service
	systemctl start sskcp.service
	systemctl status sskcp.service
}

# 脚本命令参数
system_def
if [[ $# > 0 ]]; then
    key="$1"
    case $key in
        start)
          start
        ;;
        stop)
          stop
        ;;
        restart)
          restart
        ;;
	service)
          systemd_service
        ;;
        set)
          setconf
        ;;
    esac
else
    status
fi
help
