## OpenWRT-18.06.2 软路由 udp2raw-tunne udpspeeder luci-udptools 

- 编译openwrt版udpspeeder和udp2raw [文链接](https://www.atrandys.com/2018/1255.html)
- luci-udptools：在路由器页面管理udp2raw+udpspeeder [文链接](https://www.atrandys.com/2018/1247.html)
- 编译完成的 udp2raw-tunne udpspeeder luci-udptools [安装包下载](https://github.com/hongwenjun/vps_setup/blob/master/openwrt-18.06.2/openwrt_udptools.zip)
- [openwrt_udptools.zip](https://github.com/hongwenjun/vps_setup/blob/master/openwrt-18.06.2/openwrt_udptools.zip)

-----------------
### UDP工具 配置图示
![](https://github.com/hongwenjun/vps_setup/blob/master/openwrt-18.06.2/openwrt_udptools.png)

```
# ps | grep -e udp           # 可以查看工具运行的参数
udpspeeder -c -l0.0.0.0:9999 -r127.0.0.1:21333   -f20:10 --mode 0 --timeout 0
udp2raw -c -l127.0.0.1:21333 -r34.80.10.132:2999 --raw-mode faketcp -a -k password

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
```
![](https://raw.githubusercontent.com/hongwenjun/img/master/openwrt-wg_udp2raw.png)
- 配置先填wg服务器IP，配置连上了，再改 UDP工具套接到 127.0.0.1
-----------------

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
