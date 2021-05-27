![QB.png](https://262235.xyz/usr/uploads/2021/05/3140493615.png)

### 1)  请先看大神博客  自动PT工具参数调优

https://www.taterli.com/7785/

### 1.1) 自动PT autopt.sh 一键脚本  方便配置测试 goseeder.conf
- 短网址: https://git.io/autopt.sh
- 把工具制作成Docker容器，测试支持群晖NAS，可以使用

```
wget git.io/autopt.sh && bash autopt.sh

# 群晖NAS使用如果不能访问外网 使用命令
wget 262235.xyz/autopt.sh && bash autopt.sh
```
![autopt.png][1]

![conf.png](https://262235.xyz/usr/uploads/2021/05/3539043976.png)

###  复制示例到Json工具网站编辑，保存上传 /root/goseeder.conf

```
{
"dbserver": "mongodb+srv://pt:passwd@cluster0.XXXX.mongodb.net/myFirstDatabase?retryWrites=true&w=majority",

"node": [

{
"source": "pt.msg.vg",
"passkey": "123456789-PASSKEY-PASSKEY-ABCDEF",
"limit": 10,
"enable": true,
"rule": {
    "seeder_time": 0,
    "seeder_ratio": 0,
    "speed_limit": 8.0
}
}


],


"server": [

{
"endpoint": "http://192.168.1.222:8080",
"username": "admin",
"password": "adminadmin",
"remark": "DISKSTATION",
"enable": true,
"rule": {
"concurrent_download": 1,
"disk_threshold": 10.0,
"disk_overcommit": false,
"max_speed": 30.00,
"min_alivetime": 3600,
"max_alivetime": 86400,
"min_tasksize": 0.0,
"max_tasksize": 50.0,
"max_disklatency": 10000
}
}

]
}

```

### 2) 运行 goseeder 自动PT

    docker run -d  --name  autopt  \
       -v  /root/goseeder.conf:/goseeder.conf  \
       hongwenjun/autopt


### 3) 查看QB服务器设置是否正常

    docker  exec  -it autopt  gostat

![](https://262235.xyz/usr/uploads/2021/05/962808404.png)

### 4) 检查RSS推送信息是否正确

    docker logs  autopt | grep -e 种子 -e 磁盘

### 5) 安装Docker可视化界面Portainer

    docker run --name Portainer          \
      --restart=always  -d -p 9000:9000  \
      -v /var/run/docker.sock:/var/run/docker.sock  \
      -v /opt/portainer_data:/data        \
      portainer/portainer

![123.png](https://262235.xyz/usr/uploads/2021/05/354698449.png)

### 6) 使用Portainer 查看和修改比较方便

- 编辑  /root/goseeder.conf  后使用网页管理重启，或者命令

    docker restart autopt

  [1]: https://262235.xyz/usr/uploads/2021/05/2184208616.png
  [2]: https://262235.xyz/usr/uploads/2021/05/3539043976.png
  [3]: https://262235.xyz/usr/uploads/2021/05/354698449.png
  [4]: https://262235.xyz/usr/uploads/2021/05/3539043976.png
  [5]: https://262235.xyz/usr/uploads/2021/05/962808404.png
