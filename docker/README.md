## Docker 搭建Portainer可视化界面

Portainer是Docker的图形化管理工具，提供状态显示面板、应用模板快速部署、
容器镜像网络数据卷的基本操作（包括上传下载镜像，创建容器等操作）、事件日志显示、
容器控制台操作、Swarm集群和服务等集中管理和操作、登录用户管理和控制等功能。

### 查询当前有哪些Portainer镜像

	docker search portaine

### 安装Docker可视化界面Portainer

```
docker run --name Portainer          \
  --restart=always  -d -p 9000:9000  \
  -v /var/run/docker.sock:/var/run/docker.sock  \
  -v /opt/portainer_data:/data        \
  portainer/portainer
```

### 删除Portainer服务

	docker rm  -f Portainer
	docker rmi portainer/portainer

-----

## Docker 安装和运行 Nginx

```
# 安装Docker软件一键脚本
curl -fsSLo- get.docker.com | /bin/sh
```

###  Docker 拉取最新版的 Nginx 镜像
docker pull nginx:latest

### 运行nginx-web容器,
```
docker run --rm -d -p 80:80 --name nginx-web \
  -v /var/www/html:/usr/share/nginx/html \
  nginx
```
---
```
# --rm 结束删除容器，-d 后台运行，-p 80:80 映射端口 本地:容器
# -v /var/www/html:/usr/share/nginx/html 本地目录/var/www/html 映射到 /usr/share/nginx/html
```

### HTML5 测速
```
docker run -d -p 8888:80  --name  html5speed \
          --cpus 0.5    --restart=always     \
          ilemonrain/html5-speedtest:alpine
```

###  登入nginx-web 容器查看
docker exec -it  nginx-web  /bin/bash


### 实际部署，服务器重启，nginx-web 容器 也自动运行
```
docker run -d -p 80:80 --name  nginx-web \
	--cpus 0.5   --restart=always          \
	-v /var/www:/usr/share/nginx/html      \
	nginx

## --restart=always    参数能够使我们在重启docker时，自动启动相关容器
## --cpus 0.3

docker stats        # 查看容器运行情况

CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
8d025484dd41        nginx-web           0.00%               2.391MiB / 420.4MiB   0.57%               16.8kB / 64.5kB     11MB / 0B           2
```

---------

###  部署 nginx-php7 和 php 相册
```
docker run -d -p 80:80 --name  nginx-web \
	--cpus 0.5   --restart=always     \
	-v /mnt/downloads:/data/wwwroot     \
    skiychan/nginx-php7

downloads=/mnt/downloads

cd  ${downloads}
wget https://github.com/hongwenjun/srgb/raw/master/files.photo.gallery/index.php
mkdir -p _files
chown -R www-data:www-data  _files
chmod 0777 _files/

```
-----
## Docker 安装 WordPress 博客程序
- 

```
#  wordpress 安装目录和程序下载

mkdir /mnt/wordpress -p
cd    /mnt/wordpress

wget https://wordpress.org/latest.tar.gz
tar xf  latest.tar.gz
chown -R www-data:www-data wordpress
mv  wordpress www

#  容器 linuxserver/nginx 安装，已经包含php7.x支持

docker run -d \
  --name=nginx \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -p 80:80 \
  -p 443:443 \
  -v /mnt/wordpress:/config \
  --restart unless-stopped \
  linuxserver/nginx
  
# 容器 linuxserver/mariadb  数据库程序安装

docker run -d \
  --name=mysql \
  -e PUID=1000 \
  -e PGID=1000 \
  -e MYSQL_ROOT_PASSWORD=密码  \
  -e TZ=Europe/London \
  -e MYSQL_DATABASE=wordpress    \
  -e MYSQL_USER=wordpress     \
  -e MYSQL_PASSWORD=密码  \
  -p 3306:3306 \
  -v /mnt/wordpress:/config \
  --restart unless-stopped \
  linuxserver/mariadb

```

### WordPress 博客程序 配置 
- http://wp.262235.xyz/wp-admin/setup-config.php
- 
```
数据库连接 配置

数据库名	wordpress
用户名	wordpress
密码	密码
数据库主机	localhost ( mysql容器IP 172.17.0.4 或者网关 172.17.0.1  )
            有些模版 填 容器名称 mysql 也可以

```

------
## Docker 安装PT下载神器 QB 和 TR
```
# 脚本安装
wget git.io/wgmtu

# 安装Docker软件
bash wgmtu docker

# 安装qbittorrent软件
bash wgmtu qb

# 安装transmission软件(目前非docker安装)
# docker 安装参考下面命令
bash wgmtu tr
```

### 安装Docker软件
curl -fsSLo- get.docker.com | /bin/sh

### 测试运行
docker run hello-world

### 创建容器: qbittorrent
```bash
docker run --name=qbittorrent \
-e PUID=1000 -e PGID=1000 \
-e TZ=Asia/ShangHai \
-e UMASK_SET=022 -e \
WEBUI_PORT=8080 \
-p 59902:59902 \
-p 59902:59902/udp \
-p 8080:8080 \
-v /mnt/config:/config \
-v /mnt/downloads:/downloads \
--restart unless-stopped \
-d linuxserver/qbittorrent
```

### 创建容器: transmission
```bash 
docker run --name=transmission \
-e PUID=1000 -e PGID=1000 \
-e TZ=Asia/ShangHai \
-e TRANSMISSION_WEB_HOME=/transmission-web-control/  \
-e USER=admin   -e PASS=password@2021 \
-p 9091:9091 \
-p 51413:51413 \
-p 51413:51413/udp \
-v /mnt/config:/config \
-v /mnt/downloads:/downloads \
-v /mnt/watch:/watch \
--restart unless-stopped \
-d linuxserver/transmission
```

### 登陆
- 用默认用户名密码(admin/adminadmin)登录,端口8080,配置Peer端口(用于传入链接的端口)59902,配置完基本的东西之后重启QB.
  docker restart qbittorrent


