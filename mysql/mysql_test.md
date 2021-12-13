![mysql.webp][1]
## 使用Docker部署MYSQL和建立数据表，使用php远程访问学习示例

### 命令: vim `docker-compose.yml`  # 建立 `docker-compose` 部署文件

```
version: '3.1'
services:
  db:
    image: mysql
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: test-mysql@2022
    ports:
      - 53306:3306

  adminer:
    image: adminer
    restart: always
    ports:
      - 10086:8080
```

### 使用 `linuxserver/docker-compose` 部署 MYSQL 和 adminer 服务

```
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PWD:$PWD" \
  -w="$PWD" \
  linuxserver/docker-compose \
  up
```

### 部署完成，浏览器访问  `http://ip:10086` 登陆管理建立数据库

- 可以web-ui建立数据库和添加用户，也可以使用执行 sql 命令完成创建用户

```
# 创建数数据库: world
CREATE DATABASE `world` COLLATE 'utf8mb4_bin';

# 创建用户密码
CREATE USER 'test'@'%' IDENTIFIED BY 'NSbgs4Z8nYAnqhW';

# 修改用户密码
SET PASSWORD FOR 'test'@'localhost' = 'test@localhost';

# 修改远程链接的用户
CREATE USER 'test22'@'%' IDENTIFIED BY 'NSbgs4Z8nYAnqhW';
GRANT ALL PRIVILEGES ON `world`.* TO 'test22'@'%';
```
SQL命令中的 'test22'@'%' 可以这样理解: test22是用户名，%是主机名或IP地址，这里的%代表任意主机或IP地址，
你也可替换成任意其它用户名或指定唯一的IP地址；'MyPassword'是给授权用户指定的登录数据库的密码

![111.png][2]

### `CREATE TABLE` 创建 `City` 数据表，如果已经存在，使用 `DROP TABLE` 先删除

```
# DROP TABLE IF EXISTS `City`; 
CREATE TABLE `City` ( `ID` int, `Name` text, `CountryCode` text,
`District` text, `Population` int );
```

### `INSERT INTO` 向 `City` 数据表插入数据，或者使用备份的出来的数据导入 `City.sql.gz` [下载](https://github.com/hongwenjun/vps_setup/raw/remove/mysql/City.sql.gz)
- `City.sql.gz` [下载](https://github.com/hongwenjun/vps_setup/raw/remove/mysql/City.sql.gz)

```
INSERT INTO `City` (`ID`, `Name`, `CountryCode`, `District`, `Population`) VALUES
(1,	'Kabul',	'AFG',	'Kabol',	1780000),
(2,	'Qandahar',	'AFG',	'Qandahar',	237500),
(3,	'Herat',	'AFG',	'Herat',	186800),
(4,	'Mazar-e-Sharif',	'AFG',	'Balkh',	127800),
(5,	'Amsterdam',	'NLD',	'Noord-Holland',	731200),

(4078,	'Nablus',	'PSE',	'Nablus',	100231),
(4079,	'Rafah',	'PSE',	'Rafah',	92020);

```

## 使用php远程访问学习示例  

### 在建立php环境的机器上，使用命令行测试

```
docker exec -it  nginx-php bash
php -a

$link = mysqli_connect("18.18.18.18", "test22", "NSbgs4Z8nYAnqhW", "world","53306");
$result = mysqli_query($link, "SELECT * FROM City LIMIT 10");
$rows = mysqli_fetch_all($result); 
var_dump($rows);

```

![test.php.png][3]

### `test.php` 源码, 演示站 https://262235.xyz/test/test.php  (php服务国内，mysql在美西)

```
<?php
// $link = mysqli_connect("localhost", "my_user", "my_password", "world");
$link = mysqli_connect("18.18.18.18", "test22", "NSbgs4Z8nYAnqhW", "world","53306");

/* check connection */
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}

/* Create table doesn't return a resultset */
if (mysqli_query($link, "CREATE TEMPORARY TABLE myCity LIKE City") === TRUE) {
    printf("Table myCity successfully created.\n");
}

/* Select queries return a resultset */
if ($result = mysqli_query($link, "SELECT * FROM City LIMIT 10")) {
  printf("Select returned %d rows.\n", mysqli_num_rows($result));

  $rows = mysqli_fetch_all($result, MYSQLI_ASSOC); 
  var_dump($rows);

  /* free result set */
  mysqli_free_result($result);
}

$result = mysqli_query($link, "SELECT * FROM City LIMIT 10");
$rows = mysqli_fetch_all($result); 
var_dump($rows);

mysqli_close($link);
?>
```


  [1]: https://262235.xyz/usr/uploads/2021/12/1342246453.webp
  [2]: https://262235.xyz/usr/uploads/2021/12/1011972683.png
  [3]: https://262235.xyz/usr/uploads/2021/12/925080225.png
