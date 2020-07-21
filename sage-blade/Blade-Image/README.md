## A. Building Custom Unattended OS Image 

### 1. Download Image

wget http://cdimage.ubuntu.com/releases/18.04/release/ubuntu-18.04.4-server-amd64.iso

### 2. Mount image

mkdir /mnt/iso
mount -o loop ubuntu-18.04.4-server-amd64.iso /mnt/iso/

### 3. Make a copy of image that's not read-only

mkdir iso
cp -rT /mnt/iso/ iso/

### 4. Modifying ISO Image

#### Adding Preseed File for Unattended Install

##### Download Preseed File from Repository

-Add Link Here (will be included in this repository)

To make changes to this preseed there exists some documentation via ubuntu on some preseed syntax

https://help.ubuntu.com/lts/installation-guide/s390x/apbs04.html

#### After copying or modifying preseed, copy preseed into iso

cp preseed.cfg iso/preseed/
