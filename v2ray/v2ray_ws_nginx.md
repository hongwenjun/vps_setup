## V2RAY 基于 NGINX 的 VMESS+WS+TLS+Website 手工配置原理
- 短网址: https://git.io/v2ray.nginx  &nbsp;&nbsp;&nbsp; [蘭雅sRGB![](https://raw.githubusercontent.com/hongwenjun/vps_setup/master/img/youtube.png)频道](https://www.youtube.com/channel/UCupRwki_4n87nrwP0GIBUXA/videos) &nbsp;&nbsp;&nbsp;可以观看相关脚本工具的演示视频!

- 手工配置，安全可靠，可以对软件环境加深学习
- 需要先申请域名，配置DNS，安装Nginx，申请证书

### vim /etc/nginx/sites-enabled/https
```
server {
        listen 443 ssl http2;
        ssl_certificate         ss.srgb.work.crt;
        ssl_certificate_key     ss.srgb.work.key;
        ssl_protocols           TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers             HIGH:!aNULL:!MD5;
        server_name             ss.srgb.work;
        root            /var/www;

        location / {
	        proxy_redirect off;
	        proxy_http_version 1.1;
	        proxy_set_header Upgrade $http_upgrade;
	        proxy_set_header Connection "upgrade";
	        proxy_set_header Host $http_host;
	        if ($http_host = "www.baidu_bing.com" ) {
	    	    proxy_pass http://127.0.0.1:8000;
        	}
        }
}

server {
        listen 80;
        server_name ss.srgb.work;
        return 301 https://ss.srgb.work:443;
}
```
- ss.srgb.work.crt和ss.srgb.work.key为域名的证书文件，保存目录为  /etc/nginx
- nginx 反代原理: v2ray 访问服务器数据流里包含域名 www.baidu_bing.com，就代理到8000端口,而这个端口正好是v2ray的端口号


### vim /etc/v2ray/config.json
```
{
  "inbound": {
        "port": 8000,
        "listen": "127.0.0.1",
        "protocol": "vmess",
        "settings": {
          "clients": [
                {
                  "id": "a0816b69-c87f-4085-95d2-d0feda21a588",
                  "alterId": 64
                }
          ]
        },
        "streamSettings": {
          "network": "ws",
          "wsSettings": {
          "path": "/",
          "headers": {
          "Host": "www.baidu_bing.com"
          }
          }
        }
  },
  "outbound": {
        "protocol": "freedom",
        "settings": {}
  }
}
```
- 端口8000和nginx配置里对应，UUID: 可以用客户端生成修改
- Host: www.baidu_bing.com 可以自由修改，要和nginx反代配置相同

### V2ray_WS_Nginx反代 客户端设置

![](https://raw.githubusercontent.com/hongwenjun/img/master/v2ray_ws.png)

### 附: 域名申请DNS设置免费证书申请
- 国内腾讯云或阿里云申请便宜一年域名，实名认证后可以申请赛门铁克SSL一年免费证书
- [阿里云控制台首页](https://homenew.console.aliyun.com/)  [腾讯云控制台首页](https://console.cloud.tencent.com/)
- 登陆云控制台首页，点击域名管理，设置好DNS，找到免费SSL证书，申请使用

- 如果是国外申请域名，也可以使用三个月自动续签证书
- [acme协议从letsencrypt生成免费的证书](http://srgb.vicp.net/2018/11/05/acme_sh/) 简易使用脚本
```
#!/usr/bin/env sh

# https://github.com/Neilpang/acme.sh/wiki/说明

# 设置域名
DOMAIN=srgb.vicp.net


# 安装ssl依赖 和 acme.sh工具
apt-get install socat netcat -y
curl  https://get.acme.sh | sh

# 生成域名ssl证书
~/.acme.sh/acme.sh  --issue -d ${DOMAIN}  --webroot  /var/www/  --standalone -k ec-256 --force


####  生成的证书存放地方
#### /root/.acme.sh/sky.srgb.xyz_ecc/sky.srgb.xyz.cer
#### /root/.acme.sh/sky.srgb.xyz_ecc/sky.srgb.xyz.key
```

- 使用acme协议免费证书，要先配置好DNS和安装好Nginx，参数 --webroot 要按实际填写正确
```
# debian 系安装
apt -y install nginx

# centos 系安装 nginx，如果web没法访问，需要关防火墙
yum -y install vnstat nginx
systemctl enable  nginx
systemctl restart nginx

# V2Ray 官方一键脚本
bash <(curl -L -s https://install.direct/go.sh)

```
