@echo.
@set PATH=%~dp0;%PATH%
@start /b udp2raw -c -r35.220.201.249:8855 -l0.0.0.0:9009 -k"passwd" --raw-mode faketcp
