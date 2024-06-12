# vps-utils-stater
### script to help the standard installation of a vps with: fail2ban + cloudflare tunnel + firewalld + docker + openVPN

### Log in with your root on the vps that was just created, proceed as described below.

~~~bash
mkdir vps-automation && cd vps-automation
bash <(curl -s https://raw.githubusercontent.com/jamilservicos/vps-utils-stater/main/install.sh)
~~~

# ATTENTION     
## shell script created for vps ubuntu 22.04.       
## Make the necessary modifications for compatibility of different versions, if necessary.


#### After running `install.sh`, perform additional configurations such as creating a user, configuring sshd, running the openvpn server and configuring access.
