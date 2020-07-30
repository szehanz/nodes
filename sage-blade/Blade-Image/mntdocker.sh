#!/bin/bash -e

mkdir -p /media/plugin-data/
rm -rf /var/lib/docker
ln -s /media/plugin-data/ /var/lib/docker

mount /dev/sda3 /media/plugin-data/

logger "Docker mount: [$(mount | grep /dev/sda3)]"
