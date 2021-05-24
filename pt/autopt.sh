cp  goseeder.conf   /etc/goseeder.conf

curl https://raw.githubusercontent.com/nickfox-taterli/goseeder/master/goseeder.service > /etc/systemd/system/goseeder.service
curl -L https://github.com/nickfox-taterli/goseeder/releases/download/v1.1/goseeder > /usr/local/bin/goseeder
chmod a+x /usr/local/bin/goseeder
systemctl start goseeder
systemctl enable goseeder

echo  "#  vim /etc/goseeder.conf"
echo  "#  systemctl restart goseeder"
echo  "#  systemctl status goseeder"
echo  "#  cat /var/log/syslog | grep 种子"
