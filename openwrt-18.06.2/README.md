## OpenWRT 安装 WireGuard 配置 Udp2Raw + UdpSpeeder + WireGuard 文档教程
- 短网址: https://git.io/wrt.wg  &nbsp;&nbsp;&nbsp; [蘭雅sRGB![](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/youtube.png)频道](https://www.youtube.com/channel/UCupRwki_4n87nrwP0GIBUXA/videos) &nbsp;&nbsp;&nbsp;可以观看相关脚本工具的演示视频!

- OpenWRT-18.06.2 编译完成的 udp2raw-tunne udpspeeder luci-udptools [安装包下载](https://github.com/hongwenjun/vps_setup/blob/master/openwrt-18.06.2/openwrt_udptools.zip)
- [openwrt_udptools.zip](https://github.com/hongwenjun/vps_setup/blob/master/openwrt-18.06.2/openwrt_udptools.zip)
-----------------
- 编译openwrt版udpspeeder和udp2raw [文章链接](https://www.atrandys.com/2018/1255.html)
- luci-udptools：在路由器页面管理udp2raw+udpspeeder [文章链接](https://www.atrandys.com/2018/1247.html)

-----------------
### UDP工具 配置图示
![](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/openwrt-18.06.2/openwrt_udptools.png)

```
# ps | grep -e udp           # 可以查看工具运行的参数
udpspeeder -c -l0.0.0.0:9999 -r127.0.0.1:21333   -f20:10 --mode 0 --timeout 0
udp2raw -c -l127.0.0.1:21333 -r34.80.188.188:2999 --raw-mode faketcp -a -k password

# luci-udptools 工具默认: udpspeeder 不用密码，所以VPS服务端 udpspeeder 改成不用密码
# vim /etc/init.d/udptools   # 或者编辑 luci-udptools 的脚本 第21行添加 -k $password
# vim /etc/config/udptools   # UDP工具 参数配置
```
- UDP工具脚本: [/etc/init.d/udptools](https://github.com/atrandys/luci-udptools/blob/master/src/etc/init.d/udptools)
- UDP参数配置: [/etc/config/udptools](https://github.com/atrandys/luci-udptools/blob/master/src/etc/config/udptools)

### OpenWRT 安装 WireGuard， 配置 Udp2Raw + UdpSpeeder + WireGuard 图示
```
opkg list | grep wireguard
opkg install wireguard wireguard-tools luci-i18n-wireguard-zh-cn

# 安装中文语言包和常用工具
opkg update
opkg install luci-i18n-base-zh-cn
opkg install wget tmux ca-certificates htop
```

![](https://raw.githubusercontent.com/hongwenjun/img/master/openwrt-wg_udp2raw.png)
- 配置先填wg服务器IP，配置连上了，再改 UDP工具套接到 127.0.0.1
-----------------

### 改进后 OpenWRT 安装 WireGuard 防火墙设置
![](https://raw.githubusercontent.com/hongwenjun/img/master/openwrt-wg_firewall.png)
- 在vps上下安装 Nginx 服务器，然后把电脑设置网关IP 为OpenWRT的IP，再使用 http://10.0.0.1 测试

### OpenWRT-18.06.2 X64 固件和SDK 下载地址和文件名
https://downloads.openwrt.org/releases/18.06.2/targets/x86/64/
- openwrt-18.06.2-x86-64-combined-squashfs.img.gz
- openwrt-sdk-18.06.2-x86-64_gcc-7.3.0_musl.Linux-x86_64.tar.xz

```
# udp2raw-tunne udpspeeder luci-udptools 编译后ipk包保存位置
openwrt-x64/bin/packages/x86_64/base/luci-udptools_1.0.0-1_all.ipk
openwrt-x64/bin/packages/x86_64/base/udpspeeder_20180821.0-1_x86_64.ipk
openwrt-x64/bin/packages/x86_64/base/udp2raw-tunnel_20181113.0-1_x86_64.ipk
openwrt-x64/bin/targets/x86/64/packages/libpthread_1.1.19-1_x86_64.ipk
openwrt-x64/bin/targets/x86/64/packages/libstdcpp_7.3.0-1_x86_64.ipk
openwrt-x64/bin/targets/x86/64/packages/librt_1.1.19-1_x86_64.ipk
openwrt-x64/bin/targets/x86/64/packages/libatomic_7.3.0-1_x86_64.ipk
openwrt-x64/bin/targets/x86/64/packages/libc_1.1.19-1_x86_64.ipk
openwrt-x64/bin/targets/x86/64/packages/libgcc_7.3.0-1_x86_64.ipk
```
-----------------

### OpenWRT-18.06.2 x86 固件和SDK 下载地址和文件名
https://downloads.openwrt.org/releases/18.06.2/targets/x86/generic/
- openwrt-18.06.2-x86-generic-combined-squashfs.img.gz
- openwrt-sdk-18.06.2-x86-generic_gcc-7.3.0_musl.Linux-x86_64.tar.xz

```
# udp2raw-tunne udpspeeder luci-udptools 编译后ipk包保存位置
openwrt-x86/bin/packages/i386_pentium4/base/udp2raw-tunnel_20181113.0-1_i386_pentium4.ipk
openwrt-x86/bin/packages/i386_pentium4/base/luci-udptools_1.0.0-1_all.ipk
openwrt-x86/bin/packages/i386_pentium4/base/udpspeeder_20180821.0-1_i386_pentium4.ipk
openwrt-x86/bin/targets/x86/generic/packages/libc_1.1.19-1_i386_pentium4.ipk
openwrt-x86/bin/targets/x86/generic/packages/libpthread_1.1.19-1_i386_pentium4.ipk
openwrt-x86/bin/targets/x86/generic/packages/libatomic_7.3.0-1_i386_pentium4.ipk
openwrt-x86/bin/targets/x86/generic/packages/libstdcpp_7.3.0-1_i386_pentium4.ipk
openwrt-x86/bin/targets/x86/generic/packages/librt_1.1.19-1_i386_pentium4.ipk
openwrt-x86/bin/targets/x86/generic/packages/libgcc_7.3.0-1_i386_pentium4.ipk
```

-----------------

### 如果 opkg update 更新软件源失败，可以添加DNS

```
# vim /etc/resolv.conf
search lan
nameserver 127.0.0.1

# 添加临时的DNS，重启后还是会丢失DNS
nameserver 8.8.8.8
nameserver 114.114.114.114

# /etc/init.d/dnsmasq restart

# 也可以添加DNS到 lan 接口里
```
-----------------

### OpenWRT 安装到U盘里工具和命令
- 下载工具 [physdiskwrite.zip](https://github.com/hongwenjun/vps_setup/blob/master/openwrt-18.06.2/physdiskwrite.zip)
- 使用 [DiskGenius](http://www.diskgenius.cn/) 把U盘删除所有分区保存
- Windows 中找到 命令提示符  右键管理员权限打开，或者WINPE下的命令窗口操作

	physdiskwrite.exe -u openwrt-18.img

- -u 参数能够写大U盘和硬盘
- 可以再使用 [DiskGenius](http://www.diskgenius.cn/) 把剩余的空间分成 windows 支持的U盘分区，平常也可以装点工具

### 安装 LEDE 或 OpenWRT 剩余磁盘空间，用来做虚拟主机空间
```
opkg install fdisk   # 安装fdisk工具
fdisk -l             # 查询磁盘名称和空间
fdisk /dev/sdb       # 磁盘分区,选n把剩余空间新建一个主分区
mkfs.ext4 /dev/sdb3  # 格式化第3个主分区

```
- 挂载 /dev/sdb3 分区，当作一个虚拟主机  http://192.168.1.254:88
```
mkdir -p /usr/upan
mount /dev/sdb3 /usr/upan

/usr/sbin/uhttpd -f -h /usr/upan -r upan -x /cgi-bin  -p 0.0.0.0:88 -p [::]:88  &
```
- 把3行命令添加到路由器的开机脚本里面

![](https://raw.githubusercontent.com/hongwenjun/img/master/openwrt_mount.png)

- OpenWRT 安装 frpc 客户端，使用内网穿透，就能从外网访问路由器和虚拟主机了

-----------------

### OpenWRT 安装 shadowsocks-libev
	opkg list | grep shadowsocks    # 查询官方有什么版本
- luci-app-shadowsocks-libev - git-19.079.57770-b99e77d-1
- shadowsocks-libev-config - 3.1.3-3
- shadowsocks-libev-ss-local - 3.1.3-3
- shadowsocks-libev-ss-redir - 3.1.3-3
- shadowsocks-libev-ss-rules - 3.1.3-3
- shadowsocks-libev-ss-tunnel - 3.1.3-3

```
# OpenWRT 安装 shadowsocks-libev 命令
opkg update
opkg install luci-app-shadowsocks-libev  shadowsocks-libev-config  shadowsocks-libev-ss-local \
             shadowsocks-libev-ss-redir  shadowsocks-libev-ss-rules  shadowsocks-libev-ss-tunnel

```
- PS: 目前电信运行商Qos拦截WireGuard确实越来严了，目前可以折腾爬墙新姿势：[WG+SPEED+UDP2RAW+SS](https://youtu.be/ptXfUpjP8bI?list=PLPidIcmhqWuRgSDLDdn-NFK1e3Y8pLg7M)

-----------------
### 视频最后 我把视频使用的虚拟盘镜像上传，有兴趣，可以直接下载解压给虚拟机
[OpenWRT虚拟盘下载](https://github.com/hongwenjun/img/releases/download/1.0/OpenWRT_18.vmdk.7z)
```
https://github.com/hongwenjun/img/releases/download/1.0/OpenWRT_18.vmdk.7z
```
-----------------
