## Trojan傻瓜一键版，没有域名也可以测试学习

	bash <(curl -L -s https://git.io/trojan.sh)

### 下载 trojan windows 客户端

- https://github.com/trojan-gfw/trojan/releases/download/v1.13.0/trojan-1.13.0-win.zip

- Windows版需要安装 vc_redist.x64.exe (Visual C++ Redistributable for VS 2015)

- https://aka.ms/vs/16/release/vc_redist.x64.exe

###  Start_Trojan.zip 使用C/C++语言编译生成的简易启动器

- 和trojan.exe官方程序放一起使用；源码见压缩包

#### 编辑 本地客户端 config.json 文件

- example.com 改成 ssl.srgb.work ; 再修改 trojan 验证密码

### Chrome 浏览器设置，使用SwitchyOmega插件，方法同SS和Brook

- 代理协议 SOCKS5 地理服务器 127.0.0.1 代理端口 1080


### 编辑本地域名管理文件

- C:\Windows\System32\drivers\etc\hosts

### 添加本地域名管理 (按实际IP修改)

	188.188.188.188  ssl.srgb.work

----------

## 如果你有自己的域名证书，替换密钥后重启服务
- 公钥: /var/certificate.crt
- 私钥: /var/private.key
```
# 重启 trojan
systemctl restart trojan

# 查看 trojan
systemctl status trojan
```
