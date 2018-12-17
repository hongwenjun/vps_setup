#!/bin/bash

# 一键Debian安装Gnome脚本
#  wget -qO- git.io/fpATt | bash

# Debian安装Gnome桌面脚本
apt update
apt install -y x-window-system-core
apt install -y gnome-core

# 安装中文显示(建议安装）：
# 让gnome面板、菜单显示中文 
apt-get install -y language-pack-gnome-zh
apt-get install -y language-pack-gnome-zh-base 
# 中文语言包 
apt-get install -y language-pack-zh
apt-get install -y language-pack-zh-base
# 中文语言支持
apt-get install -y language-support-zh
# scim中文输入法平台
apt-get install -y scim

# 进入图形界面： startx
# 退出图形桌面： ctrl + alt + backspace
