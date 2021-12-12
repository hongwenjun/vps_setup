# 使用sql数据表保存脚本代码文件
# Python脚本从数据库里上传和下载代码文件

![sql表格][1]
学习Python脚本和SQL数据库使用，为了保持多设备代码的版本同步，折腾把脚本代码保存到SQL数据表中。
方便一起备份，用到方便更新，也可以再写个批量插入文件和更新文件脚本，网页端读取使用。
## 可以使用图形工具软件，连数据库建立表
- 表 vps2022.text 结构
```
CREATE TABLE IF NOT EXISTS `text` (
  `name` text,
  `text` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

## 获取sql数据表 text 中所有脚本文件的代码
![get.PNG][2]

### `getsh.py`
```
import mysql.connector
conn = mysql.connector.connect(
  host="127.0.0.1",
  user="user",
  passwd="passwd"  )
c = conn.cursor()
c.execute("USE vps2022")

sql = 'SELECT * FROM text ORDER BY name'
c.execute(sql)
text = c.fetchall()

def makefile(file, str):
  f = open(file, 'w')
  f.write(str); f.close()

for i in range(len(text)):
  file=text[i][0]
  file_str = text[i][3]
  makefile(file, file_str)
  print(file, "\t保存完成!")

conn.close()
```

## 选择下载一个文件 `getfile.py`
![getfile.PNG][4]

```
import mysql.connector
conn = mysql.connector.connect(
    host="127.0.0.1",
    user="user",  passwd="pswd",
    database="vps2022",  buffered = True  )
c = conn.cursor()

sql = 'SELECT name FROM text'
c.execute(sql)
names = c.fetchall()

# 显示所有文件名，以供下载
for i in range(len(names)):
    print(names[i][0], end='  ')

print('\n:: 选择一个文件下载，输入文件名: ', end='')
name = input().strip()

sql = 'SELECT * FROM text WHERE name="' + name +'"'
c.execute(sql)
text = c.fetchall()

def makefile(file, str):
    f = open(file, 'w')
    f.write(str); f.close()

for i in range(len(text)):
    file=text[i][0]
    file_str = text[i][5]
    makefile(file, file_str)
    print(file, "\t保存完成!")

conn.close()
```

## 使用 `addfile.py` 可以批量上传文件到数据库中
![addfile.PNG][6]

```
import sys, glob
import mysql.connector
conn = mysql.connector.connect(
    host="127.0.0.1",
    user="user",  passwd="passwd",
    database="vps2022",  buffered = True  )
c = conn.cursor()

files = [] 
for f in sys.argv[1:]:
    files = files + glob.glob(f)

def readfile(file):
    f = open(file, 'r')
    str = f.read(); f.close()
    return str

for file in files:
    file_str = readfile(file)
    row =(file, file_str)
    
    c.execute("DELETE FROM text WHERE name=%s ", (file,) )
    c.execute('INSERT INTO text VALUES (%s,%s)', row)
    print("FontName: " + file + "   ....OK")

conn.commit()
conn.close()
```


  [1]: https://262235.xyz/usr/uploads/2021/12/1283040383.png
  [2]: https://262235.xyz/usr/uploads/2021/12/2063028572.png
  [3]: https://262235.xyz/usr/uploads/2021/12/1283040383.png
  [4]: https://262235.xyz/usr/uploads/2021/12/516251946.png
  [5]: https://262235.xyz/usr/uploads/2021/12/1283040383.png
  [6]: https://262235.xyz/usr/uploads/2021/12/4190129443.png
