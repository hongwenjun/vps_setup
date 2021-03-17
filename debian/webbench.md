## 网站压力测试工具webbench

```
1、安装依赖包CTAGS

apt install ctags

2、安装 Webbench

wget http://blog.s135.com/soft/linux/webbench/webbench-1.5.tar.gz
tar xf  webbench-1.5.tar.gz
cd webbench-1.5
make && make install

3. 使用 webbench -? (查看命令帮助)

常用参数 说明，-c 表示客户端数，-t 表示时间
测试实例：

webbench -c 500  -t  30   http://127.0.0.1/phpionfo.php
```

### Install
=============
```
    wget http://blog.s135.com/soft/linux/webbench/webbench-1.5.tar.gz
    tar zxvf webbench-1.5.tar.gz
    cd webbench-1.5
    make && make install
```
Usage
=============
```
    webbench --help
    webbench [option]... URL
      -f|--force               Don't wait for reply from server.
      -r|--reload              Send reload request - Pragma: no-cache.
      -t|--time <sec>          Run benchmark for <sec> seconds. Default 30.
      -p|--proxy <server:port> Use proxy server for request.
      -c|--clients <n>         Run <n> HTTP clients at once. Default one.
      -9|--http09              Use HTTP/0.9 style requests.
      -1|--http10              Use HTTP/1.0 protocol.
      -2|--http11              Use HTTP/1.1 protocol.
      --get                    Use GET request method.
      --head                   Use HEAD request method.
      --options                Use OPTIONS request method.
      --trace                  Use TRACE request method.
      -?|-h|--help             This information.
      -V|--version             Display program version.
```
Example
=============
```
    webbench -c 500 -t 30 http://google.com/
        Webbench - Simple Web Benchmark 1.5
        Copyright (c) Radim Kolar 1997-2004, GPL Open Source Software.

        Benchmarking: GET http://google.com/
        500 clients, running 30 sec.

        Speed=5372 pages/min, 79426 bytes/sec.
        Requests: 2418 susceed, 268 failed.
```
