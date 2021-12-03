![vps_sqlte.png][1]

SQLite 是一个C语言库，它可以提供一种轻量级的基于磁盘的数据库，这种数据库不需要独立的服务器进程，也允许需要使用一种非标准的 SQL 查询语言来访问它。一些应用程序可以使用 SQLite 作为内部数据存储。

## Python 建立 Sqlite3 数据库和vps数据表，插入数据示例
![vps2021.png][2]

### 源码: `make_db.py`
```
import sqlite3
conn = sqlite3.connect('vps2021.db')

c = conn.cursor()

# Create table   建立 vps 数据表
c.execute('''CREATE TABLE vps
             (ip text, port text, password text, ss_port text, info text)''')

# Insert a row of data  插入一行示例数据
c.execute('''INSERT INTO vps VALUES 
            ('188.188.188.188', '22', 'passwd@vps2021', '443', '0号vps示例')''')

# Save (commit) the changes   保存提交数据修改
conn.commit()

# 不应该使用 Python 的字符串操作来创建你的查询语句，因为那样做不安全；它会使你的程序容易受到 SQL 注入攻击
# 推荐使用 DB-API 的参数替换。在 SQL 语句中，使用 ? 占位符来代替值，然后把对应的值组成的元组做为 execute() 方法的第二个参数。
port = ('22',)
c.execute('SELECT * FROM vps WHERE port=?', port)
print(c.fetchone())

# Larger example that inserts many records at a time
# 一次插入很多行数据记录的例子
purchases = [ ('188.188.188.188', '10122', 'passwd@vps2021', '443', '1号NAT小鸡'),
              ('188.188.188.188', '10222', 'passwd@vps2021', '443', '2号NAT小鸡'),
              ('188.188.188.188', '10322', 'passwd@vps2021', '443', '3号NAT小鸡'),
              ('188.188.188.188', '10422', 'passwd@vps2021', '443', '4号NAT小鸡'),
              ('188.188.188.188', '10522', 'passwd@vps2021', '443', '5号NAT小鸡'),
              ('188.188.188.188', '10622', 'passwd@vps2021', '443', '6号NAT小鸡'),
              ('188.188.188.188', '10722', 'passwd@vps2021', '443', '7号NAT小鸡'),
              ('188.188.188.188', '10822', 'passwd@vps2021', '443', '8号NAT小鸡'),
              ('188.188.188.188', '10922', 'passwd@vps2021', '443', '9号NAT小鸡'),
            ]
c.executemany('INSERT INTO vps VALUES (?,?,?,?,?)', purchases)
conn.commit()

# We can also close the connection if we are done with it.
# 如果我们完成了连接，我们也可以关闭连接。
# Just be sure any changes have been committed or they will be lost.
# 只要确定任何修改都已经提交，否则就会丢失。
conn.close()
```

### 运行 `make_db.py` 脚本，输出一行数据，建立数据文件 `vps2021.db`
```
python make_db.py
('188.188.188.188', '22', 'passwd@vps2021', '443', '0号vps示例')
```

## 使用软件 `SQLiteSpy` 打开检查数据表和查询示例
![spy.png][3]

### 输入 `SELECT` 查询指令，搜索数据
![select.png][4]
- 源码 `get_vps_db.py`
```
SELECT * FROM vps WHERE port=10822
```
### 快捷键 F2 修改数据
![f2.png][5]

## Python 获取 vps数据
![vps.png][6]

- 源码 `get_vps_db.py`
```
import sqlite3
conn = sqlite3.connect('vps2021.db')
c = conn.cursor()

# 要在执行 SELECT 语句后获取数据，你可以把游标作为 iterator，
# 然后调用它的 fetchone() 方法来获取一条匹配的行，
# 也可以调用 fetchall() 来得到包含多个匹配行的列表。
vps = c.execute('SELECT * FROM vps ORDER BY ip')
print(vps.fetchone())

# 下面是一个使用迭代器形式的例子：
cnt=1   
for row in vps:
  print(cnt,'节点: ', row)
  cnt+=1

conn.close()
```

## 从vps数据库中构建我们的应用脚本 源码 `sskcp.py`
![sskcp.png][7]
```
import sqlite3
conn = sqlite3.connect('vps2021.db')
c = conn.cursor()

# sql 获取 vps 数据
sql = 'SELECT * FROM vps ORDER BY ip'
c.execute(sql)
vps = c.fetchall()

# define Color 
Green = '\033[32m'; Red = '\033[31m'; GreenBG = '\033[42;37m'; RedBG = '\033[41;37m'
Yellow = '\033[0;33m'; SkyBlue = '\033[0;36m'; Font = '\033[0m'
print(GreenBG, ":: SQLite3 数据库 vps2021.db 中获取的节点表  ")

# 显示 vps 数据
cnt=0  ; sk = list()
for row in vps:
  print(SkyBlue, cnt,'节点:', Yellow, row)
  sk.append(list(row))
  cnt+=1

# 输入数字选择节点
print(RedBG, ":: 请选择你需要的节点，输入节点号:", Font, end='')
id = int(input())

def make_sskcp(sk, id):
  text = '''
# git.io/sskcp.sh
  ''' 
  cfg = sk[id]
  str = '#!/bin/bash\n\n'
  str += 'SERVER_IP=' + cfg[0] + '\nPORT=' + cfg[1] + '\nPASSWORD=' + cfg[2] + '\nSS_PORT=40000\nSOCKS5_PORT=1080\n'
  print(str)
  str += text
  return str

# 构建 sskcp.sh 
str = make_sskcp(sk, id)
f = open('sskcp.sh', 'w')
f.write(str)

# 关闭数据库链接和文件
conn.close()
f.close()
```

  [1]: https://262235.xyz/usr/uploads/2021/12/564091663.png
  [2]: https://262235.xyz/usr/uploads/2021/12/230470055.png
  [3]: https://262235.xyz/usr/uploads/2021/12/890574423.png
  [4]: https://262235.xyz/usr/uploads/2021/12/1631363865.png
  [5]: https://262235.xyz/usr/uploads/2021/12/2789190230.png
  [6]: https://262235.xyz/usr/uploads/2021/12/3608186973.png
  [7]: https://262235.xyz/usr/uploads/2021/12/2410509594.png
