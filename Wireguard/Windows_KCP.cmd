@echo.
@set PATH=%~dp0;%PATH%
@start /b kcp-client -r "127.0.0.1:4000" -l ":3322" -mode fast2 -mtu 1300
@start /b udp2raw -c -r64.52.108.120:8855 -l0.0.0.0:4000 -k"passwd" --raw-mode faketcp


