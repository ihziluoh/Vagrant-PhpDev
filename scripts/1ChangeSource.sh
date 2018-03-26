#!/bin/sh  
cp /etc/apt/sources.list /etc/apt/sources.list.bak  #备份
rm -rf /etc/apt/sources.list
touch /etc/apt/sources.list
echo 'deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse' >> /etc/apt/sources.list
echo 'deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse' >> /etc/apt/sources.list
echo 'deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse' >> /etc/apt/sources.list
echo 'deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse' >> /etc/apt/sources.list
echo 'deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse' >> /etc/apt/sources.list
echo 'deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse' >> /etc/apt/sources.list
echo 'deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse' >> /etc/apt/sources.list
echo 'deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse' >> /etc/apt/sources.list
echo 'deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse' >> /etc/apt/sources.list
echo 'deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse' >> /etc/apt/sources.list
cat /etc/apt/sources.list
apt-get update  #更新列表

