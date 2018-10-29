---
title: Vultr_IPV6 机器安装设置，备份和恢复
date: 2018-7-2
tags:  [vps]
---

蘭雅sRGB 龙芯小本服务器 [http://sRGB.vicp.net](http://srgb.vicp.net)


### 获取自己所需服务软件的信息
	ps aux
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

# tar打包部署服务器.txt

```
tar -czv -T filelist -f ss_frp.tar.gz
-T 选项可以指定包含要备份的文件列表

tar -xzvf ss_frp.tar.gz -C /指定目录

/root/filelist
/etc/init.d/brook
/etc/init.d/frps
/etc/init.d/shadowsocks-go
/etc/nginx/1_www.srgb.xyz_bundle.crt
/etc/nginx/2_www.srgb.xyz.key
/etc/nginx/sites-enabled/default
/etc/nginx/sites-enabled/frps
/etc/nginx/sites-enabled/http
/etc/nginx/sites-enabled/https
/etc/shadowsocks-go/config.json
/root/.bashrc
/root/.vimrc
/root/bbr.sh
/root/fuck_net
/usr/bin/shadowsocks-server
/usr/local/brook/brook
/usr/local/brook/brook.conf
/usr/local/frps/frps
/usr/local/frps/frps.ini


### 更换新机器后
====================
apt-get update
apt-get install gcc git nginx htop screen iperf3
passwd root
git clone https://github.com/hongwenjun/vps_setup.git

tar -xzvf ss_frp.tar.gz -C /

systemctl enable frps
systemctl enable brook 
systemctl enable shadowsocks-go
```
### 一键脚本
	wget -qO- git.io/fxQug | bash


### udp2raw_kcptun_ss_for_debian9.sh  一键安装，默认$$只对本地开放
================================================
```
wget --no-check-certificate -O vps_setup.sh https://git.io/fx6UQ  && \
chmod +x vps_setup.sh && ./vps_setup.sh
```
