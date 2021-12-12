import mysql.connector
conn = mysql.connector.connect(
    host="127.0.0.1",
    user="user",  passwd="passwd",
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
    file_str = text[i][1]
    makefile(file, file_str)
    print('FontName:', file, "\t保存完成!")

conn.close()
