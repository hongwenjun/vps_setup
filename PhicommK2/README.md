### 斐讯 K2 路由器  Phicomm PSG1218 rev.A  固件版本  OpenWrt 18.06.1 下载地址
```
http://downloads.openwrt.org/releases/18.06.1/targets/ramips/mt7620/\
openwrt-18.06.1-ramips-mt7620-psg1218a-squashfs-sysupgrade.bin
```
###  OpenWrt 18.06.1 Ramips MT7620 SDK，编译程序使用
```
http://downloads.openwrt.org/releases/18.06.1/targets/ramips/mt7620/\
openwrt-sdk-18.06.1-ramips-mt7620_gcc-7.3.0_musl.Linux-x86_64.tar.xz
```

### WEB界面安装中文语言包命令
```
主机型号	Phicomm PSG1218 rev.A
架构	MediaTek MT7620A ver:2 eco:6
固件版本	OpenWrt 18.06.1 r7258-5eb055306f / LuCI openwrt-18.06 branch (git-18.228.31946-f64b152)
内核版本	4.14.63

root@OpenWrt:~# opkg update
Downloading http://downloads.openwrt.org/releases/18.06.1/targets/ramips/mt7620/packages/Packages.gz

root@OpenWrt:~# opkg list | grep luci-i18n-base-zh-cn
luci-i18n-base-zh-cn - git-18.340.83383-3dea6b5-1 - Translation for luci-base - 中文 (Chinese)

root@OpenWrt:~# opkg install luci-i18n-base-zh-cn
Installing luci-i18n-base-zh-cn (git-18.340.83383-3dea6b5-1) to root...
Downloading http://downloads.openwrt.org/releases/18.06.1/packages/mipsel_24kc/luci/luci-i18n-base-zh-cn_git-18.340.83383-3dea6b5-1_all.ipk
Configuring luci-i18n-base-zh-cn.
```


### 更新软件源失败，可能要添加下DNS
```
# vim /etc/resolv.conf
search lan
nameserver 127.0.0.1

添加临时的DNS，重启后还是会丢失DNS
nameserver 8.8.8.8
nameserver 114.114.114.114

# /etc/init.d/dnsmasq restart
udhcpc: started, v1.28.3
udhcpc: sending discover
udhcpc: no lease, failing
```


### 修改局域网网段
```
# vim /etc/config/network

config interface 'loopback'
        option ifname 'lo'
        option proto 'static'
        option ipaddr '127.0.0.1'
        option netmask '255.0.0.0'

config globals 'globals'
        option ula_prefix 'fdd7:683a:5567::/48'

config interface 'lan'
        option type 'bridge'
        option ifname 'eth0.1'
        option proto 'static'
        option netmask '255.255.255.0'
        option ip6assign '60'
        option dns '114.114.114.114 8.8.8.8'   # 修改DNS
        option ipaddr '192.168.1.1'            # 修改局域网网段

config device 'lan_dev'
        option name 'eth0.1'
        option macaddr 'd8:c8:e9:1e:aa:e1'

config interface 'wan'
        option ifname 'eth0.2'
        option proto 'pppoe'
        option username 'jhlxh88888888'  # 宽带帐号
        option password 'jhlxh888'       # 宽带密码
        option ipv6 'auto'

config device 'wan_dev'
        option name 'eth0.2'
        option macaddr 'd8:c8:e9:1e:aa:e2'

config interface 'wan6'
        option ifname 'eth0.2'
        option proto 'dhcpv6'

config switch
        option name 'switch0'
        option reset '1'
        option enable_vlan '1'

config switch_vlan
        option device 'switch0'
        option vlan '1'
        option ports '0 1 2 3 6t'

config switch_vlan
        option device 'switch0'
        option vlan '2'
        option ports '4 6t'
        
```

## 编译openwrt版udpspeeder和udp2raw 中文教程

https://www.atrandys.com/2018/1255.html

### 编译好的 udpspeedr和udp2raw for K2 打包下载

[udp2raw_udpspeeder_mipsel_24kc.tar](https://github.com/hongwenjun/vps_setup/raw/master/PhicommK2/udp2raw_udpspeeder_mipsel_24kc.tar
)

###  K2_OpenWrt_安装udpspeedr和udp2raw日志

```
root@OpenWrt:/tmp/tmp# opkg update

Downloading http://downloads.openwrt.org/releases/18.06.1/targets/ramips/mt7620/packages/Packages.gz
Updated list of available packages in /var/opkg-lists/openwrt_core
Downloading http://downloads.openwrt.org/releases/18.06.1/targets/ramips/mt7620/packages/Packages.sig
Signature check passed.
Downloading http://downloads.openwrt.org/releases/18.06.1/packages/mipsel_24kc/base/Packages.gz
Updated list of available packages in /var/opkg-lists/openwrt_base
Downloading http://downloads.openwrt.org/releases/18.06.1/packages/mipsel_24kc/base/Packages.sig
Signature check passed.
Downloading http://downloads.openwrt.org/releases/18.06.1/packages/mipsel_24kc/luci/Packages.gz
Updated list of available packages in /var/opkg-lists/openwrt_luci
Downloading http://downloads.openwrt.org/releases/18.06.1/packages/mipsel_24kc/luci/Packages.sig
Signature check passed.
Downloading http://downloads.openwrt.org/releases/18.06.1/packages/mipsel_24kc/packages/Packages.gz
Updated list of available packages in /var/opkg-lists/openwrt_packages
Downloading http://downloads.openwrt.org/releases/18.06.1/packages/mipsel_24kc/packages/Packages.sig
Signature check passed.
Downloading http://downloads.openwrt.org/releases/18.06.1/packages/mipsel_24kc/routing/Packages.gz
Updated list of available packages in /var/opkg-lists/openwrt_routing
Downloading http://downloads.openwrt.org/releases/18.06.1/packages/mipsel_24kc/routing/Packages.sig
Signature check passed.
Downloading http://downloads.openwrt.org/releases/18.06.1/packages/mipsel_24kc/telephony/Packages.gz
Updated list of available packages in /var/opkg-lists/openwrt_telephony
Downloading http://downloads.openwrt.org/releases/18.06.1/packages/mipsel_24kc/telephony/Packages.sig
Signature check passed.

root@OpenWrt:/tmp/tmp# opkg install udpspeeder_20180821.0-1_mipsel_24kc.ipk
Installing udpspeeder (20180821.0-1) to root...
Installing libstdcpp (7.3.0-1) to root...
Downloading http://downloads.openwrt.org/releases/18.06.1/targets/ramips/mt7620/packages/libstdcpp_7.3.0-1_mipsel_24kc.ipk
Installing librt (1.1.19-1) to root...
Downloading http://downloads.openwrt.org/releases/18.06.1/targets/ramips/mt7620/packages/librt_1.1.19-1_mipsel_24kc.ipk
Configuring libstdcpp.
Configuring librt.
Configuring udpspeeder.

root@OpenWrt:/tmp/tmp# opkg install udp2raw-tunnel_20181113.0-1_mipsel_24kc.ipk
Installing udp2raw-tunnel (20181113.0-1) to root...
Configuring udp2raw-tunnel.

```

### K2_OpenWrt 固件带wget是mini版，不支持https下载，可以另外安装完整的wget
### K2_OpenWrt 已经有 Tmux 这个强大的工具了
```
opkg update
opkg install wget
opkg install tmux

# 搜索需要下载的工具
opkg list | grep -e wireguard
```
