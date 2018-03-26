#!/bin/sh

#依赖
#安装libmcrypt
cd /data/source

#wget https://download.savannah.gnu.org/releases/freetype/freetype-2.7.tar.gz

tar zxvf freetype-2.7.tar.gz #解压

cd freetype-2.7 #进入目录
# ---------------------------------- 静态编译 重新编译安装php

./configure --prefix=/usr/local/freetype && make && make install

cd /data/source/php-5.6.31
make clean

./configure --prefix=/usr/local/php5 --with-config-file-path=/usr/local/php5/etc --with-mysql=/usr/local/mysql --with-mysqli=/usr/local/mysql/bin/mysql_config --with-freetype-dir=/usr/local/freetype  --with-mysql-sock=/tmp/mysql.sock --with-gd --with-iconv --with-zlib --enable-xml --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curlwrappers --enable-mbregex --enable-fpm --enable-mbstring --enable-ftp --enable-gd-native-ttf --with-openssl --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --without-pear --with-gettext --enable-session --with-mcrypt --with-curl --with-freetype-dir=/usr/local/freetype --with-mhash --with-pdo-mysql=/usr/local/mysql #配置

make && make install



# Cannot find autoconf 解决方法
apt-get install m4
apt-get install autoconf


#jpeg
wget http://www.ijg.org/files/jpegsrc.v9c.tar.gz

tar zxvf jpegsrc.v9c.tar.gz #解压

cd jpeg-9c

./configure --prefix=/usr/local/jpeg --enable-shared --enable-static   
make && make install  
make clean && make distclean  
apt-get install libtool
libtool --finish /usr/local/jpeg/lib 

# ---------------------------------- 动态编译 重新编译安装php

cd freetype-2.7 #进入目录
./configure --prefix=/usr/local/freetype

#进入configure目录
cd /data/source/php-5.6.31/ext/gd
# 先执行生成configure文件
/usr/local/php5/bin/phpize #需要在插件安装目录执行


./configure --with-php-config=/usr/local/php5/bin/php-config --with-freetype-dir=/usr/local/freetype --with-jpeg-dir=/usr/local/jpeg --with-png-dir=/usr/local/libpng 
make && make install


# php-xdebug 扩展安装
cd /data/source
#wget https://xdebug.org/files/xdebug-2.5.5.tgz
tar xzf xdebug-2.5.5.tgz
apt-get -y install autoconf m4
cd xdebug-2.5.5
/usr/local/php5/bin/phpize #需要在插件安装目录执行
./configure --with-php-config=/usr/local/php5/bin/php-config 
make && make install
---------------------------------------------

vi /usr/local/php5/etc/php.ini
zend_extension="/usr/local/php5/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so"

/usr/local/php5/bin/php -m
/usr/local/nginx/sbin/nginx -s reload