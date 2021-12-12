import sys, os, mysql.connector
# define Color 
Green = '\033[32m'; Red = '\033[31m'; GreenBG = '\033[42;37m'; RedBG = '\033[41;37m'
Yellow = '\033[0;33m'; SkyBlue = '\033[0;36m'; Font = '\033[0m'

# 连接MYSQL数据库
import conf
conn = mysql.connector.connect(
    host=conf.host, user=conf.user,  
    passwd=conf.passwd, port=conf.port,
    database="vps2022",  buffered = True)
c = conn.cursor()

# sql 获取 vps 数据 , 显示 vps 数据
def display_data(c):
  print(GreenBG, ":: 显示 MySQL 数据库 vps2022 中获节点表  ")
  sql = 'SELECT * FROM vps ORDER BY ip'
  c.execute(sql)
  vps = c.fetchall()

  cnt=0  ; sk = list()
  for row in vps:
    print(SkyBlue, cnt,'节点:', Yellow, row)
    sk.append(list(row))
    cnt+=1
  print(Font)
  return sk

vps = display_data(c)
print(SkyBlue, ":: 使用节点直接输入节点号数字 ")
print(GreenBG, ":: 输入命令:", RedBG, "del <1> 删除节点 \n :: 添加节点:", SkyBlue, 'add <ip port passwd ss_port info>', Font)
print(' $ ', end='')
cmd = input().strip()
cmd = cmd.replace(',', ' ').replace('\'', '')
arg = cmd.split()
# print(arg)

if (len(arg)==0):
  sys.exit(1)

# 命令 del <1> 删除节点
if arg[0] == 'del' :
  id = int(arg[1])
  row = vps[id]
  c.execute("DELETE FROM vps WHERE ip=%s AND port=%s ", (row[0], row[1]) )
  conn.commit()
  print('\n'); display_data(c)
  sys.exit(0)

# 命令 add <ip port passwd ss_port info> 添加节点
if arg[0] == 'add' and len(arg)==6:
  row =(arg[1], arg[2], arg[3], arg[4], arg[5])
  c.execute('INSERT INTO vps VALUES (%s,%s,%s,%s,%s)', row)
  conn.commit()
  print('\n'); display_data(c)
  sys.exit(0)

text = 'sskcp.sh'
if text == 'sskcp.sh' :
  sql = "SELECT * FROM text WHERE name ='sskcp.sh'"
  c.execute(sql); row = c.fetchone(); text = row[1]
 
def make_sskcp(sk, id):
  cfg = sk[id]
  str = '#!/bin/bash\n\n'
  str += 'SERVER_IP=' + cfg[0] + '\nPORT=' + cfg[1] + '\nPASSWORD=' + cfg[2] + '\nSS_PORT=40000\nSOCKS5_PORT=1080\n'
  print(str)
  str += text
  return str

if int(arg[0]) < len(vps) and len(arg)==1:
  str = make_sskcp(vps, int(arg[0]))
  f = open('sskcp.sh', 'w')
  f.write(str); f.close()
  os.system('bash sskcp.sh restart')
  sys.exit(0)

conn.close()
