## Arch Linux 安装简易版 For VirtualBox 安装虚拟机

### 启动ssh服务，临时修改光盘系统密码，方便ssh客户端远程登陆安装系统
```
systemctl restart sshd
ip addr
passwd
```

### 硬盘分区，一个区 linux分区 命令选o，建立dos硬盘，命令n，默认建立linux主分区
```
fdisk /dev/sda
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt
```

### 如果是国内,选择镜像推荐清华中科大，
- vim编辑找到China源  9yyggp <Esc>:wq
```
vim /etc/pacman.d/mirrorlist
```

### 安装必须的软件包到硬盘中，如果虚拟机 linux-firmware 可以不装
```
pacstrap /mnt  base linux linux-firmware
```

### 把硬盘UUID写到fstab里，下次重启能自动找到
```
genfstab -U /mnt >> /mnt/etc/fstab
```

### 把根目录/  切换到硬盘/dev/sda1，接下来的都在硬盘系统操作
```
arch-chroot /mnt
```

### 软件包更新源，安装必要软件
```
pacman -Syy
pacman -S  dhcpcd  openssh  grub  vim htop wget curl tmux  fish  ca-certificates 
```

### Arch配置同其他linux不同，用傻瓜dhcpcd; 启用ssh服务
```
systemctl enable dhcpcd
systemctl enable sshd
```

### 安装grub引导信息到硬盘，自动建立grub.cfg
```
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

### 修改系统root密码，建立一个vip，临时ssh远程用
```
passwd
useradd vip
passwd  vip
```

### 重启系统，然后ssh 登陆，su 切换管理员
```
ssh vip@192.168.1.110
# 建立 /root/.ssh/authorized_keys 密钥文件后就可以root登陆了
ssh root@192.168.1.110
```

### arch 安装命令参考中文文档
- https://wiki.archlinux.org/index.php/Installation_guide_(简体中文)


### start_VM_Headless 简易 VirtualBox Headless 模式启动器
- VBoxManage.exe 建立2个快捷方式，分别启动和关闭 ArchLinux
```
# Oracle VM VirtualBox 默认安装目录   C:\Program Files\Oracle\VirtualBox\

"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"  startvm   ArchLinux  --type headless

"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"  controlvm  ArchLinux  acpipowerbutton

```

-------

## 另外一种Arch Linux 安装: 使用gdisk建立EFI分区和Linux分区
gdisk /dev/sda

- 直接打o，意味着create a new empty GUID partition table (GPT)，回车
- 接下来，打n，新建分区,EFI分区用来储存引导文件,分区代码 EF00 表示efi分区
- 再建立Linux分区，直到Hex code这行，打8300，8300是linux的文件系统。

- 检查,看到文件系统 GPT，2个分区分别是EFI system partition 和 Linux filesystem
```
# gdisk -l /dev/sda

Found valid GPT with protective MBR; using GPT.
Disk /dev/sda: 16777216 sectors, 8.0 GiB
Disk identifier (GUID): B60E27F0-F574-4AAB-B0C1-BAEC5377DDFD
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048         1050623   512.0 MiB   EF00  EFI system partition  # EFI分区主要放引导文件其实128M够用了
   2         1050624        16777182   7.5 GiB     8300  Linux filesystem
```

### 格式化分区和挂载分区有相应修改，再按上面安装Arch系统
```
mkfs.vfat -F 32  /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir -p  /mnt/boot
mount /dev/sda1 /mnt/boot
```


## 不装GRUB，使用系统自带的systemd bootctl

```
bootctl install
```

```
# vim /boot/loader/loader.conf

default arch
timeout 1

#console-mode keep
default 75ece990f54f40eba924862b4f752aa6-*
```

```
vim /boot/loader/entries/arch.conf

title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=PARTUUID=470b42a8-69bf-4822-ad1a-8164c741b17c rw
```

### 查看磁盘分区UUID号
```
partx /dev/sda
NR   START      END  SECTORS SIZE NAME                 UUID
 1    2048  1050623  1048576 512M EFI system partition 0d180520-7c33-4899-9e8e-30272e072fb4
 2 1050624 16777182 15726559 7.5G Linux filesystem     470b42a8-69bf-4822-ad1a-8164c741b17c

```

## Arch Linux 安装 Nginx + PHP-FPM 配置填坑笔记
- 安装nginx和php-fpm挺简单，启用服务 systemctl enable
```
pacman -S nginx php php-fpm
systemctl enable nginx
systemctl enable php-fpm

# 生成index.php
echo "<?php echo phpinfo(); ?>"   >  /usr/share/nginx/html/index.php

# 调试配置比较坑，会用到重启命令
systemctl restart nginx
systemctl restart php-fpm

```

### 网上找了N个方法，终于找到一个能用的
```
 # pass PHP scripts to FastCGI server
location ~ \.php$ {
	root           /usr/share/nginx/html;
	fastcgi_pass   unix:/run/php-fpm/php-fpm.sock;
	fastcgi_index  index.php;
	fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
	include        fastcgi_params;
}
```

### Arch Wiki 找到的配置,因为 nginx.conf 默认配置 root变量移到了location空间里，导致SCRIPT_FILENAME失效
```
# vim /etc/nginx/nginx.conf

# 默认 nginx.conf 配置 root变量移到了location空间里
location / {
   root   /usr/share/nginx/html;
   index  index.html index.htm;
}
```
-----
- 解决方法 root 移出来，或者在 php-fpm 配置里复制一份
```
# 解决方法 root 移出来
root /usr/share/nginx/html;  

 # pass PHP scripts to FastCGI server
location ~ \.php$ {
    # 404
    try_files $fastcgi_script_name =404;

  #  root /usr/share/nginx/html;    ###  在 php-fpm 配置里复制一份 root

    # default fastcgi_params
    include fastcgi_params;

    # fastcgi settings
    fastcgi_pass			unix:/run/php-fpm/php-fpm.sock;
    fastcgi_index			index.php;
    fastcgi_buffers			8 16k;
    fastcgi_buffer_size		32k;

    # fastcgi params
    fastcgi_param DOCUMENT_ROOT	    $realpath_root;
    fastcgi_param SCRIPT_FILENAME	$realpath_root$fastcgi_script_name;
    #fastcgi_param PHP_ADMIN_VALUE	"open_basedir=$base/:/usr/lib/php/:/tmp/";
}
```

- 参考链接: https://wiki.archlinux.org/index.php/Nginx_(简体中文)

### 还有一个比较坑的 fastcgi_pass 变量怎么设置，网上有N种配置
- 网上有N种配置，你不知道怎么设置和测试；我也是花了N个小时整理出来的方法，应该也适用于debian系统
```
1.  php  ./index.php             # 测试 php 是否正确
2.  systemctl status php-fpm     # 检查 php-fpm 是否启动
3.  nginx -t                     # 检查配置是否有问题
4.  vim  /etc/php/php-fpm.conf/  # 找到 include=/etc/php/php-fpm.d/*.conf 这行，判断 www.conf 所在目录
5.  cd /etc/php/php-fpm.d/       # 找到文件  /etc/php/php-fpm.d/www.conf
6.  cat www.conf | grep 'php-fpm'  # 查到 listen = /run/php-fpm/php-fpm.sock  判断 php-fpm 正确的监听端口
7.  修改nginx配置:  fastcgi_pass	 unix:/run/php-fpm/php-fpm.sock;     # 各个linux 默认各不相同
8.  systemctl restart nginx      #  重启nginx 测试是否能正确php，不行就网络查资料再排查
```

### 附: Debian 系统 Nginx 默认配置文件:  /etc/nginx/sites-enabled/default
- 作为参考比较， Debian Nginx + PHP-FPM 设置好像简单点
```
 # Add index.php to the list if you are using PHP
index index.html index.htm index.nginx-debian.html index.php;
```
```
    # pass PHP scripts to FastCGI server
    #
    location ~ \.php$ {
            include snippets/fastcgi-php.conf;
    #
    #       # With php-fpm (or other unix sockets):
            fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;  # 注意版本号要对应，不然 520 网关错误
    #       # With php-cgi (or other tcp sockets):
    #       fastcgi_pass 127.0.0.1:9000;                     # apt 安装的 php-fpm 直接开这个是不行的
    }
```

### Debian 系统 Nginx + PHP-FPM 设置排查方案步骤
```
1.  php  ./index.php             # 测试 php 是否正确
2.  systemctl status php7.3-fpm  # 检查 php-fpm 是否启动
3.  vim /etc/nginx/nginx.conf    # http用户名 user www-data; 站点配置 include /etc/nginx/sites-enabled/*;
    vim /etc/nginx/sites-enabled/default
    nginx -t                     # 检查配置是否有问题
4.  vim /etc/php/7.3/fpm/php-fpm.conf   # 判断 www.conf 所在目录
5.  cd /etc/php/php-fpm.d/       # 找到文件  /etc/php/php-fpm.d/www.conf
6.  cat /etc/php/7.3/fpm/pool.d/www.conf | grep -e  'fpm\.sock'  
    # 查到 listen = /run/php/php7.3-fpm.sock  判断 php-fpm 正确的监听端口
7.  修改nginx配置:  fastcgi_pass  unix:/run/php/php7.3-fpm.sock;
8.  systemctl restart nginx      #  重启nginx 测试是否能正确php
```

### 修正 Arch Linux locale 無法 generate 以及 tmux mosh 出現錯誤
```
pacman -S tmux

tmux: invalid LC_ALL, LC_CTYPE or LANG

locale -a
locale: Cannot set LC_CTYPE to default locale: No such file or directory
locale: Cannot set LC_MESSAGES to default locale: No such file or directory
locale: Cannot set LC_COLLATE to default locale: No such file or directory
```
### 解法 沒有把 /etc/locale.gen 內的 comment 拿掉
```
vim /etc/locale.gen
#en_US.UTF-8 UTF-8 删除 注释#

locale-gen "en_US.UTF-8"

Generating locales...
  en_US.UTF-8...
done
```
