#!/bin/bash

sudo systemctl stop tomcat.service

sudo chown tomcat:tomcat /opt/tomcat/webapps/webApp-0.0.1-SNAPSHOT.war
