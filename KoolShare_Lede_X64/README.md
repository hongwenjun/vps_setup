## koolshare Lede X64 折腾笔记
- 系统只支持X64，个人D2550小机器CPU支持64位(OpenWRT Debian Win7LE版)，但是主板锁定X86，没法引导，折腾了好几天

### 下载 koolshare Lede X64 Nuc 镜像
- 百度 kool 点击链接 首页- KoolShare - 源于玩家 服务玩家
- 选固件下载--> LEDE_X64_fw867

###  1.虚拟机使用的固件镜像
http://firmware.koolshare.cn/LEDE_X64_fw867/

openwrt-koolshare-mod-v2.30-r10402-51ad900e2c-x86-64-uefi-gpt-squashfs.vmdk

###  2.安装到U盘使用  选择目录  
http://firmware.koolshare.cn/LEDE_X64_fw867/虚拟机转盘或PE下写盘专用/

openwrt-koolshare-mod-v2.30-r10402-51ad900e2c-x86-64-combined-squashfs.img.gz


###  3.写U盘或者PE写盘工具  physdiskwrite.exe 下载
- 华军下载  搜索  physdiskwrite
- http://www.onlinedown.net/soft/93900.htm

```
# PE写盘使用
把lede固件和 physdiskwrite.exe 文件拷贝到pe U盘，用pe启动，执行dos窗口,找到文件存放的路径
输入 physdiskwrite.exe -u ledeXXXXXX.img
-u 参数能够写大U盘和硬盘

# 固件写U盘，插入另外一个U盘，可以使用PE中的硬盘分区工具，把U盘删除所有的分区
命令同PE写盘
```

### 4. 下载 Oracle VM VirtualBox虚拟机，并且安装
https://download.virtualbox.org/virtualbox/6.0.4/VirtualBox-6.0.4-128413-Win.exe

### 单网卡 独臂路由和透明网桥设置 koolshare Lede X64 虚拟机配置视频
https://youtu.be/7cKFdz_7rtE

![](https://raw.githubusercontent.com/hongwenjun/img/master/lede.png)

```c
1
00:00:00,000 --> 00:00:10,000
单网卡 koolshare Lede X64 
虚拟机: 独臂路由和透明网桥设置

2
00:00:10,170 --> 00:00:15,170
https://github.com/hongwenjun/vps_setup/tree/master/KoolShare_Lede_X64

3
00:00:15,330 --> 00:00:20,330
下载 koolshare Lede X64 Nuc 镜像
选vmdk的虚拟机磁盘镜像格式

4
00:00:22,500 --> 00:00:27,500
另存一个简单的名字

5
00:00:38,500 --> 00:00:43,500
运行Oracle VM VirtualBox
新建一个Linux X64 虚拟机

6
00:00:58,500 --> 00:01:03,500
指定刚才下载的 koolshare Lede X64 磁盘镜像 vmdk 格式

7
00:01:16,670 --> 00:01:21,670
设置虚拟机的网络和网卡
网络->网卡1->连接方式选->桥接网卡

8
00:01:25,670 --> 00:01:30,670
启动虚拟路由器主机

9
00:01:43,000 --> 00:01:48,000
输入命令  passwd
先把 root 的密码改成你自己的

10
00:02:03,000 --> 00:02:08,000
cd /etc/config  进入配置目录
vim  network   修改路由器网络配置

11
00:02:08,330 --> 00:02:13,330
修改wan口的硬件为eth0，因为只有一个网卡

12
00:02:18,170 --> 00:02:23,170
修改lan口的IP地址为192.168.11.254  
(按实际网络，不要占用实际网关末尾数 1 )

13
00:02:25,000 --> 00:02:30,000
Esc键 :wq 保存，再 reboot 重启路由器

14
00:02:40,000 --> 00:02:45,000
浏览器 输入IP  192.168.11.254  登陆路由器管理界面
(按实际输入)

15
00:03:02,170 --> 00:03:07,170
选网络-->接口，编辑 lan 口，取消掉 物理设置中 的桥接接口

16
00:03:15,330 --> 00:03:20,330
这时就可以看到 lan 和 wan 口都是绑定 eth0，都会分配 IPv4地址和数据包流量

17
00:03:23,670 --> 00:03:28,670
PS:  原装OpenWRT系统默认是没有WAN口的，需要自己添加一个wan接口
然后编辑绑定到 eth0, 可以在浏览器里 编辑方便点，也要编辑 lan 口，取消桥接接口

18
00:03:31,670 --> 00:03:36,670
单网卡的，独臂路由已经设置成功了，下面进入酷软 安全其他设置

19
00:03:44,170 --> 00:03:49,170
安装透明网桥，帮wan口和lan合并掉一个桥接网口

20
00:04:04,500 --> 00:04:09,500
网关IP是真实物理网关IP  192.168.11.1
网桥IP是虚拟路由的IP      192.168.11.254

21
00:04:17,330 --> 00:04:22,330
可以看到，现在只有一个 BRIDGE 接口了，如果改错地址连不上路由
vim /etc/config/network   可以改成正确的IP

22
00:04:31,000 --> 00:04:36,000
添加SS，就按实际设置。
设置正确后，你需要翻墙的电脑，可以把把网关地址设置成192.168.11.254
就能科学上网了

23
00:04:56,000 --> 00:04:57,500
你也可以把固件写到U盘里面，放到一台电脑上，使用U盘启动,也可以折腾学习


```
