#! /bin/bash

#to set 2 different route, normal usage and read only filesystem
#main purpose to have two separate route is because if you have the ability to write, it is recommended to do auto updates. For read only filesystem, might be good to do periodic updates, either manual or automatic.

apt update
apt full-upgrade -y
apt install screen -y
apt install wireguard
apt install curl
# curl -L https://installpivpn.io|bash

#fail2ban installation
apt install fail2ban
#check using systemctl status fail2ban.service
