#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with root"
  exit 1
fi

if test -z "$(which fail2ban-client)" 
then
  apt update
  apt install fail2ban -y
    
  cp -rf ./files/fail2ban/etc/* /etc/fail2ban
  firewall-cmd --complete-reload

  systemctl restart fail2ban.service
  systemctl enable fail2ban.service

  firewall-cmd --runtime-to-permanent
  firewall-cmd --complete-reload
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
