### Issues 图片专用

###  IPTABLES 设置防火墙规则 脚本 By 蘭雅sRGB 特别感谢 TaterLi 指导

```
# 下载使用命令 或者 原bash wgmtu 选6 升级脚本后使用
wget -qO safe_iptables.sh  git.io/fhJrU && bash safe_iptables.sh

# Debian 和 Centos 关闭防火墙命令分别是
iptables -F  && iptables-save > /etc/iptables/rules.v4
iptables -F  && service iptables save

```
![](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/iptables_wg.png)

### 测试新的路由防火墙规则
```
# 修改 /etc/wireguard/wg0.conf 的 iptables规则语句
PostUp   = iptables -I FORWARD -i wg0 -j ACCEPT; iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
```

### cat /etc/wireguard/wg0.conf  服务端配置示例
```
[Interface]
PrivateKey = $PrivateKey
Address = 10.0.0.1/24
PostUp   = iptables -I FORWARD -i wg0 -j ACCEPT; iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
ListenPort = $ListenPort
DNS = 8.8.8.8
MTU = 1500

[Peer]
PublicKey = $PublicKey
AllowedIPs = 10.0.0.8/32
```
![](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/wg_RELATED_ESTABLISHED.png)
