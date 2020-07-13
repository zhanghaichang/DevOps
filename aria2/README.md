# aria2

> Aria2 是一个多平台轻量级，支持 HTTP、FTP、BitTorrent 等多协议、多来源的命令行下载工具。Aria2 可以从多个来源、多个协议下载资源，最大的程度上利用了你的带宽。Aria2 有着非常小的资源占用，在关闭磁盘缓存的情况下，物理内存占用通常为 4M（正常 HTTP/FTP 下载的情况下），BitTorrent 下载每秒2.8M/S的情况下，CPU 占有率约为 6%。Aria2 支持 JSON-RPC 和 XML-RPC 接口远程调用。


### 一、安装aria2

```shell
[root@192-168-7-77 ~]# wget https://github.com/aria2/aria2/releases/download/release-1.33.1/aria2-1.33.1.tar.bz2
 [root@192-168-7-77 ~]# yum -y install bzip2
 [root@192-168-7-77 ~]# bzip2 -d aria2-1.33.1.tar.bz2 
 [root@192-168-7-77 ~]# tar xf aria2-1.33.1.tar 
 [root@192-168-7-77 ~]# cd aria2-1.33.1/
 [root@192-168-7-77 ~/aria2-1.33.1]# ./configure --prefix=/usr/local/aria2
 [root@192-168-7-77 ~/aria2-1.33.1]# make && make install
 [root@192-168-7-77 ~]# tail -1 /etc/profile
 export PATH=$PATH:/usr/local/aria2/bin
 [root@192-168-7-77 ~]# source /etc/profile
```


### 二、解决报错问题

```
[root@192-168-7-77 ~/2]# tar -jxv -f aria2-1.33.1.tar.bz2 
tar (child): bzip2: Cannot exec: No such file or directory
tar (child): Error is not recoverable: exiting now
tar: Child returned status 2
tar: Error is not recoverable: exiting now
# gcc-c++版本过底，需要gcc >= 4.8.3

[root@192-168-7-77 ~/2/aria2-1.33.1]# ./configure --prefix=/usr/local/aria2
checking for pkg-config... /usr/bin/pkg-config
checking pkg-config is at least version 0.20... yes
checking whether g++ supports C++11 features by default... no
checking whether g++ supports C++11 features with -std=c++11 ... no
checking whether g++ supports C++11 features with -std=c++11 -stdlib=libc++... no
checking whether g++ supports C++11 features with -std=c++0x ... yes
checking whether the c++ compiler supports nullptr... configure: error: in `/usr/local/src/aria2-1.33.1':
configure: error: C++ compiler does not understand nullptr, perhaps C++ compiler is too old.  Try again with new one (gcc >= 4.8.3 or clang >= 3.4)
See `config.log' for more details
[root@192-168-7-77 aria2-1.33.1]# rpm -qa | grep gcc-c++
gcc-c++-4.4.7-17.el6.x86_64

# 需要将gcc升级到4.8.2
[root@192-168-7-77 ~]# cd /usr/local/src/
[root@192-168-7-77 src]# wget http://ftp.gnu.org/gnu/gcc/gcc-4.8.2/gcc-4.8
[root@192-168-7-77 src]# tar xf gcc-4.8.2.tar.bz2 
[root@192-168-7-77 src]# cd gcc-4.8.2/

# 运行自带脚本，完成下载、配置、安装依赖库，可以节约我们大量的时间和精力
[root@192-168-7-77 gcc-4.8.2]# ./contrib/download_prerequisites 

# 建立一个目录供编译出的文件存放
[root@192-168-7-77 gcc-4.8.2]# mkdir gcc-build-4.8.2
[root@192-168-7-77 gcc-4.8.2]# cd gcc-build-4.8.2

# 生成makefile文件
[root@192-168-7-77 gcc-build-4.8.2]# ../configure -enable-checking=release -enable-languages=c,c++ -disable-multilib
# 编译（很耗时，-j4对多核处理器的优化）
[root@192-168-7-77 gcc-build-4.8.2]# make -j4
[root@192-168-7-77 gcc-build-4.8.2]# make install

# 验证是否成功，如果还是显示原来的版本，则需要重启系统
[root@192-168-7-77 ~]# gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/local/libexec/gcc/x86_64-unknown-linux-gnu/4.8.2/lto-wrapper
Target: x86_64-unknown-linux-gnu
Configured with: ../configure -enable-checking=release -enable-languages=c,c++ -disable-multilib
Thread model: posix
gcc version 4.8.2 (GCC)
```
