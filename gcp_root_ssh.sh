#!/bin/bash

#  Google Cloud Platform  GCP实例开启密码与root用户登陆

#  GCP一键启用root帐号命令
#  wget -qO- git.io/fpQWf | bash

# GCP 启用root密码登陆
sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g"   /etc/ssh/sshd_config
sed -i "s/PasswordAuthentication.*/PasswordAuthentication yes/g"   /etc/ssh/sshd_config

# 重启ssh服务
systemctl restart ssh

#定义文字颜色
Green="\033[32m"  && Red="\033[31m" && GreenBG="\033[42;37m" && RedBG="\033[41;37m" && Font="\033[0m"

# 修改root 密码: bash脚本不能直接运行passwd，用户手工使用命令
echo -e "${Red}如果需要修改root密码，请输入命令${GreenBG} passwd ${Font}${Green} 修改用户密码! ${Font}"
echo
