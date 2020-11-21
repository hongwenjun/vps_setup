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
- vim编辑找到China源[** 9yyggp <Esc>:wq **]
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
