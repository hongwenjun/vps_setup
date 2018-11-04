#!/bin/bash

# 常用工具和配置
apt-get update
apt-get install htop tmux screen iperf3
wget -O .vimrc      --no-check-certificate https://raw.githubusercontent.com/hongwenjun/srgb/master/vim/_vimrc
wget -O .bashrc     --no-check-certificate https://raw.githubusercontent.com/hongwenjun/srgb/master/vim/_bashrc
wget -O .tmux.conf  --no-check-certificate https://raw.githubusercontent.com/hongwenjun/tmux_for_windows/master/.tmux.conf

# 下载ss_brook包和解压
wget -O ss_brook.tgz  https://git.io/fxQuY
tar -xzvf ss_brook.tgz  -C /
rm ss_brook.tgz

# 加入开机服务
systemctl enable frps
systemctl enable brook
systemctl enable shadowsocks-go

# 开启服务
/etc/init.d/frps start
/etc/init.d/brook start
/etc/init.d/shadowsocks-go start
