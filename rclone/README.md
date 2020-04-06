## rclone 使用教程  傻瓜版

rclone一款能够方便的管理 google drive 与 dropbox 、OneDrive等网盘，支持挂载盘符与命令行上传下载的开源程序。

### 安装rclone 官方脚本
```
curl https://rclone.org/install.sh | sudo bash
```

### 新手初次使用手工按命令安装 rclone 和配置 Google 网盘
```bash
wget https://downloads.rclone.org/v1.51.0/rclone-v1.51.0-linux-amd64.zip
unzip  rclone-v1.51.0-linux-amd64.zip
cd rclone-v1.51.0-linux-amd64
cp rclone /usr/bin/rclone
./rclone config
```

### 首次配置 按默认来就可以，重点选择 headless machine
```bash
Remote config
Use auto config?                                 # 需要选择 Auto Config
 * Say Y if not sure
 * Say N if you are working on a remote or headless machine    # 重点选择 headless 
y) Yes (default)
n) No
y/n> n
Please go to the following link: https://accounts.google.com/o/oauth2/auth   # 本地浏览器打开安全授权链接
Log in and authorize rclone for access
Enter verification code>  # 这里输入本地浏览器访问Google帐号获得授权 安全码
Configure this as a team drive?
y) Yes
n) No (default)
y/n> y
Fetching team drive list...
Choose a number from below, or type in your own value
 1 / CCSF Team Share
   \ "0AFjuq6r_mFCiUk9PVA"
Enter a Team Drive ID> 1
```

### rclone 命令示例演示
```bash
rclone ls GD:

# 复制目录和复制文件
rclone copy  GD:pt  /tmp/pt
rclone copy  GD:pt/1111.cdr  new.cdr

# 建立GD目录上传文件
rclone mkdir GD:rclone
rclone copy  大电影文件夹   mkdir GD:rclone/.
rclone sync IYUUAutoReseed  GD:IYUUAutoReseed
```

![](https://raw.githubusercontent.com/hongwenjun/img/master/rclone_copy.png)
![](https://raw.githubusercontent.com/hongwenjun/img/master/rclone_net.png)

### 也可以使用旧有配置
 - vim /root/.config/rclone/rclone.conf
```conf
[GD]
type = drive
scope = drive
token = {"access_token":"ya29xxxxxxxxmdRPtkByaM","token_type":"Bearer","refresh_token":"1//0fxxxxxxxxxxxx","expiry":"2020-03-14T13:23:43.337512244Z"}
team_drive = 0xxxxxxxxxxxxxxxxxxxxxxxxxxxxA
```

# rclone 命令大全
```
### 文件上传
rclone copy /home/backup gdrive:backup # 本地路径 配置名字:谷歌文件夹名字
### 文件下载
rclone copy gdrive:backup /home/backup
### 列表
rclone ls gdrive:backup
rclone lsl gdrive:backup # 比上面多一个显示上传时间
rclone lsd gdrive:backup # 只显示文件夹
### 新建文件夹
rclone mkdir gdrive:backup
### 挂载
rclone mount gdrive:mm /root/mm &
### 卸载
fusermount -u  /root/mm

#### 其他 ####
#### https://softlns.github.io/2016/11/28/rclone-guide/

rclone config - 以控制会话的形式添加rclone的配置，配置保存在.rclone.conf文件中。
rclone copy - 将文件从源复制到目的地址，跳过已复制完成的。
rclone sync - 将源数据同步到目的地址，只更新目的地址的数据。   –dry-run标志来检查要复制、删除的数据
rclone move - 将源数据移动到目的地址。
rclone delete - 删除指定路径下的文件内容。
rclone purge - 清空指定路径下所有文件数据。
rclone mkdir - 创建一个新目录。
rclone rmdir - 删除空目录。
rclone check - 检查源和目的地址数据是否匹配。
rclone ls - 列出指定路径下所有的文件以及文件大小和路径。
rclone lsd - 列出指定路径下所有的目录/容器/桶。
rclone lsl - 列出指定路径下所有文件以及修改时间、文件大小和路径。
rclone md5sum - 为指定路径下的所有文件产生一个md5sum文件。
rclone sha1sum - 为指定路径下的所有文件产生一个sha1sum文件。
rclone size - 获取指定路径下，文件内容的总大小。.
rclone version - 查看当前版本。
rclone cleanup - 清空remote。
rclone dedupe - 交互式查找重复文件，进行删除/重命名操作。

```

### 挂载GD盘，到GCP申请API，然后使用 rclone mount 挂载
```bash
Google Drive API

Client ID
6888888888884-nj888888888888888o.apps.googleusercontent.com

Client Secret
Kb888888888888888

```

### 使用教育GD盘转存资源，体验极速
![](https://raw.githubusercontent.com/hongwenjun/img/master/rclone_server_side_copy.png)

```bash
rclone ls GOD:/VOD/IPX-457.iso

rclone -P copy GOD:/VOD/IPX-457.iso  GOD:/VOD1/IPX-457.iso
```

### 教育盘不用流量转存资料
``` bash
rclone copy 源文件夹 目标文件夹 -P --transfers 10 --drive-server-side-across-configs --fast-list

https://hostloc.com/thread-584449-1-1.html
rclone从与我分享拷贝内容到团队盘(Shared with me to Team Drive)

# 操作命令 server side copy 使用rclone
# 同盘共享资源链接转存
rclone sync  GOD:VOD   GOD:VOD1

# 教育盘复制到团队盘
rclone copy  -P --transfers 2   \
--drive-server-side-across-configs --fast-list \
GOD:VOD1   GOD1:VOD1

# 教育盘同步到团队盘
rclone sync  -P --transfers 2   \
--drive-server-side-across-configs --fast-list \
GOD:VOD1   GOD1:VOD1
# 指定并行传输数量 --transfers 2

```
