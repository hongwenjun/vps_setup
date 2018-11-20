## Wireguard 手机和PC客户端设置技巧
[![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/Wireguard/tel_pc.jpg)](https://youtu.be/O__RsZewA60)

### 一键安装wireguard 脚本 For Debian_9  Ubuntu  Centos_7
```
# 一键安装wireguard 脚本 Debian 9 (源:逗比网安装笔记)
wget -qO- git.io/fptwc | bash

# 一键安装wireguard 脚本 Ubuntu   (源:逗比网安装笔记)
wget -qO- git.io/fpcnL | bash

# CentOS7一键脚本安装WireGuard   (https://atrandys.com/2018/886.html)
yum install -y wget && \
wget https://raw.githubusercontent.com/yobabyshark/wireguard/master/wireguard_install.sh \
&& chmod +x wireguard_install.sh && ./wireguard_install.sh
```
[![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/Wireguard/ss_wg.jpg)](https://youtu.be/-cfuQSaJb5w)

###  一键 WireGuard 多用户配置共享脚本
```
# 一键 WireGuard 多用户配置共享脚本 
wget -qO- https://git.io/fpnQt | bash
```
[![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/Wireguard/wg5clients.jpg)](https://youtu.be/TOaihmhrYQY)

![](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/Wireguard/bash_wg5.gif)

### Shadowsocks+Kcp+Udp2Raw加速 服务端  debian 9  Ubuntu
```
# 一键安装 SS+Kcp+Udp2Raw 脚本 快速安装 for debian 9
wget -qO- git.io/fpZIW | bash

# 一键安装 SS+Kcp+Udp2Raw 脚本 第二种编译方式安装速度慢  for debian 9  Ubuntu
wget -qO- git.io/fx6UQ | bash
```

###  本地电脑端 SS 导入配置 
```
ss://YWVzLTI1Ni1nY206c3JnYi54eXpAMTI3LjAuMC4xOjMzMjI=
```

### 导出到客户端配置，修改实际的IP，不要修改默认9009端口
```
# 查询WireGuard状态
wg

# 显示配置文件，修改实际的IP，不要修改默认9009端口
cat /etc/wireguard/client.conf
```
```
#  vultr 服务商的主机默认网卡是 ens3，使用下面命令修改配置
sed -i "s/eth0/ens3/g"  /etc/wireguard/wg0.conf
reboot
```
### Udp2Raw服务TCP伪装 WireGuard 服务端设置脚本
```
wget https://raw.githubusercontent.com/hongwenjun/WinKcp_Launcher/master/wg_udp2raw.sh 
chmod +x wg_udp2raw.sh  && ./wg_udp2raw.sh

```

### 使用BestTrace查看VPS的去程和回程
```
wget -qO- https://raw.githubusercontent.com/hongwenjun/vps_setup/master/autoBestTrace.sh | bash
```

# -------------------------------------------------------------------
#   以下为 Linux 命令学习笔记，适合想提高的朋友学习参考使用
# -------------------------------------------------------------------
#  Windows udp2raw+kcptun 加速tcp流量 简易工具  by 蘭雅sRGB
蘭雅sRGB 龙芯小本服务器 | [sRGB.vicp.net](http://sRGB.vicp.net)

下载程序地址:  https://github.com/hongwenjun/WinKcp_Launcher

### ♦ 最新资讯 ♦Vultr 限时优惠，充值10美元送10美元，3.5美元/月，IP被墙免费换，支持微信、支付宝。
- 点击这个链接注册，也算是对本项目作者的支持鼓励

https://www.vultr.com/?ref=7591742

![](https://raw.githubusercontent.com/hongwenjun/WinKcp_Launcher/master/gui.png)

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
### 一键脚本 ss_brook  和 wireguard
```
# ss_brook脚本 (私人备份恢复脚本)
wget -qO- git.io/fxQug | bash

# 一键安装wireguard 脚本 Debian 9 (源:逗比网安装笔记)
wget -qO- git.io/fptwc | bash

```

### udp2raw_kcptun_ss_for_debian9.sh  一键安装，默认$$只对本地开放
================================================
```
wget --no-check-certificate -O vps_setup.sh https://git.io/fx6UQ  && \
chmod +x vps_setup.sh && ./vps_setup.sh
```
