#! /bin/bash

# sudo visudo
#
# /etc/ssh/sshd_config
# change to:
# PasswordAuthentication yes
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

# create user
adduser yang
passwd='123456'
if [ "$1" != "" ];then
    passwd=$1
fi
echo  "set yang pass [$passwd]"
echo -e "$passwd\n$passwd" | passwd yang
grep '^yang' /etc/sudoers
if [ "$?" != 0 ];then
    # add sudo users.
    sed -i "/^root/a yang ALL=(ALL) ALL" /etc/sudoers
fi

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
yes | yum install libconfig

# disable selinux
setenforce 0
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

yes | yum install nodejs
npm install -g web3
npm install -g tronweb
npm install -g yarn

#export NODE_PATH=/usr/local/lib/node_modules
if ! grep -q '^export NODE_PATH=/usr/local/lib/node_modules' /home/yang/.bashrc ; then
	echo 'export NODE_PATH=/usr/local/lib/node_modules' >>/home/yang/.bashrc
	source /home/yang/.bashrc
fi

alternatives --set python /usr/bin/python3

# install epel-release
dnf install epel-release -y
#dnf install snapd -y
#systemctl enable --now snapd.socket
#systemctl start snapd
#snap install shadowsocks-libev

# add chmod
chmod +rx /var/log/nginx
