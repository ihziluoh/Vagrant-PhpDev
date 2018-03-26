#!/bin/sh

#依赖
apt-get -y install tcl

#安装libmcrypt
cd /data/source

#wget http://download.redis.io/releases/redis-3.2.8.tar.gz
tar xzf redis-3.2.8.tar.gz

cd redis-3.2.8

make PREFIX=/usr/local/redis install
cp -r /vagrant/conf/redis/redis.conf /usr/local/redis/bin/redis.conf

cp -r /vagrant/conf/redis/redis /etc/init.d/redis


chmod +x /etc/init.d/redis
设置开机自动启动
update-rc.d redis defaults
