---
title: Vultr_VPS学习折腾
date: 2018-5-17
tags:  [vps]
---

蘭雅sRGB 龙芯小本服务器 | [sRGB.vicp.net](http://sRGB.vicp.net)
	
### 选择便宜的vps
新注册Vultr用户赠送25美元，不要用使用支付宝充值，使用信用卡或者paypal
[https://www.vultr.com/promo25b](https://www.vultr.com/promo25b?ref=7425413)  点进去看有没$25的英文图案。
如果没有活动，就看自己选择了。 昨天注册充值10美元，赠送25美元，推特发朋友圈再送3美元。
如果选择 迈阿密2.5美元的主机，可以玩15个月了，不过赠送的金额可能要1年用掉，所以可以5美元和2.5美元的轮换玩。
看视频现在试用5美元西雅图的主机还不错。

帮他做个广告，点这个链接，可能有25美元赠送的。
[https://www.vultr.com/promo25b?ref=7425413](https://www.vultr.com/promo25b?ref=7425413)

### 修改密码
	passwd root

### 一键安装ss 
	wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
	chmod +x shadowsocks-all.sh
	./shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log

### 一键安装最新内核并开启 BBR 脚本
	wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh

### vim和控制台高亮
	wget -O .vimrc http://srgb.vicp.net/srgb/vim/_vimrc
	wget -O .bashrc http://srgb.vicp.net/srgb/vim/_bashrc

### 安装 监控软件htop 和网页服务器 nginx
	apt-get install htop
	apt-get install nginx

### 默认主页根在 /var/www/html, 可以修改default文件
	vim /etc/nginx/sites-enabled/default 

### 从github 迁移博客 到vps
	git clone https://github.com/用户名/用户名.github.io.git www

可以 git pull 命令写到定时脚本里