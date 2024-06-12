#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with root"
  exit 1
fi

if test -z "$(which docker)" 
then
  apt update
  apt apt install apt-transport-https ca-certificates curl gnupg -y
  
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null
  
  apt update
  apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin -y
  
  systemctl stop docker.service
  systemctl stop docker.socket
  
  cp -rf ./files/docker/etc/* /etc/docker
  firewall-cmd --complete-reload
  
  DOCKER_INET=$(ip -f inet addr show docker0  | grep 'inet ' | tr -s ' ' | cut -d" " -f3)
  firewall-cmd --permanent --zone docker --add-source $DOCKER_INET
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
