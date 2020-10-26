# python 读写剪切板内容
# pip3 install pywin32

import win32clipboard as w
import win32con
import os

def getText():
    w.OpenClipboard()
    d = w.GetClipboardData(win32con.CF_TEXT)
    w.CloseClipboard()
    return(d).decode('GBK')

def setText(aString):
    w.OpenClipboard()
    w.EmptyClipboard()
    w.SetClipboardText(aString)
    w.CloseClipboard()

# 获取剪贴板文本
url = getText()
print(url)

# 替换 EmbyMedia 路径 到URL 给PotPlayer播放视频
emby_path = "/mnt/EmbyMedia/"
http_url = "http://192.168.1.111/"

url = url.replace( emby_path , http_url ).replace('\n', '')

# 把文本写回剪贴板
setText(url)
print(url)

path = "C:\Program Files\DAUM\PotPlayer"
os.chdir(path)

cmdline ='cmd /c  ' + 'PotPlayerMini64.exe  \"' +  url + '\"'

print(cmdline)

# 调用 PotPlayer 64 bit
os.system(cmdline)

# os.system('pause')