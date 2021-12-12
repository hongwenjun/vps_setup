#  Python安装 MySQL Connector 驱动程序，访问 MySQL 数据库和查询修改 WordPress 博客文章
#  https://262235.xyz/index.php/archives/707/

import mysql.connector

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  passwd="yourpassword"
)

## 使用 `SHOW DATABASES` 语句列出系统中的所有数据库
c = mydb.cursor()
c.execute("SHOW DATABASES")
for x in c:
    print(x)

## WordPress 存放文章的数据表名 wp_posts，使用 SELECT 查询博客的文章
c = mydb.cursor()
c.execute("USE wordpress")
c.execute("SELECT * FROM wp_posts LIMIT 5")
result = c.fetchall()
for x in result:
  print(x)

### 选取列-只选择表中的某些列，请使用 "SELECT" 语句，后跟列名
c.execute("SELECT ID, post_title, guid, post_type  FROM wp_posts LIMIT 5")
result = c.fetchall()
for x in result: print(x)

### 用 fetchall() 方法，该方法从最后执行的语句中获取所有行
### 如果只需一行或者逐行，可以使用 fetchone() 方法, 将返回结果的第一行
c.execute("SELECT ID, post_title, guid, post_type  FROM wp_posts LIMIT 5")
result = c.fetchone()
print(result)
result = c.fetchone();  print(result)

### WordPress文章内容批量替换文字的方法 更新表: 使用 UPDATE 语句来更新表中的现有记录  
sql = "UPDATE wp_posts SET post_content = replace(post_content,'nginx','nginx-php')"
c.execute(sql)
mydb.commit()
print(c.rowcount, "record(s) affected")
