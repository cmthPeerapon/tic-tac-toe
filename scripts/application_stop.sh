#!/bin/bash

echo 'run application_stop.sh: ' >>/home/ec2-user/deploy.log

docker stop tic-tac-toe >>/home/ec2-user/deploy.log
