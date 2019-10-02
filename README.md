- :smile: [简体中文](https://github.com/hongwenjun/vps_setup/blob/master/README.md) 　:cry: [English](https://git.io/vps.english)

## :bell: 我們雖然窮，但是不能說謊，也不能打人；不是我們的東西，我們不能拿；
## :100: 要好好讀書，長大要做個對社會有用的人。

- 欢迎加入编程语言群 Telegram 电报群：https://t.me/codeblobks

----

- :gift: 项目: https://git.io/vps.us 　　 https://git.io/winkcp 　　 https://git.io/vps.english
- [蘭雅sRGB![](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/youtube.png)频道](https://www.youtube.com/channel/UCupRwki_4n87nrwP0GIBUXA/videos) &nbsp;&nbsp;&nbsp;可以观看相关脚本工具的演示视频!
- :bomb: 脚本: https://git.io/vps.sh 　　 https://git.io/wgmtu 　　 https://git.io/v2ray.ss
- :anger: 防火墙脚本: https://git.io/fhUSe 　　 路由器脚本: https://git.io/sskcp.sh
- English Script: https://git.io/vps.setup 　　 https://git.io/wireguard.sh 　　 https://git.io/v2ray_ss.sh


---
### :heart_eyes:Linux 简单命令工具和简易脚本
<details>
<summary>点击展开内容</summary>
  
#### 一些表情例子 EMOJI
- :smile: :laughing: :dizzy_face: :sob: :cold_sweat: :sweat_smile:  :cry: :triumph: :heart_eyes: :relieved:
- :+1: :-1: :100: :clap: :bell: :gift: :question: :bomb: :heart: :coffee: :cyclone: :bow: :kiss: :pray: :anger:

```c
:smile: :laughing: :dizzy_face: :sob: :cold_sweat: :sweat_smile:  :cry: :triumph: :heart_eyes: :relieved:
:+1: :-1: :100: :clap: :bell: :gift: :question: :bomb: :heart: :coffee: :cyclone: :bow: :kiss: :pray: :anger:
```
  
### 安装工具 tmux 和 fish 等

```
apt install tmux fish  -y
```

### 在Android手机上安装Termux应用，测试学习10个秘密和酷命令!

```
1) apt install sl
     sl
2) factor "Any Number" 
3) apt install fish
     fish
4) apt install figlet
     figlet "Any Text" 
5) apt install cmatrix
     cmatrix
6) apt install fortune
     fortune 
7) apt install toilet
     toilet "Any Text" 
     toilet -f mono12 -F gay "Any Text" 
8) apt install w3m
     w3m "any websites" 
     example:- w3m google.com
9) ifconfig
10) apt install cowsay
      cowsay "Any Text"
```

### [acme协议从letsencrypt生成免费的证书](http://srgb.vicp.net/2018/11/05/acme_sh/) 

```
#!/usr/bin/env sh

# https://github.com/Neilpang/acme.sh/wiki/说明

# 安装ssl依赖 和 acme.sh工具
apt-get install socat netcat -y
curl  https://get.acme.sh | sh

# 设置域名
DOMAIN=ssl.srgb888.ga

# 生成域名ssl证书
~/.acme.sh/acme.sh  --issue -d ${DOMAIN}  --webroot  /var/www/html --standalone -k ec-256 --force

```

### 如果你用的nginx服务器，以后可以使用一行命令更新证书
```
~/.acme.sh/acme.sh  --issue -d ssl.srgb888.ga  --nginx  --standalone -k ec-256 --force
```

</details>


### 网友视频和白话文档

- 白话文档: [OpenWRT配置](https://git.io/wrt.wg) 　 [Nginx反代V2ray原理](https://git.io/v2ray.nginx)
- 网友视频: [三剑客](https://youtu.be/BHZhU8wxf9A) 　 [PC_MAC_手机客户端](https://youtu.be/dkXWicxak3w)

---

