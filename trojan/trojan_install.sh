#!/bin/bash
# Trojan傻瓜一键版  使用说明: https://git.io/trojan.help

# bash <(curl -L -s https://git.io/trojan.sh)

# Trojan Server Quickstart Script
wget -qO- https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh | bash

# 填充域名证书 公钥
cat <<EOF > /var/certificate.crt
-----BEGIN CERTIFICATE-----
MIIFqjCCBJKgAwIBAgIQDtd4Rk8unG3zLEgccybPADANBgkqhkiG9w0BAQsFADBy
MQswCQYDVQQGEwJDTjElMCMGA1UEChMcVHJ1c3RBc2lhIFRlY2hub2xvZ2llcywg
SW5jLjEdMBsGA1UECxMURG9tYWluIFZhbGlkYXRlZCBTU0wxHTAbBgNVBAMTFFRy
dXN0QXNpYSBUTFMgUlNBIENBMB4XDTE5MTEwNTAwMDAwMFoXDTIwMTEwNDEyMDAw
MFowGjEYMBYGA1UEAxMPd3d3LmxpdmU4OC50ZWNoMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAywaitw4cygx1JyWpHeXyD6+BdwSXFWXB5LkcHac9pbQO
2JR6AwEpAoRbm9qke+p8eEQmL0SZ5eH4Pai3qoIKzFeXzdA3WVw//Rex68aJWErK
O0DgPwfi8FC95gh/SUkgKP07A3o2UNDsEnx7bkIm0rjp5d9HrMDj7Het/1aW3uG6
BUCTemS2hkjutDDqCp7Ni72mavzrNNM7FhsdqW/zPQyyM22uMr9dAS64W6ywuD7g
gqjLwxprej7Du3M0SV0XXoULMjKjqJ/nTtv1a98nh4AtEML5ZnmMqwMhACKd2/MT
AQlnV6HSqZMMVi3cn2EnCrNBoJySt6qPRAs2tVhWPQIDAQABo4ICkjCCAo4wHwYD
VR0jBBgwFoAUf9OZ86BHDjEAVlYijrfMnt3KAYowHQYDVR0OBBYEFN3glaR8rYEi
aIHsuWQCRFDe8kkIMCcGA1UdEQQgMB6CD3d3dy5saXZlODgudGVjaIILbGl2ZTg4
LnRlY2gwDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEF
BQcDAjBMBgNVHSAERTBDMDcGCWCGSAGG/WwBAjAqMCgGCCsGAQUFBwIBFhxodHRw
czovL3d3dy5kaWdpY2VydC5jb20vQ1BTMAgGBmeBDAECATCBkgYIKwYBBQUHAQEE
gYUwgYIwNAYIKwYBBQUHMAGGKGh0dHA6Ly9zdGF0dXNlLmRpZ2l0YWxjZXJ0dmFs
aWRhdGlvbi5jb20wSgYIKwYBBQUHMAKGPmh0dHA6Ly9jYWNlcnRzLmRpZ2l0YWxj
ZXJ0dmFsaWRhdGlvbi5jb20vVHJ1c3RBc2lhVExTUlNBQ0EuY3J0MAkGA1UdEwQC
MAAwggEEBgorBgEEAdZ5AgQCBIH1BIHyAPAAdwCkuQmQtBhYFIe7E6LMZ3AKPDWY
BPkb37jjd80OyA3cEAAAAW47VlKtAAAEAwBIMEYCIQD/YA/eSXdzbnX1PcNVXKYT
Y3OzSzMVYRn35bxedHXsuQIhALAbQqzRZ3Ct1znLY4J5993WAsb3eLEkFITFckW/
NaQuAHUAh3W/51l8+IxDmV+9827/Vo1HVjb/SrVgwbTq/16ggw8AAAFuO1ZS6wAA
BAMARjBEAiBXjm+TehBih3yWp/gWldSj4U+lcuRfEnl8TEMMU7FZLQIgJvMuzpgx
U6Idnd+EOE6jNsZixKYJOtvXz6HSwjMqAOswDQYJKoZIhvcNAQELBQADggEBADAv
/c4AgoWum9nwVIRi+KqsZ9OeI1pZJAH1wYb8uvYRbBzJk2/Psplw6a0ka1IdngJh
QGLKqL824Hn8NKPNhAVJVzgv/gchY7hf/npj4c/OYwTmKJLnCcGW71CTlHPCilCG
b2ezB3BT4RF0FzJJrDFb5BQdSIxnKNyTD3KPICOis0Nux+FbyIQSxzoatI7km2h9
bMtw7qrqZE0/5BqhbclNQ9BsmzuYnFSvBi8k8zauWPNrXKi1RSiBSVIsTODLTZpc
jW85wOZgp9SqNbbh1zqiE/gF+8UuZoCM3BE+CiSs+AcaQUVxIisiisNUfh/x1W6j
k6yg7oAgXKabo2Py788=
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIErjCCA5agAwIBAgIQBYAmfwbylVM0jhwYWl7uLjANBgkqhkiG9w0BAQsFADBh
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMSAwHgYDVQQDExdEaWdpQ2VydCBHbG9iYWwgUm9vdCBD
QTAeFw0xNzEyMDgxMjI4MjZaFw0yNzEyMDgxMjI4MjZaMHIxCzAJBgNVBAYTAkNO
MSUwIwYDVQQKExxUcnVzdEFzaWEgVGVjaG5vbG9naWVzLCBJbmMuMR0wGwYDVQQL
ExREb21haW4gVmFsaWRhdGVkIFNTTDEdMBsGA1UEAxMUVHJ1c3RBc2lhIFRMUyBS
U0EgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCgWa9X+ph+wAm8
Yh1Fk1MjKbQ5QwBOOKVaZR/OfCh+F6f93u7vZHGcUU/lvVGgUQnbzJhR1UV2epJa
e+m7cxnXIKdD0/VS9btAgwJszGFvwoqXeaCqFoP71wPmXjjUwLT70+qvX4hdyYfO
JcjeTz5QKtg8zQwxaK9x4JT9CoOmoVdVhEBAiD3DwR5fFgOHDwwGxdJWVBvktnoA
zjdTLXDdbSVC5jZ0u8oq9BiTDv7jAlsB5F8aZgvSZDOQeFrwaOTbKWSEInEhnchK
ZTD1dz6aBlk1xGEI5PZWAnVAba/ofH33ktymaTDsE6xRDnW97pDkimCRak6CEbfe
3dXw6OV5AgMBAAGjggFPMIIBSzAdBgNVHQ4EFgQUf9OZ86BHDjEAVlYijrfMnt3K
AYowHwYDVR0jBBgwFoAUA95QNVbRTLtm8KPiGxvDl7I90VUwDgYDVR0PAQH/BAQD
AgGGMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjASBgNVHRMBAf8ECDAG
AQH/AgEAMDQGCCsGAQUFBwEBBCgwJjAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Au
ZGlnaWNlcnQuY29tMEIGA1UdHwQ7MDkwN6A1oDOGMWh0dHA6Ly9jcmwzLmRpZ2lj
ZXJ0LmNvbS9EaWdpQ2VydEdsb2JhbFJvb3RDQS5jcmwwTAYDVR0gBEUwQzA3Bglg
hkgBhv1sAQIwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29t
L0NQUzAIBgZngQwBAgEwDQYJKoZIhvcNAQELBQADggEBAK3dVOj5dlv4MzK2i233
lDYvyJ3slFY2X2HKTYGte8nbK6i5/fsDImMYihAkp6VaNY/en8WZ5qcrQPVLuJrJ
DSXT04NnMeZOQDUoj/NHAmdfCBB/h1bZ5OGK6Sf1h5Yx/5wR4f3TUoPgGlnU7EuP
ISLNdMRiDrXntcImDAiRvkh5GJuH4YCVE6XEntqaNIgGkRwxKSgnU3Id3iuFbW9F
UQ9Qqtb1GX91AJ7i4153TikGgYCdwYkBURD8gSVe8OAco6IfZOYt/TEwii1Ivi1C
qnuUlWpsF1LdQNIdfbW3TSe0BhQa7ifbVIfvPWHYOu3rkg1ZeMo6XRU9B4n5VyJY
RmE=
-----END CERTIFICATE-----


EOF


# 填充域名证书 私钥
cat <<EOF > /var/private.key
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAywaitw4cygx1JyWpHeXyD6+BdwSXFWXB5LkcHac9pbQO2JR6
AwEpAoRbm9qke+p8eEQmL0SZ5eH4Pai3qoIKzFeXzdA3WVw//Rex68aJWErKO0Dg
Pwfi8FC95gh/SUkgKP07A3o2UNDsEnx7bkIm0rjp5d9HrMDj7Het/1aW3uG6BUCT
emS2hkjutDDqCp7Ni72mavzrNNM7FhsdqW/zPQyyM22uMr9dAS64W6ywuD7ggqjL
wxprej7Du3M0SV0XXoULMjKjqJ/nTtv1a98nh4AtEML5ZnmMqwMhACKd2/MTAQln
V6HSqZMMVi3cn2EnCrNBoJySt6qPRAs2tVhWPQIDAQABAoIBAEWeyWZ/euTYX8Yk
VnlvtFGnq/wtwUdvpQ0zYw5SHsQ3Wg3v4GUuXStFSwrHb7ckgjlVmUiFPEcF9bPj
KtRYEq7e7KoBmDFW/oRiPztsUgXKY83s4dkLcclZzrzWthth7ZrQt49qNb0B36o5
MLRvD9Qb3+1ZY0E8xgv9QFf6j/LulZkjLQPNzqUL8kwgI7vQZqbT4vG15/sKCCXE
qr3gXjc2UESl5wN+gMEgHptwfLUiFNX4z8hML+kjle3ASYoirz6iQHLof1Nv7uta
M2EtpSsGR3fZO1gCZ3sFnc6nRN3GxGmDlPHZvHkjCprV7oCerxQ45kc/SrzOxiEY
jI7ezYsCgYEA5UxFTOS2URImTHsLjzR0X/A8D6vJ1olDY25oXyTWz8C+MXXo/EhN
BipBV1HnpmJKV3QWMFBIvBpE9tVxP9q68zUsC0KiDkPmKjG2RWFienNGG4cKrrCk
zo7F6f+4ZPll6uwAwxoUpT8DU+YpcHiCvLXTfFDm4jHo6rgYNxR5MicCgYEA4qsn
u9t1w/wyRRaHXzkEWQhHwK608Cxj9KjJxu+A2IlK0uH08poU4g46LQOPd0Yp6jTE
A30d+DHxqpKtuCUoWRTVCCWjrxZIZ1cyBBee63YA9XaBoQY4t7E008IquMX8iCWH
PPIjw+sMV9MWCPw2XU/+Q9TpbyifM8OSBJK2xvsCgYBe2tFkQMzm9rIfO1uJzzJB
Kdk+xlsFw9y7ukW07kFqyhojzdom2yX54esL21cP7mNAkEZJkDy2i8txrNRfjPV/
fMSOl+8AJbiGRfBX/TRG4X7kDlYt8+cJh+h5p465Pq6Zoy2hiB14Snvu7izAWSoE
NNea+sC4W9s1lhh2WKLWSwKBgDzkigoXjO2XpNGWmctk/9wDM3N5+7XB1yB076/3
y39gcq9wcGN0LUQFWm+ZU0NRoBUBE990D0cL88ZFHVIo+UvlIs3LfsucitroO9GJ
nvHWg69tpKljiH0gp/ZzZRK6bXsNyeT/j8gkLu6xEGxdhSVQRhhm7EcmfI5lbaa4
201dAoGBAK/H5jMccwjTIs3T2Kl5f8X7ThpYoQ3+ljZnUDdL7u14Pl3W3PuVjbHU
tHI933svTtXVsrpPyDxuJpIKOnWoKjuF1oRQj2tYtwHZ3CxGDRJ/7dPBntuClZ6i
bwy/jrEjwt2RLnfFi8FLZ1lY3B9YuyHYo0xN+w0KSHI7kqRtJ03L
-----END RSA PRIVATE KEY-----

EOF


# 设定证书文件名
cd /usr/local/etc/trojan/
sed -i "s/\/path\/to\/certificate.crt/\/var\/certificate.crt/g"  config.json
sed -i "s/\/path\/to\/private.key/\/var\/private.key/g"  config.json

change_passwd(){
    read -p ":: 2. 请输入 Trojan 用于验证的科学通信密码: " password1
    sed -i "s/password1/${password1}/g"  config.json
    sed -i "s/password1/${password2}/g"  config.json
    echo -e ":: 3. 科学通信密码已经修改, 验证密码: ${password1} , 客户端: config.json 也要修改密码和域名"
}

echo -e ":: 1. 是否修改 Trojan 用于验证的科学通信密码: \c" 
read -p "(Y/n): " key
case $key in
    Y)
    change_passwd
    ;;
    y)
    change_passwd
    ;;
esac

# 启动 trojan
systemctl enable trojan
systemctl restart trojan

# systemctl status trojan
ps aux | grep trojan

if [ ! -e '/var/ip_addr' ]; then
   echo -n $(curl -4 ip.sb) > /var/ip_addr
fi
myip=$(cat /var/ip_addr)

ssl_domain=www.live88.tech

RedBG="\033[41;37m"  && Font="\033[0m"  && SkyBlue="\033[0;36m"
echo
echo -e "${SkyBlue}:: Trojan傻瓜一键版${Font}  使用说明: ${RedBG} https://git.io/trojan.help ${Font}"
echo -e ":: 无需域名，编辑 C:\Windows\System32\drivers\etc\hosts 文件，添加 :${SkyBlue}  ${myip}  ${ssl_domain} ${Font}"
echo -e ":: 自有域名，参考文档申请证书下载后修改: ${SkyBlue} 公钥 /var/certificate.crt  私钥 /var/private.key  ${Font}"

