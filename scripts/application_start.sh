#!/bin/bash

echo 'run application_start.sh: ' >>/home/ec2-user/deploy.log

echo 'docker run --name tic-tac-toe --rm -d -p 80:80 tic-tac-toe' >>/home/ec2-user/deploy.log
docker run --name tic-tac-toe --rm -d -p 80:80 tic-tac-toe >>/home/ec2-user/deploy.log
