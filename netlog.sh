#!/usr/bin/env bash

echo '<pre>' > /var/www/log/index.html

vnstat -u

vnstat -m >> /var/www/log/index.html
vnstat -d >> /var/www/log/index.html
vnstat -h >> /var/www/log/index.html


######################################

######################################
