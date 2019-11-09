#!/bin/bash
# Trojan傻瓜一键版  使用说明: https://git.io/trojan.help

# bash <(curl -L -s https://git.io/trojan.sh)

# Trojan Server Quickstart Script
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)"

# 填充域名证书 公钥
cat <<EOF > /var/certificate.crt

-----BEGIN CERTIFICATE-----
MIIFfzCCBGegAwIBAgIQB5jh56HhIXEP8XgbnpjRJTANBgkqhkiG9w0BAQsFADBu
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMS0wKwYDVQQDEyRFbmNyeXB0aW9uIEV2ZXJ5d2hlcmUg
RFYgVExTIENBIC0gRzEwHhcNMTkwNTA2MDAwMDAwWhcNMjAwNTA1MTIwMDAwWjAY
MRYwFAYDVQQDEw1zc2wuc3JnYi53b3JrMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEArZrlncfqFs45BncbMtGt5A5lCXY2I3alkX07EMLFlPgtWlvEq/bw
LFbWf6SHPTJtnIqMkWxJ8RyGmkMv+4+oNN3A0liGqAHONpLAkJoLx9YGZ7GCJ4qg
oeTP/8i9hn5A5XZ+BvAYScptgOVzKEzk4/r+cQixSaJ25A/3wLcU1ny0t1z+ytLS
XaS+WRsPnBmfImBeASGc5RdUrZjC1UH+oaqYFw9Jt+TZeSfy0kOy8FAJ7cvcSFYT
jujIFSwYTKtosiIWaVpzxVmaCibzOYhyCeM5KZLmYR5wh0IflxZVlT/iEsT1eXfq
3jFW1+eo9X1f6nHZbIq0Ev49vut3zlcpAQIDAQABo4ICbTCCAmkwHwYDVR0jBBgw
FoAUVXRPsnJP9WC6UNHX5lFcmgGHGtcwHQYDVR0OBBYEFJfpVsxT94q6C7987lGi
ioZV4igEMBgGA1UdEQQRMA+CDXNzbC5zcmdiLndvcmswDgYDVR0PAQH/BAQDAgWg
MB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjBMBgNVHSAERTBDMDcGCWCG
SAGG/WwBAjAqMCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20v
Q1BTMAgGBmeBDAECATB9BggrBgEFBQcBAQRxMG8wIQYIKwYBBQUHMAGGFWh0dHA6
Ly9vY3NwLmRjb2NzcC5jbjBKBggrBgEFBQcwAoY+aHR0cDovL2NhY2VydHMuZGln
aWNlcnQuY29tL0VuY3J5cHRpb25FdmVyeXdoZXJlRFZUTFNDQS1HMS5jcnQwCQYD
VR0TBAIwADCCAQQGCisGAQQB1nkCBAIEgfUEgfIA8AB2AO5Lvbd1zmC64UJpH6vh
nmajD35fsHLYgwDEe4l6qP3LAAABao061Q8AAAQDAEcwRQIgYOHwX3lV8drt0zEF
OTvxV1jgCUoSBM/zN3Z6otWWC0ACIQDeVrChmdb8oR+ZXj5mTuBd1RrmDt5ODhEH
CBdzuBf2/QB2AF6nc/nfVsDntTZIfdBJ4DJ6kZoMhKESEoQYdZaBcUVYAAABao06
1KcAAAQDAEcwRQIhANSpKueltgW53eLn5n2XRJdFAsGpggrUCeJU+CLZgsKYAiAg
LieAuncxZjXedGQF2tuo1m9+rwxPeKK3X58GFhinXTANBgkqhkiG9w0BAQsFAAOC
AQEAlCZw83lNAWendvTDprIT5xhLiBe/HFD81ivyddP6/7wzrnblRgT0WJVsFBmO
Obkkk+jFTzrGFy7HRtb5S7poCFyrClyO2iv/rR89s4B8dI6fr0snsGQRSmDzBz8t
9gDG35pt509PDRUpUZtA4EcRRezW8Ly0VajFt7gT3puaTEkgpKci8BQjk7F7sc2n
PwziJqFFEHnkCl2W0b5lyCqRV1sh/Pg6lBtBTeeyA5dpT4C9zTOAgGv1wG8OVbYY
GysqJMkbmcxczzb/cyuzVPflu0H1GyyPgGqygZMbr6IX33I+RVQQKQdASZnEt/Gv
Pv01XTkZXiFHPSnFTDLc74mr9w==
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIEqjCCA5KgAwIBAgIQAnmsRYvBskWr+YBTzSybsTANBgkqhkiG9w0BAQsFADBh
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMSAwHgYDVQQDExdEaWdpQ2VydCBHbG9iYWwgUm9vdCBD
QTAeFw0xNzExMjcxMjQ2MTBaFw0yNzExMjcxMjQ2MTBaMG4xCzAJBgNVBAYTAlVT
MRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5j
b20xLTArBgNVBAMTJEVuY3J5cHRpb24gRXZlcnl3aGVyZSBEViBUTFMgQ0EgLSBH
MTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALPeP6wkab41dyQh6mKc
oHqt3jRIxW5MDvf9QyiOR7VfFwK656es0UFiIb74N9pRntzF1UgYzDGu3ppZVMdo
lbxhm6dWS9OK/lFehKNT0OYI9aqk6F+U7cA6jxSC+iDBPXwdF4rs3KRyp3aQn6pj
pp1yr7IB6Y4zv72Ee/PlZ/6rK6InC6WpK0nPVOYR7n9iDuPe1E4IxUMBH/T33+3h
yuH3dvfgiWUOUkjdpMbyxX+XNle5uEIiyBsi4IvbcTCh8ruifCIi5mDXkZrnMT8n
wfYCV6v6kDdXkbgGRLKsR4pucbJtbKqIkUGxuZI2t7pfewKRc5nWecvDBZf3+p1M
pA8CAwEAAaOCAU8wggFLMB0GA1UdDgQWBBRVdE+yck/1YLpQ0dfmUVyaAYca1zAf
BgNVHSMEGDAWgBQD3lA1VtFMu2bwo+IbG8OXsj3RVTAOBgNVHQ8BAf8EBAMCAYYw
HQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMBIGA1UdEwEB/wQIMAYBAf8C
AQAwNAYIKwYBBQUHAQEEKDAmMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdp
Y2VydC5jb20wQgYDVR0fBDswOTA3oDWgM4YxaHR0cDovL2NybDMuZGlnaWNlcnQu
Y29tL0RpZ2lDZXJ0R2xvYmFsUm9vdENBLmNybDBMBgNVHSAERTBDMDcGCWCGSAGG
/WwBAjAqMCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BT
MAgGBmeBDAECATANBgkqhkiG9w0BAQsFAAOCAQEAK3Gp6/aGq7aBZsxf/oQ+TD/B
SwW3AU4ETK+GQf2kFzYZkby5SFrHdPomunx2HBzViUchGoofGgg7gHW0W3MlQAXW
M0r5LUvStcr82QDWYNPaUy4taCQmyaJ+VB+6wxHstSigOlSNF2a6vg4rgexixeiV
4YSB03Yqp2t3TeZHM9ESfkus74nQyW7pRGezj+TC44xCagCQQOzzNmzEAP2SnCrJ
sNE2DpRVMnL8J6xBRdjmOsC3N6cQuKuRXbzByVBjCqAA8t1L0I+9wXJerLPyErjy
rMKWaBFLmfK/AHNF4ZihwPGOc7w6UHczBZXH5RFzJNnww+WnKuTPI0HfnVH8lg==
-----END CERTIFICATE-----

EOF


# 填充域名证书 私钥
cat <<EOF > /var/private.key

-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEArZrlncfqFs45BncbMtGt5A5lCXY2I3alkX07EMLFlPgtWlvE
q/bwLFbWf6SHPTJtnIqMkWxJ8RyGmkMv+4+oNN3A0liGqAHONpLAkJoLx9YGZ7GC
J4qgoeTP/8i9hn5A5XZ+BvAYScptgOVzKEzk4/r+cQixSaJ25A/3wLcU1ny0t1z+
ytLSXaS+WRsPnBmfImBeASGc5RdUrZjC1UH+oaqYFw9Jt+TZeSfy0kOy8FAJ7cvc
SFYTjujIFSwYTKtosiIWaVpzxVmaCibzOYhyCeM5KZLmYR5wh0IflxZVlT/iEsT1
eXfq3jFW1+eo9X1f6nHZbIq0Ev49vut3zlcpAQIDAQABAoIBAQCQ84RE+Wa7I/T5
MPnEtM48XMh/3fPWKHqVv7pRhE7000MK7xSHgOeIHfl7GiTRNAnRat1zjrcuWmMI
6pBlusz3VzBocQH9xYQojN+73ON5N3qhmdTSryzv/9yr9TBJ26DT9tvDbzTYZ+yG
cw5z18BFmoxYVKmykbQzOCHlBvifHJo5BYegD6UAgchLtz4N8pQMuLHJPGUUgJC6
5iwyUnv+4nS6KabmXCIZKou4VNYAzfBvvNJObb756N5DE5beu40G4aotT45UQ8iE
5rvwSXw+KB6rTlVnMElUIvPI8mY/hoV+BlZEqPr2Ei4DM8rxMmuu3IG8uBvh1EWA
HvDZxUABAoGBAP9zbYpAH8NVXN8EihNXPIyF0KpznrI3Y63lrNL7VDzKVhs5EjMQ
zBFFiAFiRO9QnN9KD87uR3diMSEqwDRQuONAsjOkIOaO2IAo3k2t2tDSZvFjolll
FqJJRCQzETHB25rxOo51PjDdLclRhaxSMK/Xsl+OUU1+bVzS6XEaw49xAoGBAK36
bhrXPaoNyccDufWoV1/dLOa+ZkFuDLP5925jqniz20hV6XjJN0hmw//yFqZ6tCJE
Tw4yiLVwf4xckJjlGwl5TYXhstXNn85jAke4kK10/rDG7UD7Z7Dg91uY1oKBvceP
Ej3x9vVxO6yQZ5wNmrM2CmbjCyz4pQ4Jx2k+QIqRAoGBALXJQNS3mWL6ZmLW6iOl
WxNtTvdd3DtbK3ZfEcP60xGHtAsfbBInC/Hml0jU09WyelB0dhd+fiE5IVlHAQy5
vTkLm0UgscEhOnTJoJmK9ULR2CxECQ6w35CRrwpLxRqxqEP1EwS57o37eE/h0cy1
mKwqRWe28ajCJbV+6l1w/GYhAoGACWXBlMmTlx/vikR1QwO41IDJ8BzQwTAEl6Qk
7V2M08BDVADv/4o+5jZG2AhnmM5/9GnkK0wnfkV5XkeRt/CIKVbYDSdH1aypuSg3
80/Q4M21BC96mUv7Kd68/cGftKT1b1YXEimDwXZAVu3l6tQBSzTcEvqom+FCaSO2
FcU7D0ECgYB1hvK6BAhBqkau94fDVdG1MQ58cIqcb/FM2m1ZO0kYvwXHie9GG8N2
qqZuq1EX0oPlQtsW6NzSwGJw5nR3+Bao0vw2ubWOR14ZKNqeNrdDH6EJwHON1Ell
GbtNmdbxUImyGHkLR/chUl5pnKI1kZMK9hSQbRuRHcTbqR9qmDH9CQ==
-----END RSA PRIVATE KEY-----

EOF


# 设定证书文件名
cd /usr/local/etc/trojan/
sed -i "s/\/path\/to\/certificate.crt/\/var\/certificate.crt/g"  config.json
sed -i "s/\/path\/to\/private.key/\/var\/private.key/g"  config.json

change_passwd(){
    read -p ":: 1. 请输入 Trojan 用于验证的 1号密码: " password1
    read -p ":: 2. 请输入 Trojan 用于验证的 2号密码: " password2
    sed -i "s/password1/${password1}/g"  config.json
    sed -i "s/password2/${password2}/g"  config.json
    echo -e ":: 验证的密码已经修改, 1号密码: ${password1}  2号密码: ${password2}"
}

echo -e ":: 是否修改 Trojan 用于验证的密码: \c"  passwd
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

myip=$(cat /var/ip_addr)
ssl_domain=ssl.srgb.work

RedBG="\033[41;37m"  && Font="\033[0m"  && SkyBlue="\033[0;36m"
echo
echo -e "${SkyBlue}:: Trojan傻瓜一键版${Font}  使用说明: ${RedBG} https://git.io/trojan.help ${Font}"
echo -e ":: 编辑 C:\Windows\System32\drivers\etc\hosts 文件，添加 :${SkyBlue}  ${myip}  ${ssl_domain} ${Font}"


