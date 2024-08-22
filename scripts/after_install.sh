#!/bin/bash

echo 'run after_install.sh: ' >>/home/ec2-user/deploy.log

cd /var/www/html

echo 'docker buildx create --driver=docker-container --use' >>/home/ec2-user/deploy.log
docker buildx create --driver=docker-container --use >>/home/ec2-user/deploy.log
echo 'docker buildx build --cache-from=type=local,src=cache --cache-to=type=local,dest=cache -t tic-tac-toe --load .' >>/home/ec2-user/deploy.log
docker buildx build --cache-from=type=local,src=cache --cache-to=type=local,dest=cache -t tic-tac-toe --load . >>/home/ec2-user/deploy.log
