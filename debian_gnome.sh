#!/bin/bash

# Debian安装Gnome桌面脚本
apt update
apt install x-window-system-core
apt install gnome-core

# 安装中文显示(建议安装）：
# 让gnome面板、菜单显示中文 
apt-get install language-pack-gnome-zh
apt-get install language-pack-gnome-zh-base 
# 中文语言包 
apt-get install language-pack-zh
apt-get install language-pack-zh-base
# 中文语言支持
apt-get install language-support-zh
# scim中文输入法平台
apt-get install scim

# 进入图形界面： startx
# 退出图形桌面： ctrl + alt + backspace
