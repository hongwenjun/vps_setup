# 使用sql数据表保存脚本代码文件
# Python脚本从数据库里上传和下载代码文件

![sql表格][1]
学习Python脚本和SQL数据库使用，为了保持多设备代码的版本同步，折腾把脚本代码保存到SQL数据表中。
方便一起备份，用到方便更新，也可以再写个批量插入文件和更新文件脚本，网页端读取使用。
## 可以使用图形工具软件，连数据库建立表
- 表 vps2022.text 结构
```
CREATE TABLE IF NOT EXISTS `text` (
  `name` text,
  `text` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

## 统一设置 MYSQL密码配置 `conf.py`
```
# conn = mysql.connector.connect

host="188.188.188.188"
user="root"
passwd="passwd@passwd"
port=3306

```

## 获取sql数据表 text 中所有脚本文件的代码 `getsh.py`
![get.PNG][2]


## 选择下载一个文件 `getfile.py`
![getfile.PNG][4]


## 使用 `addfile.py` 可以批量上传文件到数据库中
![addfile.PNG][6]


  [1]: https://262235.xyz/usr/uploads/2021/12/1283040383.png
  [2]: https://262235.xyz/usr/uploads/2021/12/2063028572.png
  [3]: https://262235.xyz/usr/uploads/2021/12/1283040383.png
  [4]: https://262235.xyz/usr/uploads/2021/12/516251946.png
  [5]: https://262235.xyz/usr/uploads/2021/12/1283040383.png
  [6]: https://262235.xyz/usr/uploads/2021/12/4190129443.png
