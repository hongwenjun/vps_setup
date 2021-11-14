#-*- coding: UTF-8 -*- 
import sys, os, readline

# define Color
Green = '\033[32m'; Red = '\033[31m'
GreenBG = '\033[42;37m'; RedBG = '\033[41;37m'
Yellow = '\033[0;33m'; SkyBlue = '\033[0;36m'; Font = '\033[0m'

sys.ps1 = Red + '>' + Yellow + '>' + SkyBlue + '> ' + Font
sys.ps2 = SkyBlue + '... ' + Font

def cls():
    # print('\x1bc')
    os.system('clear')

def pwd():
    print( SkyBlue + os.getcwd(), end = ' ')

def ls():
    cur_path = os.getcwd()
    os.system('ls -l ' + cur_path)
    pwd()

def cd(path = '.'):
    os.chdir(path)
    pwd()

def cat(file = 'me.py'):
    with open(file, 'r') as f:
        print(f.read())

def bash():
    os.system('bash')

def history():
    for i in range(readline.get_current_history_length()):
        print(readline.get_history_item(i + 1))
    print( Yellow   + ':: Clear_History:  readline.clear_history() ')

def info():
    print( SkyBlue + ':: Usage:  ' + Green + 'python -i me.py' + Yellow + '     or [import me] , import the module me.py')
    print( Green   + ':: Function:  cls()  ls()  cd(path)  cat(file)  pwd()  bash()  info()  history()')
    pwd()

info(); c = cls; h = history
