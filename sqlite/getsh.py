import mysql.connector
conn = mysql.connector.connect(
    host="127.0.0.1",
    user="user",  passwd="passwd",
    database="vps2022",  buffered = True  )
c = conn.cursor()

sql = 'SELECT * FROM text ORDER BY name'
c.execute(sql)
text = c.fetchall()

def makefile(file, str):
  f = open(file, 'w')
  f.write(str); f.close()

for i in range(len(text)):
  file=text[i][0]
  file_str = text[i][1]
  makefile(file, file_str)
  print(file, "\t�������!")

conn.close()