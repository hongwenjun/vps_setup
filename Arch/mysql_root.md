## Arch linux 安装 mysql 没有默认数据库，要先初始化
```
mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
```

## mysql root 帐户没有密码没法登陆操作
```
systemctl stop mysql
mysqld_safe --skip-grant-tables &
mysql -uroot
```

## 完整代码解决方案(arch linux 部分适用)
```
Full code solution
1. run bash commands
1. first, run these bash commands

sudo /etc/init.d/mysql stop # stop mysql service
sudo mysqld_safe --skip-grant-tables & # start mysql without password
# enter -> go
mysql -uroot # connect to mysql

2. then run mysql commands => copy paste this to cli manually

use mysql; # use mysql table
update user set authentication_string=PASSWORD("") where User='root'; # update password to nothing
update user set plugin="mysql_native_password" where User='root'; # set password resolving to default mechanism for root user

flush privileges;
quit;

3. run more bash commands

sudo /etc/init.d/mysql stop 
sudo /etc/init.d/mysql start # reset mysql
# try login to database, just press enter at password prompt because your password is now blank
mysql -u root -p 

4. Socket issue (from your comments)
When you see a socket error, a community came with 2 possible solutions:

sudo mkdir -p /var/run/mysqld; sudo chown mysql /var/run/mysqld
sudo mysqld_safe --skip-grant-tables &
(thanks to @Cerin)

Or

mkdir -p /var/run/mysqld && chown mysql:mysql /var/run/mysqld  
(thanks to @Peter Dvukhrechensky)

``
