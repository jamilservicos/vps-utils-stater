#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run with root"
    exit 1
fi

if ! [ -d "./installers" ]; then
    wget https://github.com/jamilservicos/vps-utils-stater/archive/refs/heads/main.zip -O vps-utils-stater.zip
    if test -x "$(which unzip)"; then
        apt install unzip -y
    fi
    unzip -q vps-utils-stater.zip
    mv vps-utils-stater-main/* .
    rm -rf vps-utils-stater*
fi

if [ -d "./installers" ]; then
    chmod -x install.sh
    chmod -x installers/*.sh
    bash installers/firewalld.sh
    bash installers/docker-ce.sh
    bash installers/fail2ban.sh
fi
