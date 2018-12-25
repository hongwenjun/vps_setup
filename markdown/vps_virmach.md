---
title: VirMach 最便宜的主机折腾
date: 2018-6-15
tags:  [vps]
---

蘭雅sRGB 龙芯小本服务器 [http://sRGB.vicp.net](http://srgb.vicp.net)

	
### Virmach 低价屠夫，$0.7/月,一年7.5美元，有促销可能更加便宜

官方购买地址 [https://billing.virmach.com/cart.php?gid=1](https://billing.virmach.com/cart.php?gid=1)

也可以搜索 Virmach + 优惠码，从国内vps介绍网站入口进去

选择 OpenVZ Linux VPS，
 
### Micro+
- 192MB RAM
- 10GB Disk
- 250GB Bandwith @ 1 Gbps
- Shared Intel HT CPU 1 Core @ 1GHz
- 1x IPv4 Addresses

### 价格是 $1.00 USD Monthly

点 Order NoW 蓝色按钮就去， 看到 Billing Cycle 结算方式

- Order annually to get 2 months of free service ; only pay for 10 months!
- (整年定购只需支付10个月，赠2个月免费服务!)

- $1.00 USD Mothly
- $2.75 USD Quarterly
- $10.00 USD Annually  通过下拉框选择，1年，打折后是7.5美元

- 服务器选择有存货，选Los Angeles(洛杉矶)，或美西的效果会好点
- 操作系统选 Debian ，下拉选择Debian 8 X64 或者9 X64

- 特价产品要勾选 Limited Support Agreement  (有限支持协议)，不然没法加入购物车

### 加入购物车后，去开启隐藏的 优惠码 填入栏

购物车页面:

[https://billing.virmach.com/cart.php?a=view](https://billing.virmach.com/cart.php?a=view)

- 以下以Chrome 浏览器介绍 开启隐藏的 优惠码 填入栏
- F12 开启调试,键盘ctrl+F 查找 couponform ，定位到一下HTML语句

```html
<form method="post" action="/cart.php?a=view" class="form-horizontal well well-sm" id="couponform" style="display:none;">
```
- 修改样式 display:none ，改成 yes，就会出现隐藏的优惠码输入框

- 还有另一种 开启隐藏的 优惠码 填入栏 方法

	键盘 上上下下左右左右BA

### 支付方式可以选支付宝或者paypal
因为是特价机型，不能退款，换IP是要钱的

### 然后就安装些  一键全家桶，先慢慢折腾了
安装加速后，可以看1080P

	https://github.com/hongwenjun/srgb/tree/master/vps_setup