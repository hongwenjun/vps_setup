## VirMach 小内存机器InstallNET.sh 安装Debian 10 简易方法

```
# 下载网络安装脚本，自动安装的 root 密码写在 脚本前几行，
wget git.io/InstallNET.sh

# -d 10 表示debian  -v 64 表示X64  -a 表示自动安装  -m 手动安装
bash InstallNET.sh -d 10 -v 64 -a

# 由于这个网络脚本没有匹配小内存选择，所以会如下图停住
```
![](https://i.loli.net/2020/12/14/1uGp9xZTjyS2hAF.png)

```
# 所以需要进 KVM 面板，打开VNC 窗口，要按下确认，选择北美和美国地区，然后就能接下来自动安装
# 圣何塞  机房VNC 窗口会连不到，可以记录下 VNC 帐户，使用  VNC-Viewer 免费软件登陆

浏览器 打开 git.io/InstallNET.sh 网址查看密码，登陆 passwd 修改


# 最后 安装常用软件 和哪个软件，如图，系统盘占用不到1G
apt install wget curl tmux vim htop 
```
1[](https://i.loli.net/2020/12/14/H6AWcpK9yC1ftGi.png)
