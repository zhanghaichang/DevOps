#### 下载Anaconda

    [root@master tmp]# wget https://repo.continuum.io/archive/Anaconda2-4.4.0-Linux-x86_64.sh
    

#### 进入安装文件存放目录

    [root@master tmp]# ll
    -rw-r--r-- 1 root root 508722275 May 31 03:20 Anaconda2-4.4.0-Linux-x86_64.sh
    

#### 输入安装命令

    [root@master tmp]# bash Anaconda2-4.4.0-Linux-x86_64.sh
    

#### 根据提示按ENTER

    Welcome to Anaconda2 4.4.0 (by Continuum Analytics, Inc.)
    
    In order to continue the installation process, please review the license
    agreement.
    Please, press ENTER to continue
    >>>
    

#### 根据提示输入yes,同意license agreement

    ... ...
    kerberos (krb5, non-Windows platforms)
    A network authentication protocol designed to provide strong authentication
    for client/server applications by using secret-key cryptography.
    
    cryptography
    A Python library which exposes cryptographic recipes and primitives.
    
    Do you approve the license terms? [yes|no]
    >>> yes
    

#### 直接ENTER键，用默认的安装路径

    Anaconda2 will now be installed into this location:
    /root/anaconda2
    
    - Press ENTER to confirm the location
    - Press CTRL-C to abort the installation
    - Or specify a different location below
    
    [/root/anaconda2] >>>
    

#### 写入环境变量，直接输入yes

    ... ...
    installing: zlib-1.2.8-3 ...
    installing: anaconda-4.4.0-np112py27_0 ...
    installing: conda-4.3.21-py27_0 ...
    installing: conda-env-2.6.0-0 ...
    Python 2.7.13 :: Continuum Analytics, Inc.
    creating default environment...
    installation finished.
    Do you wish the installer to prepend the Anaconda2 install location
    to PATH in your /root/.bashrc ? [yes|no]
    [no] >>> yes
    

#### 生效.bashrc文件

    [root@master tmp]# source ~/.bashrc
    

#### 输入python，验证环境

    Python 2.7.13 |Anaconda 4.4.0 (64-bit)| (default, Dec 20 2016, 23:09:15) 
    [GCC 4.4.7 20120313 (Red Hat 4.4.7-1)] on linux2
    Type "help", "copyright", "credits" or "license" for more information.
    Anaconda is brought to you by Continuum Analytics.
    Please check out: http://continuum.io/thanks and https://anaconda.org
    >>> 
