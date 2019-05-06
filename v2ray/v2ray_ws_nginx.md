# V2RAY 基于 NGINX 的 VMESS+WS+TLS+Website 手工配置原理
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
- 端口8000和nginx配置里对应，UUID: a0816b69-c87f-4085-95d2-d0feda21a588
- Host: www.baidu_bing.com 可以自由修改，要和nginx反代配置相同

### V2ray_WS_Nginx反代 客户端设置

![](https://raw.githubusercontent.com/hongwenjun/img/master/v2ray_ws.png)
