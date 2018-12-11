#!/bin/bash

#  Google Cloud Platform  GCP实例开启密码与root用户登陆
#  

# 修改root 密码
passwd

# GCP 启用root密码登陆
sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g"   /etc/ssh/sshd_config
sed -i "s/PasswordAuthentication.*/PasswordAuthentication yes/g"   /etc/ssh/sshd_config

# 重启ssh服务
systemctl restart ssh
