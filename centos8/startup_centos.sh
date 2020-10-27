#! /bin/bash

# sudo visudo
#
# /etc/ssh/sshd_config
# change to:
# PasswordAuthentication yes
# sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
# systemctl restart sshd

# hostnamectl --static set-hostname bcweb.tw

yes | yum update
yes | yum install httpd
#systemctl restart httpd
yes | yum install nginx
systemctl restart nginx
systemctl enable nginx

if [ ! -f /var/www/html/index.html ];then
	echo "install black index.html"
	echo "" >/var/www/html/index.html
fi

# nginx default html(blank)
if [ ! -f /usr/share/nginx/html/index.html-orig ]; then
	mv /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html-orig
	echo "" >/usr/share/nginx/html/index.html
fi

yes | yum install git
yes | yum install unzip

# disable selinux
setenforce 0
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

yes | yum install nodejs
npm install -g web3
npm install -g tronweb

#export NODE_PATH=/usr/local/lib/node_modules
if ! grep -q '^export NODE_PATH=/usr/local/lib/node_modules' /home/yang/.bashrc ; then
	echo 'export NODE_PATH=/usr/local/lib/node_modules' >>/home/yang/.bashrc
	source /home/yang/.bashrc
fi

alternatives --set python /usr/bin/python3
