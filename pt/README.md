![QB.png][1]

### 1)  请先看大神博客  自动PT工具参数调优

https://www.taterli.com/7785/

### 1.1) 准备接下来写 一键脚本 autopt.sh 方便配置管理 goseeder.conf 
- 如果参数很容易搞错，浪费了半天，重新制作容器才成功
- 把工具制作成Docker容器，原则上群晖NAS也可以方便使用


### 2) 运行 goseeder 自动PT

    docker run -d  --name  autopt  \
       -v  /root/goseeder.conf:/goseeder.conf  \
       hongwenjun/autopt


### 3) 查看QB服务器设置是否正常

    docker  exec  -it autopt  gostat

### 4) 检查RSS推送信息是否正确

    docker logs  autopt | grep -e 种子 -e 磁盘

### 5) 安装Docker可视化界面Portainer

    docker run --name Portainer          \
      --restart=always  -d -p 9000:9000  \
      -v /var/run/docker.sock:/var/run/docker.sock  \
      -v /opt/portainer_data:/data        \
      portainer/portainer

![123.png][2]
  
### 6) 使用Portainer 查看和修改比较方便

- 编辑  /root/goseeder.conf  后使用网页管理重启，或者命令

    docker restart autopt


  [1]: https://262235.xyz/usr/uploads/2021/05/3140493615.png
  [2]: https://262235.xyz/usr/uploads/2021/05/354698449.png
