#!/bin/bash

sudo systemctl stop tomcat.service

sudo rm -rf /var/lib/tomcat/webapps/*

#sudo chown tomcat:tomcat /var/lib/tomcat/webapps/webApp-0.0.1-SNAPSHOT.jar
