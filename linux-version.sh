#!/bin/bash
#tested with ubuntu 18.04.2 
#can automate with cron

HOSTNAME=ph-1
IP="$(ip route | grep default | grep -o 192.168.43.[0-255])"
NETWORK_NAME='PH-1'

#only run if network is available
essid="$(nmcli dev wifi list | grep -o PH-1)"
[ "$essid" == "PH-1" ] || exit
#remove any hostname entries and add updated one
sudo sed -i "/$HOSTNAME/d" /etc/hosts;
sudo echo "${IP} ${HOSTNAME}" >> /etc/hosts;
