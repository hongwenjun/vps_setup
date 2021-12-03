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