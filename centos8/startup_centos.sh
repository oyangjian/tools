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
npm install -g react-scripts

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

# ssh passwd
ssh1='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQEuF1pzaUt0KDmvLzU9OgxD1bI24gqnSgnbllwsnUy6ES8ciOczCqhbKVyzTdfizeH/bJke5yIdh86fAFP6aWhKwNSIisavamcHo39/E6eaY2Gq6jwLDzUKou0U5asxBrPv/GHkFqExtHnrjvL8icvLS/V+zDKRB62xfWxJUCwdhC7F2Iva1wLR5k2+sAWr9L2rU3pD28KUn+gu2YL+v5uagTa9TSudB7l6yyNxbL0+MBk1ko5HEO1MxuTyYpdsTFPz1QRw5j6iJsDSvq0s64j1GA15pU5R89hkAm+ts/KVC8Vc4JqF20Z4gzK+nt/pvQLls3nseXcHONedyKTC1z yang@yangdeMacBook-Pro.local'
ssh2='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDhD+JCbAc+ZHntMuWf94iQ4Gviqgl5YrlMynjCKiM3pC21oM8ztqthTMOyoYmWQ3SszZ10TwRjlpi5WNEWev4WpqGmluj8K8hbtcyW4PB6VBIw18MXYyek7EsN9qMSG7Skfz4G6fJbBTT9yZg7RTFuZPF9IOKK6yURw3qghQ/+vw== skey_157157'

mkdir /home/yang/.ssh
mkdir /root/.ssh
mkdir 700 /home/yang/.ssh
mkdir 700 /root/.ssh
echo $ss1 >>/home/yang/.ssh/authorized_keys
echo $ss2 >>/home/yang/.ssh/authorized_keys
echo $ss1 >>/root/.ssh/authorized_keys
echo $ss2 >>/root/.ssh/authorized_keys
