#!/bin/sh
apt-get -y install libncurses5-dev g++ bison cmake
#复制文件到本地 不然编译不通过  
#cp -R /vagrant/src /data/source