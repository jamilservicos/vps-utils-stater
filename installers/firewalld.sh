#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo"
  exit 1
fi

if test -z "$(which firewall-cmd)" 
then
  apt update
  apt install firewalld -y
  
  cp -rf ./files/firewalld/custom-services/*.xml /etc/firewalld/services/
  cp -rf ./files/firewalld/build-in-services/*.xml /etc/firewalld/services/
  
  cp -rf ./files/firewalld/custom-zones/*.xml /etc/firewalld/zones/
  cp -rf ./files/firewalld/build-in-zones/*.xml /etc/firewalld/zones/
  
  firewall-cmd --runtime-to-permanent
  firewall-cmd --complete-reload
  
  firewall-cmd ---set-default-zone zone-default
 

  firewall-cmd --runtime-to-permanent
  firewall-cmd --complete-reload
  
  systemctl enable firewalld
  fi
