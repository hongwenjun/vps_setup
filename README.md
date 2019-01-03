# 一键安装wireguard 脚本 For Debian_9  Ubuntu  Centos_7
```
# 一键安装wireguard 脚本 Debian 9 (源:逗比网安装笔记)
wget -qO- git.io/fptwc | bash

# 一键安装wireguard 脚本 Ubuntu   (源:逗比网安装笔记)
wget -qO- git.io/fpcnL | bash

# CentOS7一键脚本安装WireGuard   (https://atrandys.com/2018/886.html)
yum install -y wget && \
wget https://raw.githubusercontent.com/atrandys/wireguard/master/wireguard_install.sh \
&& chmod +x wireguard_install.sh && ./wireguard_install.sh
```

### 一键安装wireguard 参考演示视频集合

| [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/ss_wgmtu.jpg)](https://youtu.be/-sJLfPg12oc) | [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/wg_mac_pc_tel.jpg)](https://youtu.be/dkXWicxak3w) | [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/wgmtu.jpg)](https://youtu.be/e86tCRDqu8c) |
| :------| ------: | :------: |
| [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/iptables_ytb.jpg)](https://youtu.be/Jb3b8SbFQLM) | [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/winkcp_ytb.jpg)](https://youtu.be/HjGO2sAPOFM) | [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/gcp_ssh_key.jpg)](https://youtu.be/qhwK5XUJeWE)|

| [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/wg5clients.jpg)](https://youtu.be/TOaihmhrYQY) | [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/tel_pc.jpg)](https://youtu.be/O__RsZewA60) | [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/ss_wg.jpg)](https://youtu.be/-cfuQSaJb5w)|

###  一键 WireGuard 多用户配置共享脚本
```
# 一键 WireGuard 多用户配置共享脚本 
wget -qO- https://git.io/fpnQt | bash

# WireGuar 服务端修改MTU数值，修改服务器端口脚本，Udp2Raw服务TCP伪装设置
# 自动下载，使用命令  bash wgmtu  设置   
```
![](https://raw.githubusercontent.com/hongwenjun/img/master/ss_wg_speed.webp)

### 一键 SS+KCP+UDP2RAW 和 WG+SPEED+UDP2RAW 设置脚本
```
# 先安装 一键 WireGuard 脚本，动手能力使用命令设置
bash wgmtu
```

### ------------------------- 分割线以下可以不看 --------------------------

### 导出到客户端配置，修改实际的IP，修改成实际端口号
```
# 查询WireGuard状态
wg

# 显示配置文件
cat /etc/wireguard/client.conf
```
### 使用命令行显示配置和生成二维码
![](https://raw.githubusercontent.com/hongwenjun/img/master/qrencode.png)
```
# 文本显示一个配置文件
cat wg_vultr_5.conf

# 把配置文件使用通道传到二维码软件
# -o- 表示显示在屏幕 -t utf8 文本格式
cat wg_vultr_5.conf  | qrencode -o- -t utf8
```
### 遇到wg连接主机而没有流量，使用 Ip addr 命令检查vps网卡是否是ensx，参考下面修改配置重启
```
#  一键脚本已经检查出vultr主机，自动修改配置，不用再手工运行
#  vultr 服务商的主机默认网卡是 ens3，使用下面命令修改配置
sed -i "s/eth0/ens3/g"  /etc/wireguard/wg0.conf
reboot

#  GCP 香港 Ubuntu系统 默认网卡是 ens4，使用下面命令修改配置(脚本已经自动修改)
#  GCP 香港 Ubuntu系统 没带python，不能开启临时web下载，可以 apt install -y python 安装
sed -i "s/eth0/ens4/g"  /etc/wireguard/wg0.conf
reboot

# 原来的 iptables 防火墙规则
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens3 -j MASQUERADE

# 测试新的路由防火墙规则
PostUp   = iptables -I FORWARD -i wg0 -j ACCEPT; iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

```

### Shadowsocks+Kcp+Udp2Raw加速 服务端  debian 9  Ubuntu
```
# 一键安装 SS+Kcp+Udp2Raw 脚本 快速安装 for debian 9
wget -qO- git.io/fpZIW | bash

# 一键安装 SS+Kcp+Udp2Raw 脚本 第二种编译方式安装速度慢  for debian 9  Ubuntu
wget -qO- git.io/fx6UQ | bash
```


### Telegram 代理 MTProxy Go版 一键脚本(源:逗比网)
```
# Telegram 代理 MTProxy Go版 一键脚本(源:逗比网)
wget -qO mtproxy_go.sh  git.io/fpWo4 && bash mtproxy_go.sh
```
### 使用BestTrace查看VPS的去程和回程
```
wget -qO- https://raw.githubusercontent.com/hongwenjun/vps_setup/master/autoBestTrace.sh | bash
```

### Google Cloud Platform  GCP实例开启密码与root用户登陆
```
#  GCP一键启用root帐号命令
#  wget -qO- git.io/fpQWf | bash
```

### 使用 vnstat 检测VPS流量使用
```
# 一键安装 vnstat 流量检测
wget -qO- git.io/fxxlb | bash
```
### linux下golang环境搭建自动脚本
```
# linux下golang环境搭建自动脚本  by 蘭雅sRGB
wget -qO- https://git.io/fp4jf | bash
```

# -------------------------------------------------------------------
#   以下为 Linux 命令学习笔记，适合想提高的朋友学习参考使用
# -------------------------------------------------------------------
#  Windows udp2raw+kcptun 加速tcp流量 简易工具  by 蘭雅sRGB
蘭雅sRGB 龙芯小本服务器 | [sRGB.vicp.net](http://sRGB.vicp.net)

下载程序地址:  https://github.com/hongwenjun/WinKcp_Launcher

![](https://raw.githubusercontent.com/hongwenjun/WinKcp_Launcher/master/WinKcp_Launcher.webp)

### Debian或Ubuntun mini版 wget下载证书无法验证
apt-get install -y ca-certificates

# Debian远程SSH汉字utf-8乱码解决
```
apt-get  install locales
dpkg-reconfigure locales
```
# 查看默认字符集是否是en_US.UTF-8
```
$ vim /etc/default/locale
LANG=en_US.UTF-8
```

# vim和bash高亮,tmux 配置
```
wget -O .vimrc --no-check-certificate https://raw.githubusercontent.com/hongwenjun/srgb/master/vim/_vimrc
wget -O .bashrc --no-check-certificate https://raw.githubusercontent.com/hongwenjun/srgb/master/vim/_bashrc
wget -O .tmux.conf --no-check-certificate https://raw.githubusercontent.com/hongwenjun/tmux_for_windows/master/.tmux.conf
```
# 修改默认主页地址 和 目录索引显示
```
$ vim /etc/nginx/sites-enabled/default
root /var/www;
autoindex on;

```

### udp2raw_kcptun_ss_for_debian9.sh  一键安装，默认$$只对本地开放
================================================
```
wget --no-check-certificate -O vps_setup.sh https://git.io/fx6UQ  && \
chmod +x vps_setup.sh && ./vps_setup.sh
```



### 获取自己所需服务软件的信息
```
ps aux
ps aux | grep -e shadowsocks -e brook -e ss-server -e kcp-server -e udp2raw -e speederv2 -e python
ls /sys/class/net | awk {print} | head -n 1
```
可以得到软件的安装目录和配置文件目录

```	
/usr/bin/shadowsocks-server -c /etc/shadowsocks-go/config.json
/usr/local/frps/frps -c /usr/local/frps/frps.ini
/bin/bash /etc/init.d/brook start
./brook servers -l :2333 srgb.xyz
screen ./fuck_net
screen iperf3 -s
```


### 打包程序和配置
```
tar -czvf  ss_frp.tar.gz  /etc/init.d/brook  /usr/local/brook/brook  /usr/local/brook/brook.conf   \
    /usr/bin/shadowsocks-server   /etc/shadowsocks-go/config.json   /etc/init.d/shadowsocks-go  \
    /usr/local/frps/frps   /usr/local/frps/frps.ini  /etc/init.d/frps  /root/fuck_net
```
- 或者使用文件表打包
```
tar -czv -T filelist -f ss_frp.tar.gz
-T 选项可以指定包含要备份的文件列表
```

## 搬迁备份文件，使用wget

- 可以先不删除原来机器，新建立机器使用wget把备份文件挪过去
- 本笔记，由于使用Vultr_IPV6的机器，所以使用wget先下载到本地电脑了

### 本地上传到服务器/tmp 

	$ scp /c/Users/vip/Desktop/ss_frp/ss_frp.tar.gz root@[2001:19f0:8001:c85:5400:01ff:fe91:7ed8]:/tmp/ss_frp.tar.gz
 
 
### 服务器上解压和开启服务

```
cd / && tar -xvf /tmp/ss_frp.tar.gz
/etc/init.d/frps  start && /etc/init.d/brook start && /etc/init.d/shadowsocks-go start
```

### 注册服务，禁止服务

```
systemctl enable frps
systemctl enable brook 
systemctl enable shadowsocks-go

systemctl disable frps #禁止的脚本
```
