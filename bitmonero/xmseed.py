from monero.seed import Seed
from monero import wordlists

XM_XMR = u"小 明 的 钱 包 " * 5
seed = Seed(XM_XMR, "Chinese (simplified)")

def colorize(text, col='SkyBlue'):
    colors = ['SUCCESS', 'FAILURE', 'WARNING', 'NOTE', 'Green', 'Red', 'Yellow', 'SkyBlue']
    if col == colors[0] or col == 0 : out = '\033[42m'
    elif col == colors[1] or col == 1 : out = '\033[41m'
    elif col == colors[2] or col == 2 : out = '\033[43m'
    elif col == colors[3] or col == 3 : out = '\033[44m'
    elif col == colors[4] or col == 4 : out = '\033[32m'
    elif col == colors[5] or col == 5 : out = '\033[31m'
    elif col == colors[6] or col == 6 : out = '\033[0;33m'
    elif col == colors[7] or col == 7 : out = '\033[0;36m'
    else : out = '\033[42m' + col +'\033[0m'
    return  out + text +'\033[0m'

def display_info():
    s =['Seed.Hex: ', 'Seed种子: ', '钱包地址: ', 'view密钥: ', 'spend密钥:', '\n']
    print(colorize(s[5] + s[1], 0), colorize(seed.phrase, 'Green'))
    print(colorize(s[5] + s[0], 1), colorize(seed.hex, 'Yellow'))
    print(colorize(s[5] + s[2], 2), seed.public_address())
    print(colorize(s[3], 3), seed.secret_view_key())
    print(colorize(s[4], 1), seed.secret_spend_key())
    print()

def fix_seed(s):
    s = s.replace(' ', '')
    if len(s) == 64 or len(s) < 1 :
        return s
    elif len(s) < 12 or len(s) > 25:
        print(s, colorize(error, 'FAILURE'))
        exit()
    elif 13 < len(s) < 23 :
        print(s, colorize(error, 'FAILURE'))
        exit()

    cn = wordlists.ChineseSimplified()
    lst = list();  error_flag = ''
    for c in s:
        lst.append(c)
        if c not in cn.word_list :
            print(c, colorize('Not In Seed字典!', 'FAILURE'))
            error_flag = 'error_flag'

    if error_flag == 'error_flag' :
        exit()
    s = ' '.join(lst)
    return s

info = '本脚本用来给门罗币数字钱包 制作个性 Seed 种子汉字助记词\n'
info1 = '请输入12或24个汉字, 程序帮你计算第13或25个校验汉字! 也可以输入 Seed.Hex 计算 Seed 种子助记词。\n'
info2 = 'Seed 种子(汉字/Hex): '
info3 = '直接输入' + colorize(' <Enter> ', 1) + '键将新建随机种子\n'
error = '\t错误-检查字数!\t'

print(colorize(info, 'SUCCESS'), end = '')
yes = 'y' # yes = input()
if yes == 'y' or yes == 'Y' :
    print(colorize(info1) + info3 + colorize(info2, 'Red'), end = '')
    XM_XMR = fix_seed(input())
    seed = Seed(XM_XMR, "Chinese (simplified)")
    seed = Seed(seed.hex, "Chinese (simplified)")

display_info()

# monero.seed 开源库:  https://github.com/monero-ecosystem/monero-python
# 测试结果是否正确, 可以使用在线轻钱包检查，注意实际密钥种子，不要随便网上测试
# https://wallet.mymonero.com/
