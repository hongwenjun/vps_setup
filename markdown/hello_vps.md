## Hello VPS 常用工具安装
```
#!/bin/bash

# 常用工具和配置
apt update
apt install -y curl wget vim htop tmux screen iperf3
wget -O .vimrc      --no-check-certificate https://raw.githubusercontent.com/hongwenjun/srgb/master/vim/_vimrc
wget -O .bashrc     --no-check-certificate https://raw.githubusercontent.com/hongwenjun/srgb/master/vim/_bashrc
wget -O .tmux.conf  --no-check-certificate https://raw.githubusercontent.com/hongwenjun/tmux_for_windows/master/.tmux.conf

```

### Debian远程SSH汉字utf-8乱码解决
	aptitude install locales
	dpkg-reconfigure locales

### 极光KVM 精简软件
```
systemctl stop rpcbind.service
systemctl disable rpcbind.service
apt purge exim4 exim4-base exim4-config exim4-daemon-light atop fail2ban

```

### 修改 SSH 为证书登陆 vim /etc/ssh/sshd_config
```
PasswordAuthentication no
ChallengeResponseAuthentication no
X11Forwarding no
PubkeyAuthentication yes
Protocol 2 #只能SSH2访问,这个安全性高
Port 12345 #自己设置一个别人不知道的
```



### 阿里云 删除云盾监控
```
# 删除云盾监控
wget http://update.aegis.aliyun.com/download/uninstall.sh && chmod +x uninstall.sh && ./uninstall.sh
wget http://update.aegis.aliyun.com/download/quartz_uninstall.sh && chmod +x quartz_uninstall.sh && ./quartz_uninstall.sh

# 删除残留
pkill aliyun-service && rm -fr /etc/init.d/agentwatch /usr/sbin/aliyun-service && rm -rf /usr/local/aegis*

# 屏蔽云盾
iptables -I INPUT -s 140.205.201.0/28 -j DROP
iptables -I INPUT -s 140.205.201.16/29 -j DROP
iptables -I INPUT -s 140.205.201.32/28 -j DROP
iptables -I INPUT -s 140.205.225.192/29 -j DROP
iptables -I INPUT -s 140.205.225.200/30 -j DROP
iptables -I INPUT -s 140.205.225.184/29 -j DROP
iptables -I INPUT -s 140.205.225.183/32 -j DROP
iptables -I INPUT -s 140.205.225.206/32 -j DROP
iptables -I INPUT -s 140.205.225.205/32 -j DROP
iptables -I INPUT -s 140.205.225.195/32 -j DROP
iptables -I INPUT -s 140.205.225.204/32 -j DROP


```