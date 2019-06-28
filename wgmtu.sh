#!/bin/bash
#  Get WireGuard Management Command : bash wgmtu
#  wget -O ~/wgmtu https://raw.githubusercontent.com/hongwenjun/vps_setup/english/wgmtu.sh

# Modify WireGuard Server MTU Number
setmtu(){
    echo -e "${GreenBG}Modify WireGuard Server MTU Number, Default=1420${Font}"
    read -p "Please Enter the Number(1200--1500): " num

    if [[ ${num} -ge 1200 ]] && [[ ${num} -le 1500 ]]; then
       mtu=$num
    else
       mtu=1420
    fi

    ip link set mtu $num up dev wg0
    wg-quick save wg0
    echo -e "${SkyBlue}:: WireGuard Server MTU Number Changed!${Font}"
}

# Modify WireGuard Server Port
setport(){
    echo -e "${GreenBG}Modify WireGuard Server Port${Font}"
    read -p "Please Enter the Number(100--60000): " num

    if [[ ${num} -ge 100 ]] && [[ ${num} -le 60000 ]]; then
       port=$num
       wg set wg0 listen-port $port
       wg-quick save wg0

       echo -e "${SkyBlue}::  WireGuard Server Port Number Changed!${Font}"
    else
       echo -e "${Red}:: Port Number Not Change!${Font}"
    fi
}

# Display Client Configuration and Mobile Phone QR code
conf_QRcode(){
    echo -e "${Yellow}:: 显示客户端配置和手机二维码 (默认2号),请输入数字${Font}\c"
    read -p "(2-9): " x

    if [[ ${x} -ge 2 ]] && [[ ${x} -le 9 ]]; then
       i=$x
    else
       i=2
    fi

    host=$(hostname -s)
    echo -e "${SkyBlue}:: 客户端配置文件: wg_${host}_$i.conf ${Font}"
    cat /etc/wireguard/wg_${host}_$i.conf
    echo -e "${SkyBlue}:: 请使用组合键 Ctrl+Ins 复制文本给Windows客户端使用${Font}"
    cat /etc/wireguard/wg_${host}_$i.conf | qrencode -o - -t UTF8
    echo -e "${Green}:: 配置文件: wg_${host}_$i.conf 生成二维码，请用手机客户端扫描使用${Font}"

    echo -e "${SkyBlue}:: 安卓手机WireGuard官方APP目前支持纯IPV6连接，是否显示IPV6二维码?${Font}\c"
    read -p "(Y/N): " key
    case $key in
        Y)
        ipv6_QRcode $i
        ;;
        y)
        ipv6_QRcode $i
        ;;
    esac

    echo -e "${SkyBlue}:: SSH工具推荐Git-Bash 2.20; GCP_SSH(浏览器)字体Courier New 二维码正常${Font}"
}

# 显示IPV6手机客户端二维码
ipv6_QRcode(){
    if [[ $# > 0 ]]; then
        i="$1"
    fi
    get_serverip
    serveripv6=$(curl -6 ip.sb)
    if [[ -z $serveripv6 ]]; then
        echo -e "${Red}:: 获取IPV6地址不正确，你的服务器可能没有IPV6网络支持!${Font}"
    else
        cat /etc/wireguard/wg_${host}_$i.conf | sed "s/${serverip}/[${serveripv6}]/g" | qrencode -o - -t UTF8
        echo -e "${Green}:: IPV6地址: [${serveripv6}] 请确认服务器和本地网络支持IPV6!${Font}"
    fi
}

get_serverip(){
    if [ ! -e '/var/ip_addr' ]; then
       echo -n $(curl -4 ip.sb) > /var/ip_addr
    fi
    serverip=$(cat /var/ip_addr)
    ipv6_range="fd08:620c:4df0:65eb::"
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
    get_serverip

    # 删除原配置，让IP和ID号对应; 保留原来服务器的端口等配置
    rm  /etc/wireguard/wg_${host}_*   >/dev/null 2>&1
    line_num=$(cat -n wg0.conf | grep 'AllowedIPs'  | head -n 1 | awk '{print $1}')
    head -n ${line_num}  conf.wg0.bak > wg0.conf

    # 重启wg服务器
    wg-quick down wg0  >/dev/null 2>&1
    wg-quick up wg0    >/dev/null 2>&1

    # 重新生成用户配置数量
    for i in `seq 2 200`
    do
        ip=10.0.0.${i}
        ip6=${ipv6_range}${i}
        wg genkey | tee cprivatekey | wg pubkey > cpublickey
        wg set wg0 peer $(cat cpublickey) allowed-ips "${ip}/32, ${ip6}"

        cat <<EOF >wg_${host}_$i.conf
[Interface]
PrivateKey = $(cat cprivatekey)
Address = $ip/24, $ip6/64
DNS = 8.8.8.8, 2001:4860:4860::8888

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

# 安装 WireGuard+Speeder+Udp2Raw 和 SS+Kcp+Udp2RAW 配置
ss_kcp_udp2raw_wg_speed(){
    # 下载/编译 shadowsocks-libev
    wget -qO- git.io/fhExJ | bash

    wget -O ~/ss_wg_set_raw  git.io/fpKnF    >/dev/null 2>&1
    bash ~/ss_wg_set_raw
    rm ~/ss_wg_set_raw
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
echo_GreenBG(){
    echo -e "${GreenBG}$1${Font}"
}
echo_RedBG(){
    echo -e "${RedBG}$1${Font}"
}


safe_iptables(){
   # IPTABLES 设置防火墙规则 脚本 By 蘭雅sRGB  特别感谢 TaterLi 指导
   wget -qO safe_iptables.sh git.io/fhUSe && bash safe_iptables.sh
}

# 更新wgmtu脚本
update_self(){
    #  Get WireGuard Management Command : bash wgmtu
    wget -O ~/wgmtu  https://raw.githubusercontent.com/hongwenjun/vps_setup/english/wgmtu.sh
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

# 更新/安装  UDP2RAW   KCPTUN   UDPspeeder 工具
udp2raw_update()
{
	systemctl stop rc-local

    # 下载 UDP2RAW
    udp2raw_ver=$(wget --no-check-certificate -qO- https://api.github.com/repos/wangyu-/udp2raw-tunnel/releases/latest | grep 'tag_name' | cut -d\" -f4)
    wget https://github.com/wangyu-/udp2raw-tunnel/releases/download/${udp2raw_ver}/udp2raw_binaries.tar.gz
    tar xf udp2raw_binaries.tar.gz
    mv udp2raw_amd64 /usr/bin/udp2raw
    rm udp2raw* -rf
    rm version.txt

    # 下载 KCPTUN
    kcp_ver=$(wget --no-check-certificate -qO- https://api.github.com/repos/xtaci/kcptun/releases/latest | grep 'tag_name' | cut -d\" -f4)
    kcp_gz_ver=${kcp_ver:1:8}

    kcptun_tar_gz=kcptun-linux-amd64-${kcp_gz_ver}.tar.gz
    wget https://github.com/xtaci/kcptun/releases/download/${kcp_ver}/$kcptun_tar_gz
    tar xf $kcptun_tar_gz
    mv server_linux_amd64 /usr/bin/kcp-server
    rm $kcptun_tar_gz
    rm client_linux_amd64

    # 下载 UDPspeeder
    udpspeeder_ver=$(wget --no-check-certificate -qO- https://api.github.com/repos/wangyu-/UDPspeeder/releases/latest | grep 'tag_name' | cut -d\" -f4)
    wget https://github.com/wangyu-/UDPspeeder/releases/download/${udpspeeder_ver}/speederv2_binaries.tar.gz
    tar xf speederv2_binaries.tar.gz
    mv speederv2_amd64 /usr/bin/speederv2
    rm speederv2* -rf
    rm version.txt

    systemctl restart rc-local
    ps aux | grep -e kcp -e udp -e speed -e ss-server
    ss-server -h | head -2  && kcp-server -v && udp2raw -h | head -2 && speederv2 -h | head -2

}

rc-local_remove(){
   echo -e "${RedBG}   卸载Udp2Raw套接服务配置 /etc/rc.local ${Font}"
   systemctl stop rc-local
   rm /usr/bin/udp2raw  /usr/bin/kcp-server  /usr/bin/speederv2
   ps aux | grep -e kcp -e udp -e speed
   mv  /etc/rc.local  ~/rc.local
   echo -e "${RedBG}   卸载完成，备份在 /root/rc.local  ${Font}"
}

update_remove_menu(){
    echo -e "${RedBG}   更新/卸载 WireGuard服务端和Udp2Raw   ${Font}"
    echo -e "${Green}>  1. 更新 WireGuard 服务端"
    echo -e ">  2. 卸载 WireGuard 服务端"
    echo -e ">  3. 更新 Udp2Raw KCPTUN UDPspeeder 软件"
    echo -e ">  4. 卸载 Udp2Raw KCPTUN UDPspeeder 服务套件"
    echo -e ">  5. 退出${Font}"
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
        udp2raw_update
        ;;
        4)
        rc-local_remove
        ;;
        5)
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
    get_serverip && host=$(hostname -s) && cd /etc/wireguard
    wg genkey | tee cprivatekey | wg pubkey > cpublickey

    ipnum=$(wg show wg0 allowed-ips  | tail -1 | awk '{print $2}' | awk -F '[./]' '{print $4}')
    i=$((10#${ipnum}+1))  &&  ip=10.0.0.${i}  ip6=${ipv6_range}${i}

    # 生成客户端配置文件
    cat <<EOF >wg_${host}_$i.conf
[Interface]
PrivateKey = $(cat cprivatekey)
Address = $ip/24, $ip6/64
DNS = 8.8.8.8, 2001:4860:4860::8888

[Peer]
PublicKey = $(wg show wg0 public-key)
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25
EOF

    # 在wg服务器中生效客户端peer
    wg set wg0 peer $(cat cpublickey) allowed-ips "${ip}/32, ${ip6}"
    wg-quick save wg0

    # 显示客户端
    cat /etc/wireguard/wg_${host}_$i.conf | qrencode -o wg_${host}_$i.png
    cat /etc/wireguard/wg_${host}_$i.conf | qrencode -o - -t UTF8
    echo -e "${SkyBlue}:: 新客户端peer添加完成; 文件:${Yellow} /etc/wireguard/wg_${host}_$i.conf ${Font}"
    cat /etc/wireguard/wg_${host}_$i.conf
}

wg_clients_menu(){
    echo -e "${RedBG}   Add/Delete WireGuard Client Peer Management ${Font}"
    echo -e "${Green}>  1. Add One WireGuard Client Peer "
    echo -e ">  2. Delete Last WireGuard Client Peer "
    echo -e ">  3. Delete Choose WireGuard Client Peer "
    echo    "------------------------------------------------------"
    echo -e "${SkyBlue}>  4. Exit"
    echo -e ">  5.${RedBG} Reset WireGuard All Client Peer${Font}"
    echo
    read -p "Please Enter the Number(1-5):" num_x
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
echo_RedBG   " One-Step Automated Install WireGuard Script For Debian_9 Ubuntu Centos_7 "
echo_GreenBG "      Open Source Project: https://github.com/hongwenjun/vps_setup        "
    echo -e "${Green}>  1. Display Client Configuration and QR code for Mobile Phone "
    echo -e ">  2. Modify WireGuard Server MTU Number"
    echo -e ">  3. Modify WireGuard Server Port"
    echo -e ">  4. WireGuard+Speeder+Udp2Raw and SS+Kcp+Udp2RAW Automated Configuration"
    echo    "----------------------------------------------------------"
    echo -e "${SkyBlue}>  5. Add/Delete WireGuard Client Peer Management"
    echo -e ">  6. Update/Remove WireGuard and Udp2Raw Service"
    echo -e ">  7. Replace English to Simplified Chinese(中文)"
    echo -e ">  8. ${RedBG}  IPTABLES Firewall Setup Script  ${Font}"
    echo
    echo_SkyBlue  "Usage: ${GreenBG} bash wgmtu ${SkyBlue} [ setup | remove | vps | bench | -U ] "
    echo_SkyBlue                      "                    [ v2ray | vnstat | log | trace | -h ] "
    echo
    read -p "Please Enter the Number(1-8):" num
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
        wget -O wgmtu https://git.io/wgmtu && bash wgmtu
        exit 1
        ;;
        8)
        safe_iptables
        ;;

    #  Manage menu input command line parameters
        setup)
        ss_kcp_udp2raw_wg_speed
        ;;
        remove)
        wireguard_remove
        rc-local_remove
        ;;
        9999)
        bash <(curl -L -s https://git.io/wireguard.sh) 9999
        ;;
        -U)
        update_self
        ;;
        -h)
        wgmtu_help
        ;;
        vps)
        bash <(curl -L -s https://git.io/vps.setup)
        ;;
        vnstat)
        wget -qO- git.io/fxxlb | bash
        ;;
        bench)
        wget -qO- git.io/superbench.sh | bash
        ;;
        trace)
        wget -qO- git.io/fp5lf | bash
        ;;
        v2ray)
        bash <(curl -L -s https://git.io/v2ray_ss.sh)
        ;;
        log)
        cat vps_setup.log
        ;;

        *)
        display_peer
        ;;
        esac
}

wgmtu_help(){
    echo_SkyBlue  "Usage: ${GreenBG} bash wgmtu ${SkyBlue} [ setup | remove | vps | bench | -U ] "
    echo_SkyBlue                      "                    [ v2ray | vnstat | log | trace | -h ] "
    echo
    echo_Yellow "[setup 惊喜 | remove 卸载 | vps 脚本 | bench 基准测试 | -U 更新]"
    echo_Yellow "[v2ray 你懂 | vnstat 流量 | log 信息 | trace 网络回程 | -h 帮助]"
}

# WireGuard 管理命令 bash wgmtu 命令行参数
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
        88)
        scp_conf
        ;;
        9999)
        bash <(curl -L -s https://git.io/fpnQt) 9999
        ;;
        -U)
        update_self
        ;;
        -h)
        wgmtu_help
        ;;
        vps)
        bash <(curl -L -s https://git.io/vps.sh)
        ;;
        vnstat)
        wget -qO- git.io/fxxlb | bash
        ;;
        bench)
        wget -qO- git.io/superbench.sh | bash
        ;;
        trace)
        wget -qO- git.io/fp5lf | bash
        ;;
        v2ray)
        bash <(curl -L -s https://git.io/v2ray.ss)
        ;;
        log)
        cat vps_setup.log
        ;;
    esac
else
	start_menu
fi
