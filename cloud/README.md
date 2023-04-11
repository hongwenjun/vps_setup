## 家庭云之一键安装Samba
Samba，是种用来让UNIX系列的操作系统与微软Windows操作系统的SMB/CIFS（Server Message Block/Common Internet File System）网络协议做链接的自由软件。第三版不仅可访问及分享SMB的文件夹及打印机，本身还可以集成入Windows Server的网域，扮演为网域控制站（Domain Controller）以及加入Active Directory成员。简而言之，此软件在Windows与UNIX系列操作系统之间搭起一座桥梁，让两者的资源可互通有无。

```bash
wget 262235.xyz/samba.sh && bash samba.sh
```

## 家庭云之一键安装 `php`相册 files.photo.gallery
files.photo.gallery 是一个单文件 PHP 应用程序，可以将其放入服务器上的任何文件夹中，从而立即创建一个文件和文件夹库。它支持所有文件类型，并允许您预览图像、视频、音频和文本文件。

```bash
wget 262235.xyz/photo.sh && bash photo.sh
```

## `samba.sh` 和 `photo.sh` 脚本源码
https://github.com/hongwenjun/vps_setup/tree/remove/cloud/