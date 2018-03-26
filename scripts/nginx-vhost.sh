#!/bin/sh
cp -R /vagrant/conf/nginx/vhost /usr/local/nginx/conf
/usr/local/nginx/sbin/nginx -s reload

