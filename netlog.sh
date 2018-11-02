#!/usr/bin/env bash

INDEX_HTML=/var/www/log/index.html

echo '<pre>' > ${INDEX_HTML}

vnstat -u

vnstat -m >> ${INDEX_HTML}
vnstat -d >> ${INDEX_HTML}
vnstat -h >> ${INDEX_HTML}

top -b  | head -5 >> ${INDEX_HTML}

######################################

# crontab -e   修改定时任务, 添加两行 

#  # netlog.sh    https://github.com/hongwenjun/vps_setup/blob/master/netlog.sh
#  8 *   *   *  *          wget -qO- git.io/fxxlb | bash

######################################
