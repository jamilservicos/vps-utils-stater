#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with root"
  exit 1
fi

OLDBACKUP=$(date +%s)
NEW_PORT=$(bash ./utils/random_port.sh)
OLD_PORT=$(firewall-cmd --permanent --service ssh --get-ports)
N_OLD_PORT=$(echo $OLD_PORT | sed 's|[^0-9]||g')
SSHD_OLD_PORT="Port ${N_OLD_PORT}"

if ! getent group "sshusers" >/dev/null; then
  groupadd sshusers tunnelonly
fi

case $1 in
    *[!0-9]* )  echo "$1 is not all numeric";;
esac

if [ $(echo  "$1"  | egrep "^[0-9]+$") ] && [ "$1" -ne 0 ]
then
 NEW_PORT=$1
fi

SSHD_NEW_PORT="Port ${NEW_PORT}"

firewall-cmd --permanent --service ssh --add-port ${NEW_PORT}/tcp
firewall-cmd --permanent --service ssh --remove-port $OLD_PORT
firewall-cmd --complete-reload
firewall-cmd --permanent --service ssh --get-ports

echo $(firewall-cmd --permanent --service ssh --get-ports) > sshd_active_port.txt
echo $OLD_PORT > sshd_old_port.txt

cp "/etc/ssh/sshd_config" "/etc/ssh/sshd_config_${OLDBACKUP}"

sed -i  "s:$SSHD_OLD_PORT:$SSHD_NEW_PORT:g" "files/sshd/etc/sshd_config"
cp -rf "files/sshd/etc/sshd_config" "/etc/ssh/sshd_config"

systemctl restart ssh
