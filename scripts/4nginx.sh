#!/bin/sh

#基础依赖
cd /data/source
#wget https://ftp.pcre.org/pub/pcre/pcre-8.41.tar.gz

apt-get -y install build-essential # Ubuntu并没有提供C/C＋＋的编译环境，因此还需要手动安装。

mkdir /usr/local/pcre #创建安装目录
tar zxvf pcre-8.41.tar.gz
cd pcre-8.41
./configure --prefix=/usr/local/pcre #配置
make && make install

#nginx安装
apt-get -y install zlib1g.dev #安装依赖　zlib1g


groupadd www #添加www组
useradd -g www www -s /bin/false #创建nginx运行账户www并加入到www组，不允许www用户直接登录系统
cd /data/source
#wget http://nginx.org/download/nginx-1.8.1.tar.gz
tar zxvf nginx-1.8.1.tar.gz
cd nginx-1.8.1
./configure --prefix=/usr/local/nginx --without-http_memcached_module --user=www --group=www --with-http_stub_status_module --with-openssl=/usr/ --with-pcre=/data/source/pcre-8.41
#注意:--with-pcre=指向的是源码包解压的路径，而不是安装的路径，否则会报错
make && make install

/usr/local/nginx/sbin/nginx #启动nginx
#开机启动
cp /vagrant/conf/nginx/nginx /etc/init.d/
chmod 775 /etc/init.d/nginx

update-rc.d nginx defaults


cp /vagrant/conf/nginx/nginx.conf /usr/local/nginx/conf/nginx.conf
/etc/init.d/nginx restart #重启nginx

cd /usr/local/nginx/html/ #进入nginx默认网站根目录
rm -rf /usr/local/nginx/html/* #删除默认测试页

echo '<?php' >> index.php
echo 'phpinfo();' >> index.php
chown www.www /usr/local/nginx/html/ -R #设置目录所有者
chmod 700 /usr/local/nginx/html/ -R #设置目录权限
