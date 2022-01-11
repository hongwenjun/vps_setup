![bb.jpg][1]

# 数字货币学习文章 https://262235.xyz/index.php/tag/xmr/

## 使用Linux虚拟机(或VNC)建立数字货币冷钱包
![11.png][2]

    GRUB 菜单 按键 e 编辑菜单
    找到 quiet 后 添加  init=/bin/bash
    按 F10 进入系统 无网络的 Debian linux系统

![22.png][3]

```

GRUB 菜单 按键 e 编辑菜单
找到 quiet 后 添加  init=/bin/bash
按 F10 进入系统 无网络的 Debian linux系统

df -h 查看内存盘 挂载 /run
cd /run 后运行预先准备的钱包软件

/root/monero-wallet-cli | tee  seed.txt

按提示输入新建冷钱包名，和密码
seed种子选择 9 简体中文

现在建立的钱包，只可以看到钱包地址和只读私钥

seed种子因为选择中文，是乱码的。
所以要挂载 根分区，seed.txt 压缩密码打包到硬盘上

mount -no remount,rw /

7z a mycp.7z seed.txt -p

一次可以多做几个冷钱包，压缩加密打包备用，目前为止，自己也还不知道 seed 内容是什么
```
![捕获.PNG][4]

```
wallet 地址: 45MPKaLeV9t xxx NV3FoU2k
View key: 37f177238  xxxx 6790107
使用钱包地址和私钥建立只读钱包，可以发送零钱测试是否正确
```

  [1]: https://262235.xyz/usr/uploads/2022/01/1902993299.jpg
  [2]: https://262235.xyz/usr/uploads/2022/01/251645996.png
  [3]: https://262235.xyz/usr/uploads/2022/01/391228121.png
  [4]: https://262235.xyz/usr/uploads/2022/01/2706755165.png
