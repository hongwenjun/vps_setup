## 一键安装 WireGuard  Shadowsocks V2Ray 服务端三合一脚本
    bash <(curl -L -s https://git.io/vps.sh)
    wget -qO- git.io/vps.sh | bash       # wget调用是静默安装  curl调用可以使用菜单

| [一键安装 WireGuard 脚本](https://github.com/hongwenjun/vps_setup/blob/master/Wireguard/README.md) |[一键安装 Shadowsocks 脚本](https://github.com/hongwenjun/vps_setup/blob/master/shadowsocks/README.md) | [V2Ray 官方一键脚本](https://github.com/hongwenjun/vps_setup/blob/master/v2ray/README.md) |
| :------:| :------: | :------: |
| wget -qO- git.io/fptwc \| bash | bash <(curl -L -s git.io/fhExJ) update | bash <(curl -L -s https://install.direct/go.sh) |

![](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/vps.sh.png)

| WireGuard 管理 | bash wgmtu | 卸载命令 | bash wgmtu remove | 
| :------:| :------: | :------:| :------: |

|V2Ray 卸载命令 | bash <(curl -L -s https://install.direct/go.sh) --remove |
| :------:| :------: |


### 严重声明和友情提示：
- 此项目仅限于技术交流和探讨，在您测试完毕后必须在1秒钟内彻底删除项目副本。此项目为bash一键脚本，其中涉及到的任何软件版权和责任归原作者所有。
- 在中国境内使用、传播、售卖、免费分享等任何翻墙服务，都是违法的。如果你在中国境内使用、测试此项目脚本，或者使用此脚本搭建服务器发生以上违法行为，都有违作者意愿！你必须立刻停止此行为！并删除脚本！

### V2Ray和Shadowsocks配置显示二维码  短网址: https://git.io/v2ray.ss
![](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/v2ray/v2ray.ss.png)

### WireGuard 管理使用命令 bash wgmtu 
[![点击图片链接视频演示](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/wgmtu.png)](https://youtu.be/iOnAeWRvSQI)

### Shadowsocks 配置使用: 添加命令行到 /etc/rc.local
```
# -p 端口 -k 密码 -m 协议 -s 服务IP
ss-server -s 0.0.0.0 -p 40000 -k ${PASSWORD} -m aes-256-gcm -t 300 >> /var/log/ss-server.log &
```

### V2ray 显示官方服务端配置
```
cat /etc/v2ray/config.json
```
---

### 一键安装wireguard 参考演示视频集合

| [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/ss_wgmtu.jpg)](https://youtu.be/-sJLfPg12oc) | [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/wg_mac_pc_tel.jpg)](https://youtu.be/dkXWicxak3w) | [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/wgmtu.jpg)](https://youtu.be/e86tCRDqu8c) |
| :------| ------: | :------: |
| [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/iptables_ytb.jpg)](https://youtu.be/Jb3b8SbFQLM) | [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/winkcp_ytb.jpg)](https://youtu.be/HjGO2sAPOFM) | [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/gcp_ssh_key.jpg)](https://youtu.be/qhwK5XUJeWE)|
| [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/wg5clients.jpg)](https://youtu.be/TOaihmhrYQY) | [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/tel_pc.jpg)](https://youtu.be/O__RsZewA60) | [![ScreenShot](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/ss_wg.jpg)](https://youtu.be/-cfuQSaJb5w)|


### Telegram 代理 MTProxy Go版 一键脚本(源:逗比网)
```
# Telegram 代理 MTProxy Go版 一键脚本(源:逗比网)
wget -qO mtproxy_go.sh  git.io/fpWo4 && bash mtproxy_go.sh
```

### 使用BestTrace查看VPS的去程和回程
```
wget -qO- https://raw.githubusercontent.com/hongwenjun/vps_setup/master/autoBestTrace.sh | bash
```

### Google Cloud Platform  GCP实例开启密码与root用户登陆
```
#  GCP一键启用root帐号命令
#  wget -qO- git.io/fpQWf | bash
```

### 使用 vnstat 检测VPS流量使用
```
# 一键安装 vnstat 流量检测
wget -qO- git.io/fxxlb | bash
```
### linux下golang环境搭建自动脚本
```
# linux下golang环境搭建自动脚本  by 蘭雅sRGB
wget -qO- https://git.io/fp4jf | bash
```
----


### Debian或Ubuntun mini版 wget下载证书无法验证
	apt-get install -y ca-certificates

### Debian远程SSH汉字utf-8乱码解决
	apt-get  install locales
	dpkg-reconfigure locales

### 查看默认字符集是否是en_US.UTF-8
	vim /etc/default/locale
	LANG=en_US.UTF-8

### vim和bash高亮,tmux 配置
```
wget -O .vimrc --no-check-certificate https://raw.githubusercontent.com/hongwenjun/srgb/master/vim/_vimrc
wget -O .bashrc --no-check-certificate https://raw.githubusercontent.com/hongwenjun/srgb/master/vim/_bashrc
wget -O .tmux.conf --no-check-certificate https://raw.githubusercontent.com/hongwenjun/tmux_for_windows/master/.tmux.conf
```
### 修改默认主页地址 和 目录索引显示
```
$ vim /etc/nginx/sites-enabled/default
root /var/www;
autoindex on;
```

### udp2raw_kcptun_ss_for_debian9.sh  一键安装，默认$$只对本地开放
```
wget --no-check-certificate -O vps_setup.sh https://git.io/fx6UQ  && \
chmod +x vps_setup.sh && ./vps_setup.sh
```

### 获取自己所需服务软件的信息
```
ps aux
ps aux | grep -e shadowsocks -e brook -e ss-server -e kcp-server -e udp2raw -e speederv2 -e python
ls /sys/class/net | awk {print} | head -n 1
```
可以得到软件的安装目录和配置文件目录

```
/usr/bin/shadowsocks-server -c /etc/shadowsocks-go/config.json
/usr/local/frps/frps -c /usr/local/frps/frps.ini
/bin/bash /etc/init.d/brook start
./brook servers -l :2333 srgb.xyz
screen ./fuck_net
screen iperf3 -s
```
### 打包程序和配置
```
tar -czvf  ss_frp.tar.gz  /etc/init.d/brook  /usr/local/brook/brook  /usr/local/brook/brook.conf   \
    /usr/bin/shadowsocks-server   /etc/shadowsocks-go/config.json   /etc/init.d/shadowsocks-go  \
    /usr/local/frps/frps   /usr/local/frps/frps.ini  /etc/init.d/frps  /root/fuck_net
```
- 或者使用文件表打包
```
tar -czv -T filelist -f ss_frp.tar.gz
-T 选项可以指定包含要备份的文件列表
```

## 搬迁备份文件，使用wget
- 可以先不删除原来机器，新建立机器使用wget把备份文件挪过去
- 本笔记，由于使用Vultr_IPV6的机器，所以使用wget先下载到本地电脑了

### 本地上传到服务器/tmp
	$ scp /c/Users/vip/Desktop/ss_frp/ss_frp.tar.gz root@[2001:19f0:8001:c85:5400:01ff:fe91:7ed8]:/tmp/ss_frp.tar.gz
### 服务器上解压和开启服务

```
cd / && tar -xvf /tmp/ss_frp.tar.gz
/etc/init.d/frps  start && /etc/init.d/brook start && /etc/init.d/shadowsocks-go start
```

### 注册服务，禁止服务
```
systemctl enable frps
systemctl enable brook
systemctl enable shadowsocks-go

systemctl disable frps #禁止的脚本
```

### https://git.io  自定义短域名链接
```
curl -i https://git.io -F "url=https://raw.githubusercontent.com/hongwenjun/vps_setup/master/vps.sh"  -F "code=vps.sh"

####   返回信息
HTTP/1.1 201 Created
Server: Cowboy
Connection: keep-alive
Date: Fri, 08 Mar 2019 04:47:37 GMT
Status: 201 Created
Content-Type: text/html;charset=utf-8
Location: https://git.io/vps.sh
Content-Length: 68
X-Xss-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-Runtime: 0.193189
X-Node: 4c602b07-61d9-41e0-bee8-654fbdc36e98
X-Revision: 392798d237fc1aa5cd55cada10d2945773e741a8
Strict-Transport-Security: max-age=31536000; includeSubDomains
Via: 1.1 vegur

https://raw.githubusercontent.com/hongwenjun/vps_setup/master/vps.sh

```

### Git pull 强制覆盖本地文件
```
git fetch --all
git reset --hard origin/master 
git pull
git fetch origin master
git merge origin/master
git merge origin/master --allow-unrelated-histories
git diff
```
