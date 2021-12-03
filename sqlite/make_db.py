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