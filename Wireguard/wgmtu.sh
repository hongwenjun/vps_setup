#!/bin/bash

# 定义文字颜色
Green="\033[32m"  && Red="\033[31m" && GreenBG="\033[42;37m" && RedBG="\033[41;37m" && Font="\033[0m"
Yellow='\033[0;33m' && SkyBlue='\033[0;36m'

# 修改mtu数值
setmtu(){
    echo -e "${GreenBG}WireGuard 修改服务器端MTU值,提高效率;默认值MTU=1420${Font}"
    read -p "请输入数字(1200--1500): " num

    if [[ ${num} -ge 1200 ]] && [[ ${num} -le 1500 ]]; then
       mtu=$num
    else
       mtu=1420
    fi

    ip link set mtu $num up dev wg0
    wg-quick save wg0
    echo -e "${SkyBlue}:: 服务器端MTU值已经修改!${Font}"
}

# 修改端口号
setport(){
    echo -e "${GreenBG}修改 WireGuard 服务器端端口号，客户端要自行修改${Font}"
    read -p "请输入数字(100--60000): " num

    if [[ ${num} -ge 100 ]] && [[ ${num} -le 60000 ]]; then
       port=$num
       wg set wg0 listen-port $port
       wg-quick save wg0

       echo -e "${SkyBlue}:: 端口号已经修改, 客户端请手工修改! ${Font}"
    else
       echo -e "${Red}:: 没有修改端口号!${Font}"
    fi
}

# 显示手机客户端二维码
conf_QRcode(){
    echo -e "${Yellow}:: 显示手机客户端二维码(默认2号),请输入数字${Font}\c"
    read -p "(2-9): " x

    if [[ ${x} -ge 2 ]] && [[ ${x} -le 9 ]]; then
       i=$x
    else
       i=2
    fi

    host=$(hostname -s)
    cat /etc/wireguard/wg_${host}_$i.conf | qrencode -o - -t UTF8
    echo -e "${Green}:: 配置文件: wg_${host}_$i.conf 生成二维码，请用手机客户端扫描使用${Font}"
    echo -e "${SkyBlue}:: SSH工具推荐Git-Bash 2.20; GCP_SSH(浏览器)字体Courier New 二维码正常${Font}"
}

# 重置 WireGuard 客户端配置和数量
wg_clients(){
    echo -e "${Red}:: 注意原来的客户端配置都会删除，按 Ctrl+ C 可以紧急撤销  ${Font}"

    # 转到wg配置文件目录
    cd /etc/wireguard
    cp wg0.conf  conf.wg0.bak

    echo -e "${SkyBlue}:: 输入客户端Peer总数${Font}\c"
    read -p "(2--200): " num_x

    if [[ ${num_x} -ge 2 ]] && [[ ${num_x} -le 200 ]]; then
     wg_num=OK
    else
      num_x=3
    fi

    # 服务器 IP 和 端口
    port=$(wg show wg0 listen-port) && host=$(hostname -s)
    serverip=$(curl -4 ip.sb)

    # 删除原配置，让IP和ID号对应; 保留原来服务器的端口等配置
    rm  /etc/wireguard/wg_${host}_*   >/dev/null 2>&1
    head -n 13  conf.wg0.bak > wg0.conf
    sed -i '13s/.//g' wg0.conf
    
    # 重启wg服务器
    wg-quick down wg0  >/dev/null 2>&1
    wg-quick up wg0    >/dev/null 2>&1

    # 重新生成用户配置数量
    for i in `seq 2 200`
    do
        ip=10.0.0.${i}
        wg genkey | tee cprivatekey | wg pubkey > cpublickey
        wg set wg0 peer $(cat cpublickey) allowed-ips $ip/32

        cat <<EOF >wg_${host}_$i.conf
[Interface]
PrivateKey = $(cat cprivatekey)
Address = $ip/24
DNS = 8.8.8.8

[Peer]
PublicKey = $(wg show wg0 public-key)
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25

EOF
        cat wg_${host}_$i.conf | qrencode -o wg_${host}_$i.png
        if [ $i -ge $num_x ]; then break; fi
    done

    wg-quick save wg0
    clear && display_peer
    cat /etc/wireguard/wg_${host}_2.conf
    echo -e "${SkyBlue}:: 使用${GreenBG} bash wg5 ${SkyBlue}命令,可以临时网页下载配置和二维码${Font}"
}

# 安装Speeder+Udp2Raw服务TCP伪装，加速功能
ss_kcp_udp2raw_wg_speed(){
    # 下载/编译 shadowsocks-libev
    wget -qO- git.io/fhExJ | bash

    wget -O ~/ss_wg_set_raw  git.io/fpKnF    >/dev/null 2>&1
    bash ~/ss_wg_set_raw
    rm ~/ss_wg_set_raw
}

# 常用工具和配置
get_tools_conf(){
    apt-get update
    apt-get install -y htop tmux screen iperf3  >/dev/null 2>&1
    yum install -y vim htop tmux screen iperf3  >/dev/null 2>&1
    wget -O .vimrc      --no-check-certificate https://raw.githubusercontent.com/hongwenjun/srgb/master/vim/_vimrc
    wget -O .bashrc     --no-check-certificate https://raw.githubusercontent.com/hongwenjun/srgb/master/vim/_bashrc
    wget -O .tmux.conf  --no-check-certificate https://raw.githubusercontent.com/hongwenjun/tmux_for_windows/master/.tmux.conf
}

# 主菜单输入数字 88      # 隐藏功能:从源VPS克隆服务端配置，获得常用工具和配置
scp_conf(){
    echo -e "${RedBG}:: 警告: 警告: 警告: VPS服务器已经被GFW防火墙关照，按 Ctrl+ C 可以紧急逃离！  ${Font}"
    echo  "隐藏功能:从源VPS克隆服务端配置，共用客户端配置"
    read -p "请输入源VPS的IP地址(域名):"  vps_ip
    cmd="scp root@${vps_ip}:/etc/wireguard/*  /etc/wireguard/. "
    echo -e "${GreenBG}#  ${cmd}  ${Font}   现在运行scp命令，按提示输入yes，源vps的root密码"
    ${cmd}

    wg-quick down wg0   >/dev/null 2>&1
    wg-quick up wg0     >/dev/null 2>&1
    echo -e "${RedBG}    我真不知道WG服务器端是否已经使用源vps的配置启动!    ${Font}"

    if [ ! -f '~/.tmux.conf' ]; then
        get_tools_conf
    fi
}

#  隐藏功能开放: 一键脚本全家桶
onekey_plus(){
    echo -e "${SkyBlue}           一键安装设置全家桶    by 蘭雅sRGB             ${Font}"
    cat  <<EOF
  # 下载 IPTABLES 设置防火墙规则 脚本 By 蘭雅sRGB
  wget -qO safe_iptables.sh git.io/fhUSe && bash safe_iptables.sh

  # Google Cloud Platform GCP实例开启密码与root用户登陆
  wget -qO- git.io/fpQWf | bash

  # 一键安装 vnstat 流量检测   by 蘭雅sRGB
  wget -qO- git.io/fxxlb | bash

  # 一键安装wireguard 脚本 Debian 9  (源:逗比网安装笔记)
  wget -qO- git.io/fptwc | bash

  # 一键 WireGuard 多用户配置共享脚本   by 蘭雅sRGB
  wget -qO- https://git.io/fpnQt | bash

  # 一键安装 SS+Kcp+Udp2Raw 脚本 快速安装 for Debian 9
  wget -qO- git.io/fpZIW | bash

  # 一键安装 SS+Kcp+Udp2Raw 脚本 for Debian 9  Ubuntu (编译安装)
  wget -qO- git.io/fx6UQ | bash

  # Telegram 代理 MTProxy Go版 一键脚本(源:逗比网)
  wget -qO mtproxy_go.sh  git.io/fpWo4 && bash mtproxy_go.sh

  # linux下golang环境搭建自动脚本  by 蘭雅sRGB
  wget -qO- https://git.io/fp4jf | bash

  # SuperBench.sh 一键测试服务器的基本参数
  wget -qO- git.io/superbench.sh | bash

  # 使用BestTrace查看VPS的去程和回程
  wget -qO- git.io/fp5lf | bash

  # qrencode 生成二维码 -o- 参数显示在屏幕 -t utf8 文本格式
  cat wg_vultr_5.conf  | qrencode -o- -t utf8

EOF
    echo -e "${SkyBlue}    开源项目：https://github.com/hongwenjun/vps_setup    ${Font}"
}

safe_iptables(){
   # IPTABLES 设置防火墙规则 脚本 By 蘭雅sRGB  特别感谢 TaterLi 指导
   wget -qO safe_iptables.sh git.io/fhUSe && bash safe_iptables.sh
}

# 更新wgmtu脚本
update_self(){
    # 安装 bash wgmtu 脚本用来设置服务器
    wget -O ~/wgmtu  https://raw.githubusercontent.com/hongwenjun/vps_setup/master/Wireguard/wgmtu.sh >/dev/null 2>&1
}

# 更新 WireGuard
wireguard_update(){
    yum update -y wireguard-dkms wireguard-tools     >/dev/null 2>&1
    apt update -y wireguard-dkms wireguard-tools     >/dev/null 2>&1
    echo -e "${RedBG}   更新完成  ${Font}"
}
# 卸载 WireGuard
wireguard_remove(){
    wg-quick down wg0
    yum remove -y wireguard-dkms wireguard-tools     >/dev/null 2>&1
    apt remove -y wireguard-dkms wireguard-tools     >/dev/null 2>&1
    rm -rf /etc/wireguard/
    echo -e "${RedBG}   卸载完成  ${Font}"
}


rc-local_remove(){
   echo -e "${RedBG}推荐: 卸载Udp2Raw服务使用 vim /etc/rc.local 手工编辑修改  ${Font}"
   echo -e "${GreenBG} 按  Ctrl + C 可以取消 卸载操作 ${Font}"
   read -p "请任意键确认:"  yes

   systemctl stop rc-local
   mv  /etc/rc.local  ~/rc.local
   echo -e "${RedBG}   卸载完成，rc.local 备份在 /root 目录  ${Font}"
}

update_remove_menu(){
    echo -e "${RedBG}   更新/卸载 WireGuard服务端和Udp2Raw   ${Font}"
    echo -e "${Green}>  1. 更新 WireGuard 服务端"
    echo -e ">  2. 卸载 WireGuard 服务端"
    echo -e ">  3. 卸载 Udp2Raw 服务"
    echo -e ">  4. 退出${Font}"
    echo
    read -p "请输入数字(1-4):" num_x
    case "$num_x" in
        1)
        wireguard_update
        ;;
        2)
        wireguard_remove
        ;;
        3)
        rc-local_remove
        ;;
        4)
        exit 1
        ;;
        *)
        ;;
        esac
}

# 删除末尾的Peer
del_last_peer(){
    peer_key=$(wg show wg0 allowed-ips  | tail -1 | awk '{print $1}')
    wg set wg0 peer $peer_key remove
    wg-quick save wg0
    echo -e "${SkyBlue}:: 删除客户端 peer: ${Yellow} ${peer_key} ${SkyBlue} 完成.${Font}"
}

# 显示激活Peer表
display_peer(){
    # peer和ip表写临时文件
    wg show wg0 allowed-ips > /tmp/peer_list

    # 显示 peer和ip表
    echo -e  "${RedBG} ID ${GreenBG}         Peer:  <base64 public key>         ${SkyBlue}  IP_Addr:  ${Font}"
    i=1
    while read -r line || [[ -n $line ]]; do
        peer=$(echo $line | awk '{print $1}')
        ip=$(echo $line | awk '{print $2}')
        line="> ${Red}${i}   ${Yellow}${peer}${Font}   ${ip}"
        echo -e $line  &&  let i++
    done < /tmp/peer_list
}

# 选择删除Peer客户端
del_peer(){
    display_peer
    echo
    echo -e "${RedBG}请选择 IP_Addr 对应 ID 号码，指定客户端配置将删除! ${Font}"
    read -p "请输入ID号数字(1-X):" x
    
    peer_cnt=$(cat /tmp/peer_list | wc -l)
    if [[ ${x} -ge 1 ]] && [[ ${x} -le ${peer_cnt} ]]; then
        i=$x
        peer_key=$(cat /tmp/peer_list | head -n $i | tail -1 | awk '{print $1}')
        wg set wg0 peer $peer_key remove
        wg-quick save wg0
        echo -e "${SkyBlue}:: 删除客户端 peer: ${Yellow} ${peer_key} ${SkyBlue} 完成.${Font}"
    else
        echo -e "${SkyBlue}:: 命令使用: ${GreenBG} wg set wg0 peer <base64 public key> remove ${Font}"
    fi
    rm /tmp/peer_list
}

# 添加新的客户端peer
add_peer(){

    # 服务器 IP 端口 ，新客户端 序号和IP
    port=$(wg show wg0 listen-port)
    serverip=$(curl -4 ip.sb) && host=$(hostname -s) && cd /etc/wireguard
    wg genkey | tee cprivatekey | wg pubkey > cpublickey

    ipnum=$(wg show wg0 allowed-ips  | tail -1 | awk '{print $2}' | awk -F '[./]' '{print $4}')
    i=$((10#${ipnum}+1))  &&  ip=10.0.0.${i}

    # 生成客户端配置文件
    cat <<EOF >wg_${host}_$i.conf
[Interface]
PrivateKey = $(cat cprivatekey)
Address = $ip/24
DNS = 8.8.8.8

[Peer]
PublicKey = $(wg show wg0 public-key)
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25
EOF

    # 在wg服务器中生效客户端peer
    wg set wg0 peer $(cat cpublickey) allowed-ips $ip/32
    wg-quick save wg0

    # 显示客户端
    cat /etc/wireguard/wg_${host}_$i.conf | qrencode -o wg_${host}_$i.png
    cat /etc/wireguard/wg_${host}_$i.conf | qrencode -o - -t UTF8
    echo -e "${SkyBlue}:: 新客户端peer添加完成; 文件:${Yellow} /etc/wireguard/wg_${host}_$i.conf ${Font}"
    cat /etc/wireguard/wg_${host}_$i.conf
}

wg_clients_menu(){
    echo -e "${RedBG}   添加/删除 WireGuard Peer 客户端管理  ${Font}"
    echo -e "${Green}>  1. 添加一个 WireGuard Peer 客户端配置"
    echo -e ">  2. 删除末尾 WireGuard Peer 客户端配置"
    echo -e ">  3. 指定删除 WireGuard Peer 客户端配置"
    echo    "------------------------------------------------------"
    echo -e "${SkyBlue}>  4. 退出"
    echo -e ">  5.${RedBG} 重置 WireGuard 客户端 Peer 数量 ${Font}"
    echo
    read -p "请输入数字(1-5):" num_x
    case "$num_x" in
        1)
        add_peer
        ;;
        2)
        del_last_peer
        ;;
        3)
        del_peer
        ;;
        4)
        display_peer
        exit 1
        ;;
        5)
        wg_clients
        ;;
        *)

        ;;
        esac
}


# 设置菜单
start_menu(){
    clear
    echo -e "${RedBG}   一键安装 WireGuard 脚本 For Debian_9 Ubuntu Centos_7   ${Font}"
    echo -e "${GreenBG}     开源项目：https://github.com/hongwenjun/vps_setup    ${Font}"
    echo -e "${Green}>  1. 显示手机客户端二维码"
    echo -e ">  2. 修改 WireGuard 服务器端 MTU 值"
    echo -e ">  3. 修改 WireGuard 端口号"
    echo -e ">  4. 安装 WireGuard+Speeder+Udp2Raw 和 SS+Kcp+Udp2RAW 一键脚本"
    echo    "----------------------------------------------------------"
    echo -e "${SkyBlue}>  5. 添加/删除 WireGuard Peer 客户端管理"
    echo -e ">  6. 更新/卸载 WireGuard服务端和Udp2Raw"
    echo -e ">  7. vps_setup 一键脚本全家桶大礼包"
    echo -e ">  8. ${RedBG}  小白一键设置防火墙  ${Font}"
    echo
    read -p "请输入数字(1-8):" num
    case "$num" in
        1)
        conf_QRcode
        ;;
        2)
        setmtu
        ;;
        3)
        setport
        ;;
        4)
        ss_kcp_udp2raw_wg_speed
        ;;
        5)
        wg_clients_menu
        ;;
        6)
        update_remove_menu
        update_self
        exit 1
        ;;
        7)
        onekey_plus
        ;;
        8)
        safe_iptables
        ;;
        88)
        scp_conf
        ;;
        *)
        display_peer
        ;;
        esac
}

# 安装 WireGuard+Speeder+Udp2Raw 和 SS+Kcp+Udp2RAW 配置
# bash wgmtu setup  

if [[ $# > 0 ]]; then
    key="$1"
    case $key in
        setup)
        ss_kcp_udp2raw_wg_speed
        ;;
        remove)
        wireguard_remove
	rc-local_remove
        ;;
    esac
else
	start_menu
fi
