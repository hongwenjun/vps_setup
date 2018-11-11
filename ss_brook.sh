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

# bbr 设置打开
sysctl_config() {
    sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
    echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
    sysctl -p >/dev/null 2>&1
}
sysctl_config


# 安装所需运行库
apt update
apt install -y  libev-dev libc-ares-dev  libmbedtls-dev libsodium-dev
# 安装脚本 sku
mkdir -p sku && cd sku && wget -O sku.tgz https://git.io/fxy7s && tar -xvf sku.tgz && ./sku.sh

