#!/usr/bin/env bash


####### 安装使用原理 本脚本实现自动安装################
#  apt-get install vnstat
#  ip addr 查看网卡名称是否是 eth0，如果是网卡名是 ens3 或者 venet0
#  编辑/etc/vnstat.conf 替换，重启vnstat服务(本脚本自动能自动修改网卡名)
#  sed -i "s/eth0/ens3/g"   /etc/vnstat.conf
#  systemctl restart vnstat

#  crontab -e   修改定时任务, 添加运行脚本

#  # netlog.sh  定时执行转html脚本，每3小时一次，为了修改方便和多台机器用，直接到github更新
#  * */3   *   *  *    wget -qO- git.io/fxxlb | bash

######################################################

# 输出网络流量日志到html
output_html(){


    # html 写文件位置
    if [ ! -e '/etc/redhat-release' ]; then
		INDEX_HTML=/var/www/html/index.html
		mkdir -p   /var/www/html/
	else
        INDEX_HTML=/usr/share/nginx/html/index.html
	fi

    echo '<!DOCTYPE html><meta charset=utf-8><pre>' > ${INDEX_HTML}

    top -b  | head -5 >> ${INDEX_HTML}

    vnstat -u
    vnstat -m >> ${INDEX_HTML}
    vnstat -d >> ${INDEX_HTML}
    vnstat -h >> ${INDEX_HTML}

    echo ' ' >> ${INDEX_HTML}
    echo '    netlog.sh Source code:  https://git.io/fxxlb' >> ${INDEX_HTML}
}

# 安装 vnstat 添加定期运行
vnstat_install(){

    # 判断系统 安装软件
    if [ ! -e '/etc/redhat-release' ]; then
    	# debian 系安装
        apt -y install vnstat nginx
    else
        # centos 系安装 vnstat nginx，如果web没法访问，需要关防火墙
        yum -y install vnstat nginx
        systemctl enable  nginx
        systemctl restart nginx
    fi


    #  vps网卡如果不是eth0，修改成实际网卡
    ni=$(ls /sys/class/net | awk {print} | grep -e eth. -e ens. -e venet.)
    if [ $ni != "eth0" ]; then
        sed -i "s/eth0/${ni}/g"  /etc/vnstat.conf
    fi

    systemctl restart vnstat

    # 设置定时运行脚本
    crontab -l >> crontab.txt
	echo "*  */3   *   *  *    wget -qO- git.io/fxxlb | bash" >> crontab.txt
	crontab crontab.txt
	sleep 2
	if [ ! -e '/etc/redhat-release' ]; then
		systemctl restart cron
	else
		systemctl restart crond
	fi
	rm -f crontab.txt
    echo "vnstat conf @ /etc/vnstat.conf"
}

# 首次运行脚本需要安装
if [ ! -f '/usr/bin/vnstat' ]; then
    vnstat_install
fi

# 输出网络流量信息到html文件
output_html

