### 申请个人专用IPv6地址范围  https://simpledns.com/private-ipv6

- 这是一个专门为您生成的唯一私有IPv6地址范围（刷新页面以获取另一个）：
```
前缀/ L：fd
全球ID：08620c4df0
子网ID：65eb
Combined /CID：fd08:620c:4df0:65eb::/64
IPv6地址：fd08:620c:4df0:65eb:xxxx:xxxx:xxxx:xxxx
```
```
Prefix/L:	  fd
Global ID:	  08620c4df0
Subnet ID:	  65eb
Combined/CID:	  fd08:620c:4df0:65eb::/64
IPv6 addresses:	  fd08:620c:4df0:65eb:xxxx:xxxx:xxxx:xxxx

```

- 如果您有多个位置/站点/网络，则应为每个位置/站点/网络分配不同的“子网ID”，但对所有这些都使用相同的“全局”ID。

- IPv6地址空间如此巨大（2的128次方），每个人都应该能够获得他们将拥有的每个设备的公共IP地址。因此理论上，没有必要拥有私有IPv6地址，如IPv4中的192.168.x.x和10.x.x.x地址。

- 但是，在您实际从ISP获得IPv6地址范围之前，您可能希望将“私有”地址用于内部网络和测试等。
在IPv6中，有一个特殊的“Unique Unicast”IP范围fc00::/7 ，根据RFC4193应该使用它。

### 官方定义如下：

```

| 7 bits |1|  40 bits   |  16 bits  |          64 bits           |
+--------+-+------------+-----------+----------------------------+
| Prefix |L| Global ID  | Subnet ID |        Interface ID        |
+--------+-+------------+-----------+----------------------------+
```

实际上，这样的地址总是以“fd”开头，因为第8位（L）必须是1。
“全局ID”和“子网ID”必须是随机的，以确保唯一性（这是本页的作用）。
您可以自由分配其余地址（接口ID）。

### 请注意：
以前的标准提出在fec0::/10范围内使用所谓的“站点本地”地址。
这已被弃用（请参阅RFC3879），不应再使用。

### https://simpledns.com/private-ipv6
![](https://raw.githubusercontent.com/hongwenjun/img/master/private_ipv6.png)
