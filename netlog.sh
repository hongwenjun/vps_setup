#!/usr/bin/env bash

INDEX_HTML=/var/www/log/index.html
mkdir -p   /var/www/log/

echo '<pre>' > ${INDEX_HTML}

top -b  | head -5 >> ${INDEX_HTML}

vnstat -u
vnstat -m >> ${INDEX_HTML}
vnstat -d >> ${INDEX_HTML}
vnstat -h >> ${INDEX_HTML}


############# 安装使用 ################
# apt-get install vnstat
# crontab -e   修改定时任务, 添加两行 

#  # netlog.sh  定时执行转html脚本
#  8 *   *   *  *          wget -qO- git.io/fxxlb | bash

######################################
