FROM  debian
RUN   apt update -y && apt install -y  ca-certificate supervisor wget    \
  &&  wget https://raw.githubusercontent.com/hongwenjun/vps_setup/master/pt/start.sh  \
  &&  wget https://raw.githubusercontent.com/hongwenjun/vps_setup/master/pt/goseeder.conf  \  
  &&  wget https://raw.githubusercontent.com/hongwenjun/vps_setup/master/pt/supervisord.conf  \ 
  &&  wget https://github.com/nickfox-taterli/goseeder/releases/download/v1.1/gostat   \
  &&  wget https://github.com/nickfox-taterli/goseeder/releases/download/v1.1/goseeder  \
  &&  chmod +x  /start.sh   &&   chmod +x goseeder   &&   chmod +x gostat  \
  &&  ln -s  /goseeder.conf      /etc/goseeder.conf   \
  &&  ln -s  /supervisord.conf   /etc/supervisord.conf \
  &&  mv /goseeder  /usr/bin/goseeder  &&  mv /gostat  /usr/bin/gostat
 

CMD ["/start.sh"]
