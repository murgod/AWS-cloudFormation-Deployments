#!/bin/bash

# stop tomcat service
sudo rm -rf /var/lib/tomcat/webapps/*
sudo service tomcat stop

