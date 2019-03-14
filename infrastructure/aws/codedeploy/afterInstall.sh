#!/bin/bash

cd /home/centos/webapp
sudo chown -R centos:centos /home/centos/webapp/*
sudo chmod +x webApp-0.0.1-SNAPSHOT.jar
source /etc/profile.d/envvariable.sh
nohup java -jar webApp-0.0.1-SNAPSHOT.jar > /home/centos/webapp_logs.txt
