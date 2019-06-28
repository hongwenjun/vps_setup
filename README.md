# Three-in-One-Step Automated Install WireGuard Shadowsocks V2Ray on Server

```
bash <(curl -L -s https://git.io/vps.setup)
```
------
### WireGuard Install

```
# One-Step Automated Install WireGuard Script
wget -qO- https://git.io/wireguard.sh | bash

# Custom Port Install WireGuard Script, Number set Port
bash <(curl -L -s https://git.io/wireguard.sh) 9999
```

[WireGuard](https://www.wireguard.com) installer for Ubuntu 18.04 LTS, Debian 9 and CentOS 7.

This script will let you setup your own VPN server in no more than a minute, even if you haven't used WireGuard before. It has been designed to be as unobtrusive and universal as possible.

------

### shadowsocks-libev

[Shadowsocks-libev](https://shadowsocks.org) is a lightweight secured SOCKS5
proxy for embedded devices and low-end boxes.

It is a port of [Shadowsocks](https://github.com/shadowsocks/shadowsocks)
created by [@clowwindy](https://github.com/clowwindy), and maintained by
[@madeye](https://github.com/madeye) and [@linusyang](https://github.com/linusyang).

------
### Project V  (V2Ray)
Project V is a set of network tools that help you to build your own computer network. It secures your network connections and thus protects your privacy. See [our website](https://www.v2ray.com/) for more information.

```
# Easy Install Shadowsocks & V2Ray : Generate and display QR code
bash <(curl -L -s https://git.io/v2ray_ss.sh)
```
