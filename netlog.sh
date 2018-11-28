#!/usr/bin/env bash

INDEX_HTML=/var/www/log/index.html
mkdir -p   /var/www/log/

echo '<!DOCTYPE html><meta charset=utf-8><pre>' > ${INDEX_HTML}

top -b  | head -5 >> ${INDEX_HTML}

vnstat -u
vnstat -m >> ${INDEX_HTML}
vnstat -d >> ${INDEX_HTML}
vnstat -h >> ${INDEX_HTML}

echo ' ' >> ${INDEX_HTML}
echo '    netlog.sh Source code:  https://git.io/fxxlb' >> ${INDEX_HTML}

############# 安装使用 ################
#  apt-get install vnstat
#  ip addr 查看网卡名称是否是 eth0，如果是网卡名是 ens3 或者 venet0
#  编辑/etc/vnstat.conf 替换，重启vnstat服务
#  sed -i "s/eth0/ens3/g"   /etc/vnstat.conf
#  systemctl restart vnstat

#  crontab -e   修改定时任务, 添加运行脚本

#  # netlog.sh  定时执行转html脚本，每10分钟一次，为了修改方便和多台机器用，直接到github更新
#  */10  *   *   *  *    wget -qO- git.io/fxxlb | bash

######################################
