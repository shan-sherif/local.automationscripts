#! /bin/bash

#Readme Todo, provide information on SCP server config file for VPN
#create a selection of the following:
#vpn specify location of predetermined conf file
#ap specify the wlan (e.g. wlan0 wlan1) to create the accesspoint, provide SSID and password
#wireless connection, provide SSID and password for the connection you want, and check auto connect
#ntopng network monitoring, ensure service starts on boot

#disable swap
#check usage by using free -h
systemctl disable dphys-swapfile.service

echo "perform updates"
apt update
apt full-upgrade -y
apt install screen -y
apt install wireguard -y
#wg genkey | tee private.key | wg pubkey > public.key

echo "setting up wireguard vpn using config provided"
nmcli connection import type  wireguard file $filename

echo "setting up ap to access"
nmcli connection add type wifi ifname $wlan? con-name AP 802-11-wireless.mode ap 802-11-wireless.band a 802-11-wireless.mode ap ssid $ssidname
nmcli connection modify AP 802-11-wireless-security.key-mgmt wpa-psk wifi-sec.psk $password ipv4.method shared ipv6.method ignore
nmcli connection up AP

#you can use nmcli device wifi list / nmcli device wifi list ifname wlan0 to scan for wifi to connect to
echo "setting up wireless connection"
nmcli device wifi connect $ssid password $password ifname $wlan?
nmcli connection modify $ssid connection.autoconnect yes
#use nmcli connection show $ssid for more info (e.g. if it is autoconnect)

echo "installing ntopng"
wget http://packages.ntop.org/RaspberryPI/apt-ntop.deb
dpkg -i apt-ntop.deb
apt update
apt install ntopng nprobe n2n -y
#you can check the status using systemctl status ntopng
