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
