#!/bin/bash

# stop tomcat service
sudo rm -rf /opt/tomcat/webapps/*
sudo systemctl stop tomcat

