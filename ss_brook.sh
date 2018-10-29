#!/bin/bash
wget -O ss_brook.tgz  https://git.io/fxQuY
tar -xzvf ss_brook.tgz  -C /
rm ss_brook.tgz

systemctl enable frps
systemctl enable brook
systemctl enable shadowsocks-go

/etc/init.d/frps start
/etc/init.d/brook start
/etc/init.d/shadowsocks-go start
