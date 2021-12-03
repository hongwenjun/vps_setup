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