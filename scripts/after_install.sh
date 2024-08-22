#!/bin/bash

echo 'run after_install.sh: ' >>/home/ec2-user/deploy.log

cd /var/www/html

echo 'docker build -t tic-tac-toe .' >>/home/ec2-user/deploy.log
docker build -t tic-tac-toe . >>/home/ec2-user/deploy.log
