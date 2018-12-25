---
title: VPS 一键脚本 全家桶
date: 2018-6-4
tags:  [vps]
---

蘭雅sRGB 龙芯小本服务器  http://sRGB.vicp.net
	

### 一个优秀的跨平台 Socks5代理软件 —— Brook 一键安装管理脚本

	wget -N --no-check-certificate https://softs.loan/Bash/brook.sh && chmod +x brook.sh && bash brook.sh
 
如果上面这个脚本无法下载，尝试使用备用下载：

	wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/brook.sh && chmod +x brook.sh && bash brook.sh

```c
  Brook 一键管理脚本 [v1.1.10]
  ---- Toyo | doub.io/brook-jc3 ----

  0. 升级脚本
————————————
  1. 安装 Brook
  2. 升级 Brook
  3. 卸载 Brook
————————————
  4. 启动 Brook
  5. 停止 Brook
  6. 重启 Brook
————————————
  7. 设置 账号配置
  8. 查看 账号信息
  9. 查看 日志信息
 10. 查看 链接信息
————————————

 当前状态: 未安装

 请输入数字 [0-10]:
```

### ShadowsocksR 单/多端口 一键管理脚本

	wget -N --no-check-certificate https://softs.loan/Bash/ssr.sh && chmod +x ssr.sh && bash ssr.sh

备用下载地址（上面的链接无法下载，就用这个）：

	wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssr.sh && chmod +x ssr.sh && bash ssr.sh

```c
  请输入一个数字来选择菜单选项
 
 1. 安装 ShadowsocksR
 2. 更新 ShadowsocksR
 3. 卸载 ShadowsocksR
 4. 安装 libsodium(chacha20)
————————————
 5. 查看 账号信息
 6. 显示 连接信息
 7. 设置 用户配置
 8. 手动 修改配置
 9. 切换 端口模式
————————————
 10. 启动 ShadowsocksR
 11. 停止 ShadowsocksR
 12. 重启 ShadowsocksR
 13. 查看 ShadowsocksR 日志
————————————
 14. 其他功能
 15. 升级脚本
 
 当前状态: 已安装 并 已启动
 当前模式: 单端口
 
请输入数字(1-15)：

```

### 一键安装ss 
	wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
	chmod +x shadowsocks-all.sh
	./shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log

### 一键安装最新内核并开启 BBR 脚本
	wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh

## LNMP一键安装包 V1.5
详细请访问 [https://lnmp.org/install.html](https://lnmp.org/install.html)

### 登陆后运行：
	screen -S lnmp
## 安装LNMP稳定版
	wget -c http://soft.vpser.net/lnmp/lnmp1.5.tar.gz && tar zxf lnmp1.5.tar.gz && cd lnmp1.5 && ./install.sh lnmp

## 如需要无人值守安装
[https://lnmp.org/auto.html](https://lnmp.org/auto.html)

点击 生成 按钮会生成对应命令，示例如下

	wget http://soft.vpser.net/lnmp/lnmp1.5.tar.gz -cO lnmp1.5.tar.gz && tar zxf lnmp1.5.tar.gz && cd lnmp1.5 && LNMP_Auto="y" DBSelect="2" DB_Root_Password="lnmp.org" InstallInnodb="y" PHPSelect="5" SelectMalloc="1" ./install.sh lnmp