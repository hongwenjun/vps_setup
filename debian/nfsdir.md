## 黑五变态机有救，可以用NFS挂载一个僚机
![](https://i.loli.net/2020/10/22/VltEuXR1oYhdIxN.png)

- 水牛城3G硬盘的机器 ，挂载亚特兰大32G盘机器，网盘速度有 9-10M/s
```
# NFS 服务端安装设置
apt install nfs-kernel-server -y

mkdir nfsdir

echo '/root/nfsdir  10.0.8.0/24(rw,sync,no_root_squash)'  >> /etc/exports

sudo /etc/init.d/nfs-kernel-server restart

# 或者
systemctl  restart  nfs-kernel-server

showmount -e
Export list for kvm-VirMach:
/root/nfsdir 10.0.8.0/24

# NFS 客户端安装使用
apt install nfs-common -y

mkdir /mnt/nfsdir -p
mount -t nfs 10.0.8.1:/root/nfsdir /mnt/nfsdir
df -h
cd /mnt/nfsdir

dd if=/dev/zero of=1.bin bs=1M count=100

dd if=/dev/zero of=1.bin bs=1M count=1024
```

- 以上配置 Debian 10 配置通过测试，虚拟网络 使用WG搭建，服务端和客户端都用这个脚本搭建
- 客户端 自行修改配置文件

```
# One-Step Automated Install WireGuard Script
wget -qO- https://git.io/wireguard.sh | bash
```

- NFS就是Network File System的缩写，它最大的功能就是可以通过网络，让不同的机器、不同的操作系统可以共享彼此的文件。

- NFS服务器可以让PC将网络中的NFS服务器共享的目录挂载到本地端的文件系统中，而在本地端的系统中来看，那个远程主机的目录就好像是自己的一个磁盘分区一样，在使用上相当便利；

- 介绍见  https://blog.csdn.net/qq_38265137/article/details/83146421
