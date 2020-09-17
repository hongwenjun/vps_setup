#########   Debain config.sh  ###########
#!/bin/bash

en_US()
{
	cat <<EOF >/etc/default/locale
LANG=en_US.UTF-8
EOF
	echo -e "Please log in again on Debian tty1"
}

zh_CN()
{
	cat <<EOF >/etc/default/locale
# 中文显示
LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:zh"
EOF

	echo -e "Please log in again on Debian tty1"
}

autonet()
{
# 自动修改interfaces 网卡自动加载
lspci | grep Ethernet
ni=$(ip addr | grep enp | head -n 1 | awk -F ': '  '{print $2}')
sed -i "s/enp[a-zA-Z0-9]*/${ni}/g"  /etc/network/interfaces
ifup $ni

}

# 设置菜单
start_menu()
{
    echo -e ":: DEBIAN LOCALE LANGUAGE SETTINGS & Modify Interfaces"
    read -p ":: Please enter the number <1>:English  <2>:Chinese :: <8> AutoModify Interfaces  "  num_x
    case "$num_x" in
        1)
        en_US
        ;;
        2)
        zh_CN
        ;;
        8)
        autonet
        ;;
		esac
}
start_menu

#################################################

