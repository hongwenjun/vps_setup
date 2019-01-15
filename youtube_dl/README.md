## youtube-dl  批量下载YouTube视频和音乐
	Usage: you.sh  [install | mp3 | vod]  [url_list.txt | URL]
	
### 下载脚本命令
	wget -qO you.sh https://git.io/fhc9F
	
### 使用演示动画
![](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/youtube_dl/you.gif)

### 功能介绍
```
bash you.sh install    # 安装 youtube-dl 和 ffmpeng
bash you.sh mp3        # 批量下载mp3
bash you.sh vod        # 批量下载视频

vim url_list.txt       # 编辑 复制YouTube 的视频 URL 到这个文件表里

bash you.sh mp3  myurl.txt   # 指定视频URL表文件,下载转换成mp3
bash you.sh mp3  URL   # 下载 URL
```
