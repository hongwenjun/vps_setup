## 一键安装wireguard 脚本(支持IPV6) For Debian_9  Ubuntu  Centos_7
```
# 一键安装wireguard 脚本 Debian 9 (源:逗比网安装笔记)
wget -qO- git.io/fptwc | bash

# 一键安装wireguard 脚本 Ubuntu   (源:逗比网安装笔记)
wget -qO- git.io/fpcnL | bash

# CentOS 7 一键脚本安装WireGuard  (官方脚本自动升级内核)
wget -qO- git.io/fhnhS | bash
```

### CentOS 7 测试 GCP和Vultr 都能自动升级内核，如果辣鸡要升级内核
	yum install -y wget vim             # Cetos 安装 wget 和 vim 工具
	wget -qO wg.sh git.io/fhnhS && bash wg.sh kernel    # Centos 升级内核命令

### 增加功能  <<添加/删除 WireGuard Peer 客户端管理 >>
[![点击图片链接视频演示](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/wgmtu.png)](https://youtu.be/iOnAeWRvSQI)

```
# 一键 WireGuard 多用户配置共享脚本
wget -qO- https://git.io/fpnQt | bash

```

# WireGuard  测试配置实例

### TunSafe 导入客户配置连接后，浏览器访问  http://10.0.0.1  或者  http://ip111.cn/
可以访问或者检测出你当前IP地址，表示软件设置没问题，*测试服务器只测试连接，不提供翻墙服务*

### cat /etc/wireguard/wg_VM-0-13-debian_3.conf   WireGuard直连配置
```
[Interface]
PrivateKey = aMWVZ78fCeOG1e0ljJ06cvHqyXVqbfsEw4pZz+TNW24=
Address = 10.0.0.3/24
DNS = 8.8.8.8

[Peer]
PublicKey = 7+lLY7yN97cbwe/OkNR4pyHuX/uCiVc/maPrneVcHg8=
Endpoint = 118.24.232.233:8000
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25
```

### cat /etc/wireguard/wg0.conf    WireGuard 服务端配置文件实例
```
[Interface]
PrivateKey = cFNf5sTNOXnPygDEuSD8kJ8NlisBY4OOxR/tBpJ7+Ws=
Address = 10.0.0.1/24
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = 8000
DNS = 8.8.8.8
MTU = 1420

[Peer]
PublicKey = p4L8R4YutqtSq64pAmOclcdqdo0e1Jo5lTQh0Um8BH4=
AllowedIPs = 10.0.0.218/32

[Peer]
PublicKey = c1R+xHfGweOAotOQNdcqeMlFHzG8L6oNp8ai/MARQik=
AllowedIPs = 10.0.0.2/32

[Peer]
PublicKey = /cHDZfLZm8OLPiPjMxhlA8U+sd1tOPwf6qXhpm38dQI=
AllowedIPs = 10.0.0.3/32

```

### 中国白名单分流  route.zip
为使用各类全局代理VPN的windows用户提供国内国外IP的分流服务。原理是将国内IP写进系统路由表，路由表以外的IP走VPN代理。

[https://github.com/hongwenjun/china_ip_list](https://github.com/hongwenjun/china_ip_list)


### TunSafe-TAP 虚拟网卡驱动  TunSafe-TAP-9.21.2.exe
### TunSafe 客户端 TunSafe-1.4.exe

![](https://raw.githubusercontent.com/hongwenjun/img/master/ss_wg_speed.webp)


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
