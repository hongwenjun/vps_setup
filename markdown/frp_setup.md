---
title: frps配置测试
date: 2018-6-4
tags:  [frp]
---

蘭雅sRGB 龙芯小本服务器 [http://sRGB.vicp.net](http://srgb.vicp.net)

### frps服务端 一键安装脚本

[https://github.com/clangcn/onekey-install-shell](https://github.com/clangcn/onekey-install-shell)

ssh登陆命令行输入3行命令就可以安装

	wget --no-check-certificate https://raw.githubusercontent.com/clangcn/onekey-install-shell/master/frps/install-frps.sh -O ./install-frps.sh
	chmod 700 ./install-frps.sh
	./install-frps.sh install


装好后，就可以用了，不过改成以下配置，为了测试方便点

### 管理器使用方法
	Usage: /etc/init.d/frps {start|stop|restart|status|config|version}
	
	frps stop     # 先停止
	frps config   # 配置服务器
	frps start    # 启动服务 


### 服务端配置 frps.ini
----
	[common]
	bind_addr = 0.0.0.0
	bind_port = 7000
	kcp_bind_port = 7000
	bind_udp_port = 7001
	token = www.nat.ee
	vhost_http_port = 8080
	vhost_https_port = 443
	allow_ports = 10001-19999
	#subdomain_host = nat.ee
	max_pool_count = 6
	max_ports_per_client = 3
	tcp_mux=true
	heartbeat_timeout = 90
	authentication_timeout = 900
	#[admin]
	dashboard_port = 7500
	dashboard_user = admin
	dashboard_pwd = admin
	#[log]
	#log_file = ./frps.log
	log_level = info
	log_max_days = 7

------

为了测试把把域名 www.srgb.xyz 和 s.srgb.xyz 都绑定到服务器IP

使用同名CNAME 也可以，也可以直接hosts里设置，不知是否可行

客户1和2  user 不能相同

然后 custom_domains =  分别 www.srgb.xyz  和 s.srgb.xyz

服务器本身占用80端口了
所以 www.srgb.xyz:8080     s.srgb.xyz:8080 访问测试设备

www.srgb.xyz:7500  查看登陆情况

---

### 客户端1 配置
这台机器是 龙芯 8089D，下载mips 的客户端， [https://github.com/fatedier/frp/releases](https://github.com/fatedier/frp/releases)

### frpc.ini    
	# 主配置
	[common]
	server_addr = srgb.xyz
	server_port = 7000
	token = www.nat.ee
	user = srgb
	
	# 日志
	#log_file = ./frpc.log
	log_level = info
	log_max_days = 7
	
	[srgb]
	type = http
	local_port = 80
	local_ip = 127.0.0.1
	custom_domains = www.srgb.xyz


----

客户端2 配置  ，这台机器是PC机，windows系统，

### frpc.ini 
	# 主配置
	[common]
	server_addr = srgb.xyz
	server_port = 7000
	token = www.nat.ee
	user = pc
	
	# 日志
	#log_file = ./frpc.log
	log_level = info
	log_max_days = 7
	
	[srgb]
	type = http
	local_port = 80
	local_ip = 127.0.0.1
	custom_domains = s.srgb.xyz

---

因为一般服务器都有web服务，主机80端口都是已经占用，只能使用其他端口访问。

	# s.srgb.xyz:8080     绑定的子域名后面有跟一个端口号

### 使用Nginx 反代理frp，省略后缀端口口

	vim /etc/nginx/sites-enabled/default
如果使用一键 lnmp 安装的配置文件，可以建立 vhost 然后再手工修改

WEB主机配置文件末尾添加

	map $http_x_forwarded_for $clientRealip {
	   "" $remote_addr;
	   ~^(?P<firstAddr>[0-9\.]+),?.*$  $firstAddr;
	}
	
	server {
	       listen 80;
	       server_name frp.srgb.xyz;  #为frp的控制台绑定一个域名，这样你就可以用http://frp.srgb.xyz访问你的控制台了
	       location / {
	           proxy_pass http://127.0.0.1:7500;  #此处的7500就是你安装frp时设置的dashboard_port端口
	           proxy_set_header Host $host;
	           proxy_set_header X-Real-IP $clientRealip;  # $remote_addr;
	           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	       }
	}
	
	server {
	       listen 80;
	       server_name s.srgb.xyz;   #也可以将所有的srgb.xyz子域名都绑定，
	       location / {
	           proxy_pass http://127.0.0.1:8080; #此处的8080就是你安装frp时设置的vhost_http_port端口
	           proxy_set_header Host $host;
	           proxy_set_header X-Real-IP $clientRealip;  # $remote_addr;
	           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	       }
	}
	
