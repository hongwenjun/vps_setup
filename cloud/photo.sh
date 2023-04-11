# 部署 nginx-php 和 php 相册
photo_install(){
	downloads=/var/www/html

	docker run -d -p 80:80 -p 443:443  \
	    --cpus 0.6   --restart=always   \
	    -v ${downloads}:/var/www/html  \
	    --name  nginx-php      \
	    hongwenjun/nginx-php

	wget -q -O - https://262235.xyz/photo.tar.gz | tar -xzf -  -C  ${downloads}

	cd  ${downloads}
	mkdir -p _files
	chown -R www-data:www-data  _files
	chmod 0777 _files/
}

apt install curl -y
wget https://262235.xyz/wgmtu && bash wgmtu docker

photo_install

