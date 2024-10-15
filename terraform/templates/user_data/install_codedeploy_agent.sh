#!bin/bash

echo 'Clean previous agent caches' >>/root/result.log
CODEDEPLOY_BIN="/opt/codedeploy-agent/bin/codedeploy-agent"
$CODEDEPLOY_BIN stop
yum erase codedeploy-agent -y

echo 'Install ruby and wget' >>/root/result.log
yum update
yum install ruby -y
yum install wget -y

echo 'Install agent' >>/root/result.log
cd /home/ec2-user
wget https://aws-codedeploy-${region}.s3.${region}.amazonaws.com/latest/install
chmod +x ./install
./install auto

echo 'Start agent' >>/root/result.log
systemctl start codedeploy-agent
systemctl enable codedeploy-agent
