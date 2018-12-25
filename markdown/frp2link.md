---
title: frp连接2个服务器
date: 2018-6-4
tags:  [frp]
---

蘭雅sRGB 龙芯小本服务器 [http://sRGB.vicp.net](http://srgb.vicp.net)

# 修改开机脚本
	# 龙芯8089D debian版的开机脚本
	vim /etc/init.d/rc.local

启动2个配置脚本，连2个服务器
写到开机脚本里

	sleep 3
	cd /root/frp  && ./frpc -c frpc.ini > /dev/null 2>&1 &
	
	sleep 3
	cd /root/frp  && ./frpc -c frpc.ini.hk > /dev/null 2>&1 &

---

再分别 frpc.ini 和 frpc.ini.hk 两个客户端配置文件

### 这个配置用来连接到自己架设的frps服务器

```c++
frpc.ini

# 主配置
[common]
server_addr = srgb.xyz
server_port = 7000
token = www.nat.ee
user = srgb

# 日志
log_file = ./frpc.log
log_level = info
log_max_days = 7

[web]
type = http
local_port = 80
local_ip = 127.0.0.1
custom_domains = srgb.xyz , s.srgb.xyz

[ssh]
type = tcp
local_port = 22
remote_port = 11122
local_ip = 127.0.0.1
custom_domains = s.srgb.xyz

```

###  连接 免费frp香港公共服务
注意客户端版本和服务器不要相差太多

[https://www.nat.ee/frp/hkfrp](https://www.nat.ee/frp/hkfrp)
访问服务器公告，或者配置更新


```c++
frpc.ini.hk
 
#  https://www.nat.ee/frp/hkfrp
#  免费frp香港公共服务

# 主配置
[common]
server_addr = hk.nat.ee
server_port = 7000
token = www.nat.ee
user = hk

# 日志
#log_file = ./frpc2.log
log_level = info
log_max_days = 7

[http]
type = http
local_port = 80
local_ip = 127.0.0.1
custom_domains = srgb.nwct.bid , hk.srgb.xyz , frp.srgb.xyz

[ssh]
type = tcp
local_port = 22
remote_port = 11122
local_ip = 127.0.0.1
custom_domains = srgb.nwct.bid

```

---
调试配置文件的时候，可以先把log_file 注释掉。

使用screen 命令，让frpc程序运行在后台

	screen ./frpc -c frpc.ini