#!/bin/bash

# Centos 安装脚本源  https://github.com/atrandys/wireguard

# 判断系统
if [ ! -e '/etc/redhat-release' ]; then
    echo "仅支持centos7"
    exit
fi
if  [ -n "$(grep ' 6\.' /etc/redhat-release)" ] ;then
    echo "仅支持centos7"
    exit
fi

# 更新内核
update_kernel(){

    yum -y install epel-release curl
    sed -i "0,/enabled=0/s//enabled=1/" /etc/yum.repos.d/epel.repo
    yum remove -y kernel-devel
    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
    yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
    yum -y --enablerepo=elrepo-kernel install kernel-ml
    sed -i "s/GRUB_DEFAULT=saved/GRUB_DEFAULT=0/" /etc/default/grub
    grub2-mkconfig -o /boot/grub2/grub.cfg
    wget https://elrepo.org/linux/kernel/el7/x86_64/RPMS/kernel-ml-devel-4.19.1-1.el7.elrepo.x86_64.rpm
    rpm -ivh kernel-ml-devel-4.19.1-1.el7.elrepo.x86_64.rpm
    yum -y --enablerepo=elrepo-kernel install kernel-ml-devel
    read -p "需要重启VPS，再次执行脚本选择安装wireguard，是否现在重启 ? [Y/n] :" yn
	[ -z "${yn}" ] && yn="y"
	if [[ $yn == [Yy] ]]; then
		echo -e "VPS 重启中..."
		reboot
	fi
}

# centos7安装wireguard
wireguard_install(){
    curl -Lo /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
    yum install -y epel-release
    yum install -y wireguard-dkms wireguard-tools
    yum -y install qrencode iptables-services

    systemctl stop firewalld  && systemctl disable firewalld
    systemctl enable iptables && systemctl start iptables
    iptables -F  && service iptables save && service iptables restart
    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo "net.ipv4.ip_forward = 1" > /etc/sysctl.conf

    mkdir -p /etc/wireguard
    cd /etc/wireguard
    wg genkey | tee sprivatekey | wg pubkey > spublickey
    wg genkey | tee cprivatekey | wg pubkey > cpublickey
    chmod 777 -R /etc/wireguard
    systemctl enable wg-quick@wg0
}

# Bash执行选项  kernel 升级内核  默认安装 wireguard
if [[ $# > 0 ]];then
	key="$1"
	case $key in
		kernel)
		update_kernel
		;;
	esac
else
	wireguard_install
	# 一键 WireGuard 多用户配置共享脚本
    wget -qO- https://git.io/fpnQt | bash
fi
