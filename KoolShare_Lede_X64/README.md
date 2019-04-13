## 下载 koolshare Lede X64 Nuc 镜像
- 百度 kool 点击链接 首页- KoolShare - 源于玩家 服务玩家
- 选固件下载--> LEDE_X64_fw867

###  1.虚拟机使用的固件镜像
http://firmware.koolshare.cn/LEDE_X64_fw867/openwrt-koolshare-mod-v2.30-r10402-51ad900e2c-x86-64-uefi-gpt-squashfs.vmdk

###  2.安装到U盘使用  选择目录  虚拟机转盘或PE下写盘专用
http://firmware.koolshare.cn/LEDE_X64_fw867/%E8%99%9A%E6%8B%9F%E6%9C%BA%E8%BD%AC%E7%9B%98%E6%88%96PE%E4%B8%8B%E5%86%99%E7%9B%98%E4%B8%93%E7%94%A8/openwrt-koolshare-mod-v2.30-r10402-51ad900e2c-x86-64-combined-squashfs.img.gz


###  3.写U盘或者PE写盘工具  physdiskwrite.exe 下载
http://forspeed.onlinedown.net/down/physdiskwrite-0.5.2.zip

```
# PE写盘使用
把lede固件和 physdiskwrite.exe 文件拷贝到pe U盘，用pe启动，执行dos窗口,找到文件存放的路径
输入 physdiskwrite.exe -u ledeXXXXXX.img
-u 参数能够写大U盘和硬盘

# 固件写U盘，插入另外一个U盘，可以使用PE中的硬盘分区工具，把U盘删除所有的分区
命令同PE写盘
```

### 4. 下载 Oracle VM VirtualBox虚拟机
https://download.virtualbox.org/virtualbox/6.0.4/VirtualBox-6.0.4-128413-Win.exe
