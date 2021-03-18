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
