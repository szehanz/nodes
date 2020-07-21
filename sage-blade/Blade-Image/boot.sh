#!/bin/bash

apt-get -y update 
apt-get -y upgrade 
apt-get -y install ssh ansible git htop iotop iftop bwm-ng screen nmap docker

sed -i '/efi/d' /etc/fstab
sed -i '/home/d' /etc/fstab

umount /dev/sda1
umount /dev/sda3

mkdir ~/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEScCdR3mr+QgCnuvGSwsjw1lmatwrHvVvUtEoc7du5vCMTXT25L3rqhaG8Ngy4OTAfVEtSR0qfgJ6UrH1oyacPMBYAETOfnHqKqoi1Dcej9f3+QuBNA7pOIjLK2j>
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsYPMSrC6k33vqzulXSx8141ThfNKXiyFxwNxnudLCa0NuE1SZTMad2ottHIgA9ZawcSWOVkAlwkvufh4gjA8LVZYAVGYHHfU/+MyxhK0InI8+FHOPKAnpno1wsTR>

sed -e 's|overlayroot=""|overlayroot="device:dev=/dev/sda3,timeout=180"|' /etc/overlayroot.conf > tmp.txt
cp tmp.txt /etc/overlayroot.conf

#wget https://raw.githubusercontent.com/ozorob2/late_command_pub/master/install-docker-and-nvidia.yml
#ansible-playbook install-docker-and-nvidia.yml

rm /etc/rc.local
reboot
