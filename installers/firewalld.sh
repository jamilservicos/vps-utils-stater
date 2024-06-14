#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with root"
  exit 1
fi

if test -z "$(which firewall-cmd)" 
then
  apt update
  apt install firewalld -y

  EXTERNAL_INTERFACE=$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")
  sed -i "s/eth0/$EXTERNAL_INTERFACE/g" "files/firewalld/build-in-zones/external.xml"
  
  cp -rf ./files/firewalld/custom-services/*.xml /etc/firewalld/services/
  cp -rf ./files/firewalld/build-in-services/*.xml /etc/firewalld/services/
    
  cp -rf ./files/firewalld/custom-zones/*.xml /etc/firewalld/zones/
  cp -rf ./files/firewalld/build-in-zones/*.xml /etc/firewalld/zones/

  cp -rf ./files/firewalld/custom-policies/*.xml /etc/firewalld/policies/
  
  firewall-cmd --runtime-to-permanent
  firewall-cmd --complete-reload
  
  firewall-cmd ---set-default-zone zone-default
 

  firewall-cmd --runtime-to-permanent
  firewall-cmd --complete-reload
  
  systemctl enable firewalld
fi

while true; do

read -p "Do you want to clean the screen? (y/N) " yn

case $yn in 
	[yY] ) clear;
		break;;
	[nN] ) exit;;
	* ) exit;;
esac

done
