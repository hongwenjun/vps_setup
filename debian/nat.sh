# Usage: bash nat.sh $(lxc-ls)

# 小鸡的端口转发规则    ssh 22  http 80      10<N>00 : 10<N>99
# ID对应IP  101:         10122    10180        10100 : 10199
#-------------------------------------------------------------#
input_id()
{
  id=101
  echo -e "测试默认ID: \033[41;37m ${id} \033[0m 可以修改设置其他ID; "
  read -p "请输入NAT小鸡的ID号(按回车不修改): " -t 30 new
  if [[ ! -z "${new}" ]]; then
      id="${new}"
  fi
  nat_port
  iptables -t nat -nvL PREROUTING
  echo -e ":: PVE NAT 批量端口转发设置脚本: \033[41;37m bash nat.sh $(lxc-ls) \033[0m \n使用参考: https://262235.xyz/index.php/archives/714/"
}
# 以id为ip设置端口转发
nat_port()
{
    iptables -t nat -I PREROUTING -p tcp -m tcp --dport ${id}22  -j DNAT --to-destination 10.10.10.${id}:22
#   iptables -t nat -I PREROUTING -p tcp -m tcp --dport ${id}80  -j DNAT --to-destination 10.10.10.${id}:80
    iptables -t nat -A PREROUTING -p tcp -m multiport --dport ${id}00:${id}99  -j DNAT --to-destination 10.10.10.${id}
}

# 手工输入id，input_id调用nat端口转发
if [ $# -eq 0 ];
  then
  input_id
  exit
fi

# 遍历参数 批量设置 nat端口转发
for arg in $*                     
do
  id=$arg      
  nat_port
done

# 查看 nat PREROUTING 端口映射规则
iptables -t nat -nvL PREROUTING

# 清空 nat PREROUTING 端口映射规则
# iptables -t nat -F PREROUTING