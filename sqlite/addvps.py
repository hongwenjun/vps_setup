import sys, mysql.connector
Green = '\033[32m'; Red = '\033[31m'; GreenBG = '\033[42;37m'; RedBG = '\033[41;37m'; Yellow = '\033[0;33m'; SkyBlue = '\033[0;36m'; Font = '\033[0m'
# 连接MYSQL数据库
conn = mysql.connector.connect(
  host="MYSQL服务器",
  user="用户",
  passwd="密码"
c = conn.cursor(); c.execute("USE vps2022")

# sql 获取 vps 数据 , 显示 vps 数据
def display_data(c):
    print(GreenBG, ":: 显示 MySQL 数据库 vps2022 中获节点表  ")
    sql = 'SELECT * FROM vps'
    c.execute(sql)
    cnt=0  ; sk = list()
    for row in c.fetchall():
        print(SkyBlue, cnt,'节点:', Yellow, row)
        sk.append(list(row));  cnt+=1
display_data(c)

while True :
    print(GreenBG, ":: 添加节点:", SkyBlue, 'add <ip port passwd ss_port info>  ', RedBG, '保存和退出: quit', Font, '\n $ ', end='')
    cmd = input().strip()
    cmd = cmd.replace(',', ' ').replace('\'', '')
    arg = cmd.split()

    if (len(arg)==0):
        continue

    if arg[0] == 'add' and len(arg)==6:
        row =(arg[1], arg[2], arg[3], arg[4], arg[5])
        c.execute('INSERT INTO vps VALUES (%s,%s,%s,%s,%s)', row)

    if arg[0] == 'quit' :
        conn.commit()
        display_data(c)
        sys.exit(0)

# 使用命令  python3 addvps.py < iplist.txt  或者 cat iplist.txt | python3 addvps.py
# 批量输入数据  iplist.txt  格式 add  数据, 最后一行 quit
# add  '111.188.188.188', '22', 'Pa55@SSL', '443', '111号NAT小鸡'
# add  115.115.188.188 22 Pa55@SSL 443 115号NAT小鸡
# add  118.115.188.188,22,Pa55@SSL,443,115号NAT小鸡
# quit