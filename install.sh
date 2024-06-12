#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with root"
  exit 1
fi

chmod +x installers/*.sh
bash installers/firewalld.sh
bash installers/docker-ce.sh
bash installers/fail2ban.sh
