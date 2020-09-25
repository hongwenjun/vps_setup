# Oracle VM VirtualBox  安装虚拟机 Debian 10  挖坑填坑笔记

###  VirtualBox 安装虚拟机 Debian 系统 省略
- 下载 **mini.iso** 网络安装，或者 **debian-10.5.0-amd64-xfce-CD-1.iso** 图形GUI安装

- 注意: 选择中文语言，使用中国大陆镜像，推荐中科大软件源，如果选择默认的官方站速度会很慢；即使选对中科大镜像源在安装过程中
还是会从官方下载证书文件卡住，可以ctrl+alt+f4 切换到后台，ctrl+c停止从官方源下载资源包，不影响系统安装。安装软件选择SSH
方便远程登陆，不要选择xfce或者KDE图形桌面，安装完成后，按下面修改 软件源

-  **sources.list**  修改 apt 中科大软件源 配置
```
# vim /etc/apt/sources.list

deb http://mirrors.ustc.edu.cn/debian/ buster main
deb-src http://mirrors.ustc.edu.cn/debian/ buster main

deb http://mirrors.ustc.edu.cn/debian-security buster/updates main
deb-src http://mirrors.ustc.edu.cn/debian-security buster/updates main

deb http://mirrors.ustc.edu.cn/debian/ buster-updates main
deb-src http://mirrors.ustc.edu.cn/debian/ buster-updates main
```

### 设置时区为北京时间

	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

## dd 命令是备份Linux系统，或者是linux系统杀手
- 所以建立虚拟vmdk磁盘只分配了2G，方便DD，或者写U盘镜像 
```
#  dd指令 语法格式
dd  [option] if=file：输入文件名，缺省为标准输入  of=file：输出文件名，缺省为标准输出

测试纯写入性能
dd if=/dev/zero of=test bs=8k count=10000 oflag=direct
测试纯读取性能
dd if=test of=/dev/null bs=8k count=10000 iflag=direct

root@debian:~$ fdisk -l

Disk /dev/sda: 2 GiB, 2147483648 bytes, 4194304 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x4ea1acbd

Device     Boot Start     End Sectors Size Id Type
/dev/sda1  *     2048 4192255 4190208   2G 83 Linux


Disk /dev/sdb: 4 GiB, 4294967296 bytes, 8388608 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

root@debian:~$ dd if=/dev/sda  of=/dev/sdb
记录了4194304+0 的读入
记录了4194304+0 的写出
2147483648 bytes (2.1 GB, 2.0 GiB) copied, 91.3932 s, 23.5 MB/s


root@debian:~$ mkfs.ext4 /dev/sdb1

mke2fs 1.44.5 (15-Dec-2018)
/dev/sdb1 contains a ext4 file system
        last mounted on / on Tue Sep 15 20:33:12 2020
Proceed anyway? (y,N) y
Creating filesystem with 523776 4k blocks and 131072 inodes
Filesystem UUID: ebe2ce7e-1543-43a7-8df9-0e7596448227
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done


mkdir /root/d
mount /dev/sdb1 /root/d

root@debian:~$ df -h
文件系统        容量  已用  可用 已用% 挂载点
udev            102M     0  102M    0% /dev
tmpfs            24M  3.0M   21M   13% /run
/dev/sda1       2.0G  1.3G  621M   67% /
tmpfs           116M     0  116M    0% /dev/shm
tmpfs           5.0M     0  5.0M    0% /run/lock
tmpfs           116M     0  116M    0% /sys/fs/cgroup
tmpfs            24M     0   24M    0% /run/user/0
/dev/sdb1       2.0G  6.0M  1.9G    1% /root/d

root@debian:~$ dd  if=/dev/sda | gzip > /root/d/image.gz
记录了4194304+0 的读入
记录了4194304+0 的写出
2147483648 bytes (2.1 GB, 2.0 GiB) copied, 102.968 s, 20.9 MB/s

```
## VirtualBox 中如何使用U盘
```
以 管理员身份 打开命令提示符 CMD 查看一下U盘的 DeviceID【磁盘标识盘】：

wmic diskdrive list brief

使用 VBoxManage 命令生成vmdk文件 usb.vmdk

cd "C:\Program Files\Oracle\VirtualBox"

VBoxManage.exe internalcommands createrawvmdk -filename "C:\VPC\usb.vmdk" -rawdisk \\.\PhysicalDrive3

RAW host disk access VMDK file C:\VPC\usb.vmdk created successfully.

===   usb.vmdk  文件内容 ===

# Disk DescriptorFile
version=1
CID=db9f2dfb
parentCID=ffffffff
createType="fullDevice"

# Extent description
RW 8036352 FLAT "\\.\PhysicalDrive3" 0

# The disk Data Base 
#DDB

ddb.virtualHWVersion = "4"
ddb.adapterType="ide"
ddb.geometry.cylinders="7972"
ddb.geometry.heads="16"
ddb.geometry.sectors="63"
ddb.uuid.image="8dcce260-7a5f-462c-878f-01786958e77f"
ddb.uuid.parent="00000000-0000-0000-0000-000000000000"
ddb.uuid.modification="00000000-0000-0000-0000-000000000000"
ddb.uuid.parentmodification="00000000-0000-0000-0000-000000000000"

```

## 使用 VBoxManage 将vmdk文件转换成IMG文件
- 语法: **VBoxManage clonehd**  源文件.vmdk  目标文件.img  --format RAW
```
VBoxManage clonehd  debian-disk001.vmdk   debian10.img --format RAW

0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Clone medium created in format 'RAW'. UUID: 76294339-5652-45d9-97e0-eab5688aa2aa
```

## Debian 10 默认安装了N多  realtek  intel 等主要硬件厂商网卡
```
ls /lib/modules/4.19.0-10-amd64/kernel/drivers/net/ethernet

3com     alteon    atheros   chelsio  emulex     huawei   mellanox   natsemi    packetengines  sfc    sun     xircom
8390     amazon    broadcom  cisco    fealnx.ko  intel    micrel     neterion   qlogic         silan  tehuti
adaptec  amd       brocade   dec      fujitsu    jme.ko   microchip  netronome  rdc            sis    ti
agere    aquantia  cavium    dlink    hp         marvell  myricom    nvidia     realtek        smsc   via

lspci | grep Ethernet

00:03.0 Ethernet controller: Intel Corporation 82540EM Gigabit Ethernet Controller (rev 02)

lsmod
e1000                 155648  0

```
## Debian 10 迁移系统网卡不能自动获取IP修改方法
```
ip addr

2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:d3:49:8d brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.111/24 brd 192.168.1.255 scope global dynamic enp0s3

cat /etc/network/interfaces

# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp0s3
iface enp0s3 inet dhcp

###  --------修改成固定IP------------- ####
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp0s3
iface enp0s3 inet static
  address 192.168.1.111
  netmask 255.255.255.0
  gateway 192.168.1.1
  dns-nameserver 8.8.8.8

vim /etc/network/interfaces
### 修改interfaces中的网卡名字enp0s3同 ip addr获得的网卡名字相同

systemctl restart networking.service

# debian系统下重启停止网卡命令
ifdown enp0s3
ifup enp0s3
```
![](https://raw.githubusercontent.com/hongwenjun/img/master/debian/autonet.png)

##  autonet.sh  自动修改interfaces 网卡自动加载
```
lspci | grep Ethernet
ni=$(ip addr | grep enp | head -n 1 | awk -F ': '  '{print $2}')
sed -i "s/enp[a-zA-Z0-9]*/${ni}/g"  /etc/network/interfaces
ifup $ni
```

## debian使用 parted 工具 调整磁盘分区
```
apt install parted

root@debian:~$ partx /dev/sda
NR START     END SECTORS SIZE NAME UUID
 1  2048 4192255 4190208   2G      4ea1acbd-01

root@debian:~$ parted

(parted) help
	print     显示分区表，可用设备，可用空间，所有找到的分区或特定分区
	quit                     退出程序

	resizepart NUMBER END    调整分区号
	rm NUMBER                删除分区

其他详细命令
https://www.howtoing.com/parted-command-to-create-resize-rescue-linux-disk-partitions/

```
## Vbox增加虚拟磁盘大小方法
- **VBoxManage** 只支持VDI格式，不支持vmdk格式，所以要先转换磁盘格式VDI，在扩容
```
VBoxManage clonehd  debian.vmdk  debian.vdi  --format VDI

VBoxManage modifyhd  debian.vdi  -resize 8192
```
- 使用 **parted** 工具 调整磁盘系统分区后，**df -h** 空间没有增大，需要 **resize2fs* /dev/sda1  调整文件系统大小
```
root@debian:~$ parted /dev/sda

(parted) print free

Number  Start   End     Size    Type     File system  Flags
        32.3kB  1049kB  1016kB           Free Space
 1      1049kB  8590MB  8589MB  primary  ext4         boot


root@debian:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       2.0G  1.4G  486M  74% /

root@debian:~$ resize2fs /dev/sda1
resize2fs 1.44.5 (15-Dec-2018)
Filesystem at /dev/sda1 is mounted on /; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 1
The filesystem on /dev/sda1 is now 2096896 (4k) blocks long.

root@debian:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       7.9G  1.4G  6.2G  19% /

```

## debian 使用 ntfs-3g 挂载读取Windows NTFS系统文件
```
  apt search ntfs-3g     # 搜索工具在哪个安装包
  apt install  ntfs-3g

	使用语法：mount  -t  ntfs-3g  分区设备文件名    挂载点
	
	查找分区的设备文件名：fdisk -l
	
	执行挂载：mount  -t ntfs-3g /dev/sdb1  /mnt/usb
	
	访问数据：ls -l  /mnt/usb
	
	卸载：umount  /mnt/usb
  
  umount -a  全卸载挂载
```
## debian buster不能启动docker守护进程（dockerd）的解决办法
## iptables v1.8.2 (nf_tables): Chain already exists 解决办法

- 故障原因是Docker用iptables初始化NAT网络，而Debian buster使用 nftables 而不是 iptables，导致dockerd不能正常完成NAT初始化，出错退出。
- 处理方法是调用update-alternatives强制Debian用iptables而不是nftables。

```
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
# for ipv6
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
```

## Debian 语言设置
-   vim /etc/default/locale
```
# 英文显示
LANG=en_US.UTF-8

# 中文显示
LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:zh"
```

## DEBIAN LOCALE LANGUAGE SETTINGS & Modify Interfaces
```
#########   Debain config.sh  ###########
#!/bin/bash

en_US()
{
	cat <<EOF >/etc/default/locale
LANG=en_US.UTF-8
EOF
	echo -e "Please log in again on Debian tty1"
}

zh_CN()
{
	cat <<EOF >/etc/default/locale
# 中文显示
LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:zh"
EOF

	echo -e "Please log in again on Debian tty1"

}

autonet()
{
# 自动修改interfaces 网卡自动加载
lspci | grep Ethernet
ni=$(ip addr | grep enp | head -n 1 | awk -F ': '  '{print $2}')
sed -i "s/enp[a-zA-Z0-9]*/${ni}/g"  /etc/network/interfaces
ifup $ni

}

# 设置菜单
start_menu()
{
    echo -e ":: DEBIAN LOCALE LANGUAGE SETTINGS & Modify Interfaces"
    read -p ":: Please enter the number <1>:English  <2>:Chinese :: <8> AutoModify Interfaces  "  num_x
    case "$num_x" in
        1)
        en_US
        ;;
        2)
        zh_CN
        ;;
        8)
        autonet
        ;;
		esac
}
start_menu

#################################################
```

### 将VirtualBox里安装的虚拟机在后台运行方法
```
::  将VirtualBox里安装的虚拟机在后台运行方法（在状态栏隐藏窗口）

CD  "C:\Program Files\Oracle\VirtualBox\"
.\VBoxManage.exe  startvm  debian --type headless

```
---
```
::  将VirtualBox里安装的虚拟机在后台运行方法（在状态栏隐藏窗口）

CD  "C:\Program Files\Oracle\VirtualBox\"
.\VBoxManage.exe  startvm  debian --type headless


将VirtualBox里安装的虚拟机在后台运行方法（在状态栏隐藏窗口）
由于工作和学习需要，经常要开一个虚拟机开测试和开发，虚拟机选择Oracle公司的VirtualBox，经常开着这个窗口感觉有些浪费资源，这样隐藏窗口就在需求了。

将VirtualBox里安装的虚拟机在后台运行方法（在状态栏隐藏窗口）

开始=>运行=>cmd进入DOS窗口
d:
cd  D:\Program Files\VirtualBox
D:\Program Files\VirtualBox> .\VBoxManage.exe  startvm  master --type headless
这在Linux系统和MAC上同样适用，只要替换成相应的命令即可

 

解释：其中 master 是这个虚拟机的名称

Headless模式是系统的一种配置模式。在该模式下，系统缺少了显示设备、键盘或鼠标。
Headless模式针对在该模式下工作，尤其是服务器端程序开发者。因为服务器（如提供Web服务的主机）往往可能缺少前述设备，但又需要使用他们提供的功能，生成相应的数据，以提供给客户端（如浏览器所在的配有相关的显示设备、键盘和鼠标的主机）。
```

## Debian中匿名挂载Samba服务器中的目录

- 1、在Debian中安装Samba的相应组件：

	apt install cifs-utils

Debian中匿名挂载Samba服务器中的目录

- 2、查看其上已经共享的目录，假设Samba服务器的IP地址为192.168.1.135

	smbclient -L 192.168.1.135 -N

Debian中匿名挂载Samba服务器中的目录

其中-N即为匿名的意义。

- 3、在本地新建一个目录用于挂载

	mkdir /mnt/samba 

Debian中匿名挂载Samba服务器中的目录

- 4、使用mount挂载：

	mount -t cifs //192.168.1.135/netlogon    /mnt/samba/ -o guest

Debian中匿名挂载Samba服务器中的目录

其中-t cifs意义为使用SMB文件系统，-o guest意义为匿名访问，即使用guest来宾账户，之后不会再要求输入密码。
命令执行完毕后即将远程主机上的netlogon 目录挂载到本地的/mnt/samba目录。


## 安装EMBY 打造多媒体中心，刮削GD网盘影视库,在本地做影视索引服务
- 下载最新版本的 Emby Server，当前版本为 4.4.3.0，新版查阅地址：https://emby.media/linux-server.html

```
# 下载Emby安装包和安装
wget https://github.com/MediaBrowser/Emby.Releases/releases/download/4.4.3.0/emby-server-deb_4.4.3.0_amd64.deb
dpkg -i emby-server-deb_4.4.3.0_amd64.deb


#  使用网页打开 emby 服务器  配置EMBY
#  http://192.168.1.111:8096/

# 停止 emby 服务
systemctl stop  emby-server

# 恢复emby刮削数据
sudo rm -rf /var/lib/emby/*
cd /var/lib && tar -xvf "/mnt/EmbyMedia/EmbyData/emby200925.tar
sudo chown -R emby:emby /var/lib/emby

# 重新启动 emby 服务
systemctl start emby-server
systemctl status emby-server

```
