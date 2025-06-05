#! /bin/bash

#Readme Todo, provide information on SCP server config file for VPN
#create a selection of the following:
#vpn specify location of predetermined conf file
#ap specify the wlan (e.g. wlan0 wlan1) to create the accesspoint, provide SSID and password
#wireless connection, provide SSID and password for the connection you want, and check auto connect
#ntopng network monitoring, ensure service starts on boot

#disable swap
#check usage by using free -h
#systemctl disable dphys-swapfile.service
#sudo dphys-swapfile swapoff
#sudo systemctl disable dphys-swapfile
#sudo apt remove --purge dphys-swapfile

#disable updates
#sudo systemctl mask apt-daily-upgrade
#sudo systemctl mask apt-daily
#sudo systemctl disable apt-daily-upgrade.timer
#sudo systemctl disable apt-daily.timer

#check other servvices by running sudo systemctl --type=service --state=running

#disable swap and filesystem checks.
#nano /boot/cmdline.txt
#add fsck.mode=skip, resulting line should look like this
#console=?? console=tty1 root=PARTUUID=?? rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait fsck.mode=skip

#change ntp instead of systemd-timesyncd as filesystem is now read only
#
#sudo nano /etc/fstab
#add commit=30 to 3rd line (defaults,noatime,commit=X)

#tmpfs /tmp tmpfs defaults,noatime,size=100m  0 0
#tmpfs /var/tmp tmpfs defaults,noatime,size=50m 0 0
#tmpfs /var/log tmpfs defaults,noatime,size=100m 0 0

#you can use sudo du -hs /path to check the file sizes of each
#use this if you want to prevent suid run on var/log
#tmpfs /var/log tmpfs defaults,noatime,nosuid,size=100m 0 0

#change PARTUUID=xxxx-xx / ext4 defaults,noatime,ro 0 1
#by adding ro, it becomes read only, alternatively you can do an overlay filesystem (you can do so on raspi-config)

#check if overlay setup is done correctly if using raspi-config with mount | grep overlay

#make sure the following are located on your device, if not, create files for them.
#sudo mkdir -p /var/log /var/tmp /var/lib/systemd
#sudo touch /var/log/wtmp /var/log/btmp

#check if mounted fs is ro by using
#mount | grep "on / "

#add the following alias to switch on ro and rw if there is a need to perform changes.
#alias ro='sudo mount -o remount,ro /'
#alias rw='sudo mount -o remount,rw /'


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
