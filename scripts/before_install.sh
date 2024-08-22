#!/bin/bash

echo 'run before_install.sh: ' >>/home/ec2-user/deploy.log

mkdir -p /var/www/html
cd /var/www/html

echo 'yum update -y' >>/home/ec2-user/deploy.log
yum update -y >>/home/ec2-user/deploy.log
echo 'yum install git docker -y' >>/home/ec2-user/deploy.log
yum install git docker -y >>/home/ec2-user/deploy.log

echo 'systemctl start docker' >>/home/ec2-user/deploy.log
systemctl start docker >>/home/ec2-user/deploy.log
echo 'systemctl enable docker' >>/home/ec2-user/deploy.log
systemctl enable docker >>/home/ec2-user/deploy.log

# echo 'git init' >> /home/ec2-user/deploy.log
# git init >> /home/ec2-user/deploy.log
# echo 'git pull https://github.com/cmthPeerapon/tic-tac-toe.git' >> /home/ec2-user/deploy.log
# git pull https://github.com/cmthPeerapon/tic-tac-toe.git >> /home/ec2-user/deploy.log
