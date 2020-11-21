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

- 检查,看到文件系统 GPT，2个分区分别是EFI
```
# gdisk -l /dev/sda

Found valid GPT with protective MBR; using GPT.
Disk /dev/sda: 16777216 sectors, 8.0 GiB
Disk identifier (GUID): B60E27F0-F574-4AAB-B0C1-BAEC5377DDFD
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048         1050623   512.0 MiB   EF00  EFI system partition
   2         1050624        16777182   7.5 GiB     8300  Linux filesystem
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
