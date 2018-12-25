# WireGuard  测试配置实例

### TunSafe 导入客户配置连接后，浏览器访问  http://10.0.0.1  或者  http://ip111.cn/
可以访问或者检测出你当前IP地址，表示软件设置没问题，*测试服务器只测试连接，不提供翻墙服务*

### cat /etc/wireguard/wg_VM-0-13-debian_3.conf   WireGuard直连配置
```
[Interface]
PrivateKey = aMWVZ78fCeOG1e0ljJ06cvHqyXVqbfsEw4pZz+TNW24=
Address = 10.0.0.3/24
DNS = 8.8.8.8

[Peer]
PublicKey = 7+lLY7yN97cbwe/OkNR4pyHuX/uCiVc/maPrneVcHg8=
Endpoint = 118.24.232.233:8000
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25
```

### cat /etc/wireguard/wg0.conf    WireGuard 服务端配置文件实例
```
[Interface]
PrivateKey = cFNf5sTNOXnPygDEuSD8kJ8NlisBY4OOxR/tBpJ7+Ws=
Address = 10.0.0.1/24
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = 8000
DNS = 8.8.8.8
MTU = 1420

[Peer]
PublicKey = p4L8R4YutqtSq64pAmOclcdqdo0e1Jo5lTQh0Um8BH4=
AllowedIPs = 10.0.0.218/32

[Peer]
PublicKey = c1R+xHfGweOAotOQNdcqeMlFHzG8L6oNp8ai/MARQik=
AllowedIPs = 10.0.0.2/32

[Peer]
PublicKey = /cHDZfLZm8OLPiPjMxhlA8U+sd1tOPwf6qXhpm38dQI=
AllowedIPs = 10.0.0.3/32

```
