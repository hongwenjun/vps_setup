#!/bin/bash
# youtube-dl.sh  安装下载YouTube视频和音乐

url_list=url_list.txt
if [[ $# > 1 ]];then
    url_list=$2
fi

youtube_dl_install(){
    apt install -y youtube-dl ffmpeg
    curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/bin/youtube-dl
    chmod +x /usr/bin/youtube-dl
}

vod_download(){
    while read -r line || [[ -n $line ]];do
         youtube-dl  $line
    done < $url_list
}


mp3_download(){
    while read -r line || [[ -n $line ]];do
        youtube-dl -f 140 $line
    done < $url_list

    ls -1 *.m4a > /tmp/m4a.txt
    while read -r m4a || [[ -n $m4a ]];do
        mp3=$(echo $m4a |  awk -F '.' '{print $1}')
        ffmpeg -i "${m4a}"  "${mp3}.mp3"
    done < /tmp/m4a.txt

    rm *.m4a
}


help_info(){
echo -e "\e[1;33m Usage: $0  [install|mp3|vod]  [url_list.txt] \e[0m"

}

# Bash执行选项
if [[ $# > 0 ]];then
	key="$1"
	case $key in
		install)
		youtube_dl_install
		;;
		mp3)
		mp3_download
		;;
        vod)
		vod_download
		;;

	esac
else
    help_info
fi
