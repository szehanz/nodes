#!/bin/bash

apt-get -y update 
apt-get -y upgrade 
apt-get -y install ssh ansible git htop iotop iftop bwm-ng screen nmap docker

sed -i '/efi/d' /etc/fstab
sed -i '/home/d' /etc/fstab

umount /dev/sda1
umount /dev/sda3

mkdir ~/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEScCdR3mr+QgCnuvGSwsjw1lmatwrHvVvUtEoc7du5vCMTXT25L3rqhaG8Ngy4OTAfVEtSR0qfgJ6UrH1oyacPMBYAETOfnHqKqoi1Dcej9f3+QuBNA7pOIjLK2jqbK+VGPHEM9NVKXb8XbcL9mpn+sKy4f2J1kRMD79+5R+8EbV2jVcwwOa/1+bsbF/jtGlmoHD4RbNHrO65Y2BuLpQMYSv4Q0lwwe/pwYSYgCkeD0ve9XfwZktnluYyOQjaTw+qyMpNjfYCfWDHZtKHeUCRcNgpXydcJ6Obc/h9kQQC1ZWU1GDc+BFWwo/ZLrHeedilggUwRTqpM9j3lYPi1NfX /home/rajesh/.ssh/id_rsa_waggle_user" >> ~/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsYPMSrC6k33vqzulXSx8141ThfNKXiyFxwNxnudLCa0NuE1SZTMad2ottHIgA9ZawcSWOVkAlwkvufh4gjA8LVZYAVGYHHfU/+MyxhK0InI8+FHOPKAnpno1wsTRxU92xYAYIwAz0tFmhhIgnraBfkJAVKrdezE/9P6EmtKCiJs9At8FjpQPUamuXOy9/yyFOxb8DuDfYepr1M0u1vn8nTGjXUrj7BZ45VJq33nNIVu8ScEdCN1b6PlCzLVylRWnt8+A99VHwtVwt2vHmCZhMJa3XE7GqoFocpp8TxbxsnzSuEGMs3QzwR9vHZT9ICq6O8C1YOG6JSxuXupUUrHgd /home/rajesh/.ssh/id_rsa_waggle_aot" >> ~/.ssh/authorized_keys

sed -e 's|overlayroot=""|overlayroot="device:dev=/dev/sda3,timeout=180"|' /etc/overlayroot.conf > tmp.txt
cp tmp.txt /etc/overlayroot.conf
rm tmp.txt

#wget https://raw.githubusercontent.com/ozorob2/late_command_pub/master/install-docker-and-nvidia.yml
#ansible-playbook install-docker-and-nvidia.yml

rm /etc/rc.local
reboot
