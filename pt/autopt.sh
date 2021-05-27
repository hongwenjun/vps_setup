#!/bin/bash

SERVER_IP=172.17.0.1
PORT=8080
PASSWORD="adminadmin"

MONGODB_API="mongodb+srv://pt:Pa55w.rd@cluster0.m9ox4.mongodb.net/myFirstDatabase?retryWrites=true&w=majority"
RSS_DOMAIN="RSS.AUTOPT.NET"
RSS_PASSKEY="123456789-PASSKEY-PASSKEY-ABCDEF"

set_qb_conf()
{
	echo -e "${SkyBlue}:: Docker版 qBittorrent Web 默认: ${GreenBG} http://${SERVER_IP}:${PORT} ${SkyBlue} 密码:${RedBG} ${PASSWORD} "
    echo -e "${SkyBlue}:: 请按实际信息修改，下面三项按 ${RedBG}<Enter>${SkyBlue} 使用默认值! ${Yellow}"

    read -p ":: 1.请输入 qBittorrent Web 服务器IP (172.17.0.1): "  sv_ip
    read -p ":: 2.请输入 qBittorrent Web 服务端口   ( 8080 )  : "  port
    read -p ":: 3.请输入 qBittorrent Web 管理密码 (adminadmin): "  passwd


    if [[ ! -z "${sv_ip}" ]]; then
        SERVER_IP=${sv_ip}
    fi
    if [[ ! -z "${port}" ]]; then
        PORT=${port}
    fi
    if [[ ! -z "${passwd}" ]]; then
        PASSWORD=${passwd}
    fi

	echo -e "${SkyBlue}:: 设置后 qBittorrent Web管理网址: ${GreenBG} http://${SERVER_IP}:${PORT} ${SkyBlue} 密码:${RedBG} ${PASSWORD} "
    echo -e ${Font}
}

set_passkey_conf()
{
	echo -e "${SkyBlue}:: 请提前登陆 PT 网站生成 RSS 订阅地址; 获得${GreenBG} PASSKEY ${SkyBlue}和RSS域名, 键盘按 ${RedBG}<Shift+Insert>${RedBG}${SkyBlue} 粘贴"
    echo -e "${SkyBlue}:: 请按实际信息修改，按 ${RedBG}<Enter>${SkyBlue} 使用伪值填充! ${Yellow}"

    read -p ":: 4.请输入RSS-PASSKEY (123456789-PASSKEY-PASSKEY-ABCDEF) : "  passkey
    read -p ":: 5.请输入RSS 订阅地址的域名 ( pt.msg.vg ): "  domain


    if [[ ! -z "${domain}" ]]; then
        RSS_DOMAIN=${domain}
    fi
    if [[ ! -z "${passkey}" ]]; then
        RSS_PASSKEY=${passkey}
    fi

	echo -e "${SkyBlue}:: 设置后RSS域名: ${GreenBG} ${RSS_DOMAIN} ${SkyBlue} RSS-PASSKEY: ${RedBG} ${RSS_PASSKEY} "
    echo -e ${Font}
}

input_conf(){
    set_qb_conf
    set_passkey_conf

    echo -e "${SkyBlue}:: 请检查填充信息是否正确, 即将初始化自动PT工具配置文件: ${GreenBG} /root/goseeder.conf ${Font} 请确认覆盖\c"
    read -p "(Y/N): " key
    case $key in
        Y)
        init_config
        ;;
        y)
        init_config
        ;;
        N)
        input_conf
        ;;
        n)
        input_conf
        ;;
    esac
}

init_config(){

# 初始化自动PT工具配置文件:  /root/goseeder.conf

    cat <<EOF >/root/goseeder.conf
{
"dbserver": "${MONGODB_API}",
"node": [
  {
"source": "${RSS_DOMAIN}",
"passkey": "${RSS_PASSKEY}",
"limit": 10,
"enable": true,
"rule": {
    "seeder_time": 0,
    "seeder_ratio": 0,
    "speed_limit": 8.0
   }
  }
 ],
"server": [
  {
"endpoint": "http://${SERVER_IP}:${PORT}",
"username": "admin",
"password": "${PASSWORD}",
"remark": "AutoPT-007",
"enable": true,
"rule": {
"concurrent_download": 1,
"disk_threshold": 10.0,
"disk_overcommit": false,
"max_speed": 30.00,
"min_alivetime": 3600,
"max_alivetime": 86400,
"min_tasksize": 0.0,
"max_tasksize": 50.0,
"max_disklatency": 10000
   }
  }
 ]
}
EOF

    echo -e "${SkyBlue}:: 初始化自动PT工具配置文件完成: ${GreenBG} /root/goseeder.conf ${Font}"
    cat /root/goseeder.conf
}


system_def(){
	Green="\033[32m"  && Red="\033[31m" && GreenBG="\033[42;37m" && RedBG="\033[41;37m"
	Font="\033[0m"  && Yellow="\033[0;33m" && SkyBlue="\033[0;36m"
}


install(){
docker run -d  --name  autopt  \
   -v  /root/goseeder.conf:/goseeder.conf  \
   hongwenjun/autopt

echo -e "${GreenBG}::   autopt镜像:   https://hub.docker.com/r/hongwenjun/autopt ${Font}"
}


# 设置菜单
start_menu(){
    clear
    echo -e "${GreenBG}>      开源项目:  https://github.com/hongwenjun/vps_setup    "
    echo -e "${RedBG}>  自动PT autopt.sh 一键脚本 感谢大神TaterLi创作goseeder工具 ${Font}"
    echo -e "${SkyBlue}>  1. 重置初始化自动PT工具配置文件(首次需运行)"
    echo -e ">  2. 安装 Docker 容器 autopt 镜像"
    echo -e ">  3. 重启 autopt 自动PT容器"
    echo -e ">  4. 停止 autopt 自动PT容器"
    echo -e ">  5. 卸载 autopt 自动PT容器"
    echo -e ">  6. 查看 QB 服务器最新状态"
    echo    "------------------------------------------------------------"
    echo -e "${Green}>  7. 安装 Docker 容器引擎和 qBittorrent 软件"
    echo -e ">  8. 检查 自动PT 推送信息,按 ${RedBG}<Enter> ${Font}"
    echo
    echo -e "${GreenBG}:: autopt镜像:  https://hub.docker.com/r/hongwenjun/autopt  ${Font}"
    read -p "请输入数字(1-8):" num
    case "$num" in
        1)
        input_conf
        ;;
        2)
        install
        ;;
        3)
        docker restart autopt
        ;;
        4)
        docker stop autopt
        ;;
        5)
        docker rm  -f autopt
        docker rmi -f hongwenjun/autopt
        ;;
        6)
        docker  exec  -it autopt  gostat
        ;;
        7)
        wget -O wgmtu git.io/wgmtu  >/dev/null 2>&1
        bash wgmtu docker
        bash wgmtu qb
        ;;
        8)
        docker logs  autopt | grep -e 种子 -e 磁盘
        ;;
        esac
        docker logs  autopt | grep -e 种子 -e 磁盘
}

system_def
start_menu

