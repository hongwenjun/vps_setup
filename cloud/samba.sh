install_samba()
{
	# 安装和设置 samba
	apt update -y && apt install samba -y
	mkdir -p /var/www/html/u
	chown -R nobody:nogroup /var/www/html/u

	cat <<EOF >/etc/samba/smb.conf
[global]
   workgroup = WORKGROUP
   max log size = 1000
   logging = file
   panic action = /usr/share/samba/panic-action %d
   server role = standalone server
   obey pam restrictions = yes
   unix password sync = yes

   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .

   pam password change = yes
   map to guest = bad user
   usershare allow guests = yes

[homes]
   comment = Home Directories
   browseable = no
   read only = yes
   create mask = 0700
   directory mask = 0700
   valid users = %S

[cloud]
   comment = Network Logon Service
   path = /var/www/html/u
   guest ok = yes
   read only = no

EOF

	systemctl restart smbd.service

}

install_samba

