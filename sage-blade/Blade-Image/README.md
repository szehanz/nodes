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

Download Preseed (Link, will be included in this repository)

To make changes to this preseed there exists some documentation via ubuntu on some preseed syntax
https://help.ubuntu.com/lts/installation-guide/s390x/apbs04.html

#### After copying or modifying preseed, copy preseed into iso

cp preseed.seed iso/preseed/

#### Calculate Seed Checksum

md5sum iso/preseed/mypreseed.seed

#### Add auto-install option to install menu

We'll need to edit the file iso/isolinux/txt.cfg

At the top of the file add the option:

default install
label autoinstall
  menu label ^Auto-Install
  kernel /install/vmlinuz
  append file=/cdrom/preseed/ubuntu-server.seed initrd=/install/initrd.gz auto=true priority=high preseed/file=/cdrom/preseed/mypreseed.seed preseed/file/checksum=4e8ba65081a3ce9737670a58a35a47d8 --
  
  
#### Modifying Grub Configuration

We'll need to edit the file iso/boot/grub/grub.cfg

Following the two set menu_color lines
We need to add the menu entry for our auto-install

set timeout=1
menuentry "Auto-Install" {
	set gfxpayload=keep
	linux /install/vmlinuz append file=/cdrom/preseed/ubuntu-server.seed initrd=/install/initrd.gz auto=true priority=high preseed/file=/cdrom/preseed/mypreseed.seed quiet ---
	initrd	/install/initrd.gz
}

### 5. Generating ISO Image

From inside the iso directory
aka cd iso/

Run the following to generate the iso image

mkisofs -D -r -V "AUTOINSTALL" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../autoinstall.iso .

A bootable installable ISO will be placed in the directory before your iso folder with the name autoinstall.iso
