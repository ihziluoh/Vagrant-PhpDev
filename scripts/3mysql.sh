#!/bin/sh
cd /data/source
#wget "https://cdn.mysql.com//Downloads/MySQL-5.6/mysql-5.6.39.tar.gz"

groupadd mysql #添加mysql组

useradd -g mysql mysql -s /bin/false #创建用户mysql并加入到mysql组，不允许mysql用户直接登录系统

mkdir -p /data/mysql #创建MySQL数据库存放目录

chown -R mysql:mysql /data/mysql #设置MySQL数据库目录权限

tar zxvf mysql-5.6.39.tar.gz

cd mysql-5.6.39

cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/data/mysql -DSYSCONFDIR=/etc #配置

make && make install

cp /vagrant/conf/mysql/my.cnf /etc

cd /usr/local/mysql/scripts

./mysql_install_db --datadir=/data/mysql --user=mysql --basedir=/usr/local/mysql --defaults-file=/etc/my.cnf

cd /usr/local/mysql/support-files

./mysql.server start

cd /usr/local/mysql/bin

# 更改默认密码
./mysqladmin -S /data/mysql/mysql.sock -u root password 'vagrant'



#开机启动
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld #把Mysql加入系统启动

chmod 755 /etc/init.d/mysqld #增加执行权限

#开机启动命令

update-rc.d mysqld defaults

#ubutnu : update-rc.d mysqld defaults centos:chkconfig mysqld on

#更改开机启动配置: 有默认值不需要更改

#sed -i "s/basedir=/basedir=\/usr\/local\/mysql/g" /etc/init.d/mysqld

#sed -i "s/datadir=/datadir=\/data\/mysql/g" /etc/init.d/mysqld

echo 'export PATH=$PATH:/usr/local/mysql/bin' >> /etc/profile #把mysql服务加入系统环境变量：在最后添加下面这一行

## 下面这两行把myslq的库文件链接到系统默认的位置，这样你在编译类似PHP等软件时可以不用指定mysql的库文件地址。

ln -s /usr/local/mysql/lib/mysql /usr/lib/mysql

ln -s /usr/local/mysql/include/mysql /usr/include/mysql



#允许远程登录 sql

./mysql -u root -pvagrant

use mysql;

update user set host = '%' where user = 'root';

select host, user from user;

flush privileges;

exit;