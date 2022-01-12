from monero.seed import Seed
from monero import wordlists

# define Color 
Green = '\033[32m'; Red = '\033[31m'; GreenBG = '\033[42;37m'; RedBG = '\033[41;37m'
Yellow = '\033[0;33m'; SkyBlue = '\033[0;36m'; Font = '\033[0m'

XM_XMR = u"小 明 的 钱 包 " * 5
seed = Seed(XM_XMR, "Chinese (simplified)")

def display_info():
    s =['Seed.Hex: ', 'Seed种子: ', '钱包地址: ', 'view密钥: ', 'spend密钥:', '\n']
    print(s[5] + Green + s[1] + Red , seed.phrase)
    print(s[5] + SkyBlue + s[0] + Yellow, seed.hex)
    print(s[5] + Red + s[2] + Font, seed.public_address())
    print(Yellow + s[3] + Font, seed.secret_view_key())
    print(SkyBlue + s[4] + Font , seed.secret_spend_key())
    print()

def fix_seed(s):
    s = s.replace(' ', '')
    if len(s) == 64 or len(s) < 1 :
        return s
    elif len(s) < 12 or len(s) > 25:
        print(s, error)
        exit()
    elif 13 < len(s) < 23 :
        print(s, error)
        exit()

    cn = wordlists.ChineseSimplified()
    lst = list();  error_flag = ''
    for c in s:
        lst.append(c)
        if c not in cn.word_list :
            print(c, Red +'Not In Seed字典!' + Font)
            error_flag = 'error_flag'

    if error_flag == 'error_flag' :
        exit()
    s = ' '.join(lst)
    return s

info = GreenBG + '本脚本用来给门罗币数字钱包 制作个性 Seed 种子汉字助记词\n' + Font
info1 = Yellow + '请输入12或24个汉字, 程序帮你计算第13或25个校验汉字! 也可以输入 Seed.Hex 计算 Seed 种子助记词. 直接输入 <Enter> 键将新建随机种子。\n'
info2 = Red + 'Seed 种子(汉字/Hex): ' + Font
error = Red +'\t错误-检查字数!' + Font

print(info, end = '')
yes = 'y' # yes = input()
if yes == 'y' or yes == 'Y' :
    print(info1 + info2, end = '')
    XM_XMR = fix_seed(input())
    seed = Seed(XM_XMR, "Chinese (simplified)")
    seed = Seed(seed.hex, "Chinese (simplified)")

display_info()

# monero.seed 开源库:  https://github.com/monero-ecosystem/monero-python
# 测试结果是否正确, 可以使用在线轻钱包检查，注意实际密钥种子，不要随便网上测试
# https://wallet.mymonero.com/
