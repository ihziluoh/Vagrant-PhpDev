#!/bin/sh

#依赖
#安装libmcrypt
cd /data/source

#wget ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-2.5.7.tar.gz

tar zxvf libmcrypt-2.5.7.tar.gz #解压

cd libmcrypt-2.5.7 #进入目录
./configure #配置
make && make install  #编译

apt-get -y install libxml2-dev libssh-dev # openssl evp.h 错误
apt-get -y install curl libcurl3 libcurl3-dev php5-curl #configure: error: Please reinstall the libcurl distribution - easy.h should be in <curl-dir>/include/curl/
apt-get -y install libpng-dev # configure: error: png.h not found.
apt-get -y install libfreetype6-dev  

# 在Ubuntu 12.4.1 X64 位下编译安装PHP时提示 configure: error: Cannot find OpenSSL's libraries 确认已安装过 openssl、libssl-dev 包，还是会提示该错误；
# 解决办法：
# root@test2:~/php-5.3.27# find / -name libssl.so
# 输出结果为： /usr/lib/x86_64-linux-gnu/libssl.so
# 初步判断它可能只会在 /usr/lib/ 下寻找 libssl.so 文件，于是：
ln -s /usr/lib/x86_64-linux-gnu/libssl.so /usr/lib
# 重新编译安装即通过。
mkdir -p /usr/local/php5 #建立php安装目录

cd /data/source
#wget http://am1.php.net/distributions/php-5.6.31.tar.gz
tar -zvxf php-5.6.31.tar.gz
cd php-5.6.31

./configure --prefix=/usr/local/php5 --with-config-file-path=/usr/local/php5/etc --with-mysql=/usr/local/mysql --with-mysqli=/usr/local/mysql/bin/mysql_config --with-freetype-dir=/usr/local/freetype --with-mysql-sock=/tmp/mysql.sock --with-gd --with-iconv --with-zlib --enable-xml --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curlwrappers --enable-mbregex --enable-fpm --enable-mbstring --enable-ftp --enable-gd-native-ttf --with-openssl --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --without-pear --with-gettext --enable-session --with-mcrypt --with-curl --with-freetype-dir=/usr/local/freetype --with-mhash --with-pdo-mysql=/usr/local/mysql #配置
make && make install #编译

rm -rf /etc/php.ini #删除系统自带配置文件

cp /vagrant/conf/php/php.ini  /usr/local/php5/etc/php.ini #复制php配置文件到安装目录
: '
#php.ini更改内容如下
找到：disable_functions =

修改为：

#disable_functions = passthru,exec,system,chroot,scandir,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,escapeshellcmd,dll,popen,disk_free_space,checkdnsrr,checkdnsrr,getservbyname,getservbyport,disk_total_space,posix_ctermid,posix_get_last_error,posix_getcwd, posix_getegid,posix_geteuid,posix_getgid, posix_getgrgid,posix_getgrnam,posix_getgroups,posix_getlogin,posix_getpgid,posix_getpgrp,posix_getpid, posix_getppid,posix_getpwnam,posix_getpwuid, posix_getrlimit, posix_getsid,posix_getuid,posix_isatty, posix_kill,posix_mkfifo,posix_setegid,posix_seteuid,posix_setgid, posix_setpgid,posix_setsid,posix_setuid,posix_strerror,posix_times,posix_ttyname,posix_uname

#开启短连接

short_open_tag = On

'
ln -s /usr/local/php5/etc/php.ini /etc/php.ini #添加软链接


cp /vagrant/conf/php/php-fpm.conf  /usr/local/php5/etc/php-fpm.conf #拷贝模板文件为php-fpm配置文件

: '
#php-fpm.conf更改内容如下
user = www #设置php-fpm运行账号为www

group = www #设置php-fpm运行组为www

pid = run/php-fpm.pid #取消前面的分号

'

cp /data/source/php-5.6.31/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm #拷贝php-fpm到启动目录

chmod +x /etc/init.d/php-fpm #添加执行权限
update-rc.d php-fpm defaults #设置开机启动

/usr/local/php5/sbin/php-fpm #启动php-fpm

