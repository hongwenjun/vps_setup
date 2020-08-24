# Debian 安装 Transmission 教程和一键脚本

# 一键安装 transmission 服务脚本
```bash
wget https://raw.githubusercontent.com/hongwenjun/vps_setup/master/rclone/transmission.sh
bash transmission.sh
```
### 程序安装
	apt install transmission transmission-daemon

### 停止服务	
	systemctl stop  transmission-daemon

### 编辑 transmission 配置	
	vim /etc/transmission-daemon/settings.json

### 建立下载目录，添加程序权限	
	mkdir -p /var/rclone
	chown debian-transmission:debian-transmission  /var/rclone

### 启动服务	
	systemctl restart  transmission-daemon
	
### 获取 服务器 IP
	curl ip.sb

### 浏览器中输入网址管理
	http://67.158.54.154:9091

###  tr-web-control 安装中文语言包
```bash
TransmissionWeb=/usr/share/transmission/web
cd $TransmissionWeb
cp index.html index.original.html

git clone https://github.com/ronggang/transmission-web-control.git
cp -r transmission-web-control/src/*   $TransmissionWeb
rm transmission-web-control -rf

```

### 使用 transmission-create 建立种子
```
transmission-create -p -t https://www.hddolby.com/announce.php  \
-o pt/hddb_mytest.torrent                                      \
-s 2048  /var/rclone/Erotic.Ghost.Story.III.1992.BluRay.1080p.DTS-HD.MA.2.0.x265.10bit-BeiTai  &

参数
-p 表示这是私用的种子，这个必须要加上
-o 生成的种子输出位置，不要忘记把名字打上
-t tracker的地址， 按实际PT站，大家自行修改
-s 每个文件块的大小，单位是KB，设置的是2M，也就是2048KB
   最后空一格写源文件的位置，也就是文件的存放位置，可以是一个文件或者一整个目录
   最后可以空一行加一个&，这样即使关掉窗口也可以在后台运行, 行尾\ 表示续行

- 相关 find / -name transmission  用来查找文件位置，要用的就是transmission-create
```

