 #!/bin/bash

 function key_generate() {
 ssh-keygen -t ed25519 -C "tunnel user $1" -P "" -f /home/$1/.ssh/key_ed25519
 cat /home/$1/.ssh/key_ed25519
 cp /home/$1/.ssh/key_ed25519.pub /home/$1/.ssh/authorized_keys
 chown -R ${1}.${1}  /home/$1/.ssh 
 }

function create_admin_user() {
 useradd --home-dir /home/$1 $1
 echo "${1} ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/${1}"
 usermod -aG sshusers $1
 key_generate
}
function create_tunnel_user() {
 useradd --home-dir /home/$1 $1
 usermod $1-s /usr/sbin/nologin
 usermod -aG tunnelonly $1
 key_generate
}
