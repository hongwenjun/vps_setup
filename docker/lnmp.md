
### LNMP一键安装包无人值守命令生成器

- https://lnmp.org/auto.html


```
wget http://soft.vpser.net/lnmp/lnmp1.7.tar.gz -cO lnmp1.7.tar.gz && \
tar zxf lnmp1.7.tar.gz && cd lnmp1.7 && LNMP_Auto="y" DBSelect="3" DB_Root_Password="lnmp.org" \
InstallInnodb="y" PHPSelect="5" SelectMalloc="1" ./install.sh lnmp
```

----

### LNMP 管理命令

```
lnmp
```



## Docker LAMP 镜像部署
```
#  PHP源代码下载
cd /opt
git clone https://github.com/hongwenjun/bxwlyz.git  www

共执行37条sql语句
写入安装锁文件失败
解决方法
chown -R www-data:www-data /opt/www


# 安装Docker软件一键脚本

curl -fsSLo- get.docker.com | /bin/sh


# Docker 拉取最新版的 LAMP 镜像

docker pull icoty1/lamp:v1.1.0


# 高级用法(Advanced usage)

docker run -dit --name=webapi \
-p 80:80  -p 3306:3306        \
-v /opt/www:/var/www/html     \
--cpus 0.8   --restart=always \
-v /opt/mysql:/data/mysql     \
icoty1/lamp:v1.1.0  /bin/bash start.sh



# 连接(Connect)  默认密码 root  root 

docker exec -it  webapi /bin/bash

mysql -u root -p

#修改当前登录用户密码

SET PASSWORD =PASSWORD("WebApi@2021");
 
# 建立数据库 webapi

create database webapi;


```

=====

###  lnmp 安装 wordpress 笔记
- 这个lnmp没有安装成功，另一个lnmp可以完成
```

chown -R www-data:www-data /opt/www

https://hub.docker.com/r/2233466866/lnmp

docker run -dit \
-p 80:80 \
-p 443:443 \
-p 3306:3306 \
-p 9000:9000 \
-v /opt/www/wordpress:/www \
-v /opt/mysql:/data/mysql \
--privileged=true \
-e PUID=1000 -e PGID=1000 \
--name=lnmp \
2233466866/lnmp


# 连接(Connect) 容器名称

docker exec -it lnmp /bin/bash

# 初始密码(Default password)

cat /var/log/mysqld.log|grep 'A temporary password'

A temporary password is generated for root@localhost: 9R3dGy,uEWf-


mysql -u root -p  密码

# 修改当前登录用户密码

SET PASSWORD =PASSWORD("WebApi@2021");

# 建立数据库 wordpress

create database wordpress;

chown -R www-data:www-data   www


```

