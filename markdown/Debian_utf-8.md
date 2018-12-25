---
title: Debian远程SSH汉字utf-8乱码解决等
date: 2018-7-2
tags:  [linux,vps]
---

蘭雅sRGB 龙芯小本服务器 [http://sRGB.vicp.net](http://srgb.vicp.net)

### Debian远程SSH汉字utf-8乱码解决
	aptitude install locales
	dpkg-reconfigure locales

### 配置编码进入选择(默认也选择)：
	en_US.UTF8

### 查看默认字符集是否是en_US.UTF-8
	$ vim /etc/default/locale
	LANG=en_US.UTF-8


### 配置编码中文utf-8
	dpkg-reconfigure locales

### 系统环境默认的区域设置成
	zh_CN.UTF-8

### 退出重新登陆ssh 才起作用

### vim和控制台高亮
	wget -O .vimrc --no-check-certificate https://raw.githubusercontent.com/hongwenjun/srgb/master/vim/_vimrc
	wget -O .bashrc --no-check-certificate https://raw.githubusercontent.com/hongwenjun/srgb/master/vim/_bashrc


### 安装 监控软件htop 
	apt-get install htop

### 网页服务器 nginx
	apt-get install nginx
	
### 修改默认主页地址 和 目录索引显示
	$ vim /etc/nginx/sites-enabled/default

	root /var/www;
	autoindex on;


### 设置学习的东西
https://gist.github.com/nickfox-taterli