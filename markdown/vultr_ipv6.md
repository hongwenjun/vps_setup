---
title: Vultr_IPV6 机器安装设置，添加 IPv4 教程
date: 2018-7-2
tags:  [vps]
---

蘭雅sRGB 龙芯小本服务器 [http://sRGB.vicp.net](http://srgb.vicp.net)


### 本地电脑开启ipv6支持，可以使用XX-Net的 enable_ipv6.bat
- XX-Net\code\3.11.10\gae_proxy\local\ipv6_tunnel\enable_ipv6.bat

### 参考 Vultr 2.5 美金添加 IPv4 教程

[https://www.lijingquan.net/archives/4802](https://www.lijingquan.net/archives/4802)

登陆 Vultr;  新建了一个IPv4和一个IPv6 Only Debian系统

进入Server Information,选 Settings，再选IPv4， Additional IPv4 IP，先增加一个收费ipv4
点击  networking configuration 链接，可以看到

![](img/interfaces.png)

ssh  root@[IPV6] 远程登陆，先修改密码  

	vim /etc/network/interfaces
	service networking restart
 
修改之前的看到的网络配置，修改为静态ip，重新启动网络。
(这时候其实已经可以用IPv4了,外网可以ping进来了,但是不要使用IPv4连接,修改路由表过程会断IPv4.)
只是使用 ping  8.8.8.8 网络还是阻断的，要修改默认的路由。

查看默认的路由

```
root@vultr:~# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         100.64.0.1      0.0.0.0         UG    0      0        0 ens3
10.25.96.0      0.0.0.0         255.255.240.0   U     0      0        0 ens7
100.64.0.0      0.0.0.0         255.192.0.0     U     0      0        0 ens3
169.254.0.0     0.0.0.0         255.255.0.0     U     0      0        0 ens3
207.148.112.0   0.0.0.0         255.255.254.0   U     0      0        0 ens3
root@vultr:~# ip route show
default via 100.64.0.1 dev ens3 onlink 
10.25.96.0/20 dev ens7 proto kernel scope link src 10.25.96.3 
100.64.0.0/10 dev ens3 proto kernel scope link src 100.68.5.186 
169.254.0.0/16 dev ens3 scope link 
207.148.112.0/23 dev ens3 proto kernel scope link src 207.148.113.46 
root@vultr:~# 
```
看到走的还是运营商NAT,删掉他,并添加默认路由,要使用是刚才添加的公网IPV4和实际的网卡编号.
	
	route r del default gw 100.64.0.1
	ip route add default via 207.148.113.46 dev ens3
	
具体如下:
```
root@vultr:~# route del default gw 100.64.0.1
root@vultr:~# ip route list
10.25.96.0/20 dev ens7 proto kernel scope link src 10.25.96.3 
100.64.0.0/10 dev ens3 proto kernel scope link src 100.68.5.186 
169.254.0.0/16 dev ens3 scope link 
207.148.112.0/23 dev ens3 proto kernel scope link src 207.148.113.46 
root@vultr:~# ip route add default via 207.148.113.46 dev ens3
root@vultr:~# ip route list
default via 207.148.113.46 dev ens3 
10.25.96.0/20 dev ens7 proto kernel scope link src 10.25.96.3 
100.64.0.0/10 dev ens3 proto kernel scope link src 100.68.5.186 
169.254.0.0/16 dev ens3 scope link 
207.148.112.0/23 dev ens3 proto kernel scope link src 207.148.113.46 

```

再使用 ping 8.8.8.8 如果通畅了，就表示增加的ipv4可以使用了  
然后就可以使用 一键脚本安装服务器了，安装好软件后，可以把ipv4删除掉
节省一下月租费。