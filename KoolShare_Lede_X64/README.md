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

