## Building Custom Unattended OS Image 

### 1. Download Image

<pre>
wget http://cdimage.ubuntu.com/releases/18.04/release/ubuntu-18.04.4-server-amd64.iso
</pre>

### 2. Mount image

<pre>
mkdir /mnt/iso  
mount -o loop ubuntu-18.04.4-server-amd64.iso /mnt/iso/  
</pre>

### 3. Make a copy of image that's not read-only

<pre>
mkdir iso  
cp -rT /mnt/iso/ iso/  
</pre>

### 4. Modifying ISO Image

#### Adding Preseed File for Unattended Install

Download Preseed (Link, will be included in this repository)
<pre>
wget https://raw.githubusercontent.com/sagecontinuum/nodes/master/sage-blade/Blade-Image/greenhouse.seed
</pre>

(You will see greenhouse.seed in this folder, including the txt.cfg and grub.cfg, but I use mypreseed.seed as the example)

To make changes to this preseed there exists some documentation via ubuntu on some preseed syntax
https://help.ubuntu.com/lts/installation-guide/s390x/apbs04.html

--- One important change you might wish to make is to the preseed-late-command, runs after installing the os, which is at the end of the preseed file. In this  preseed the late command grabs a script and runs it at first boot by placing it in /etc/rc.local, you don't need to rebuild the iso everytime you change the script. However, everytime you move the script to a new location you will. 

<pre>
d-i preseed/late_command string chroot /target curl -L -o /etc/rc.local https://raw.githubusercontent.com/ozorob2/late_command_pub/master/boot.sh ; chroot /target chmod +x /etc/rc.local ;
</pre>

#### After copying or modifying preseed, copy preseed into iso

<pre>
cp mypreseed.seed iso/preseed/
</pre>

#### Calculate Seed Checksum

<pre>
md5sum iso/preseed/mypreseed.seed
</pre>

#### Add auto-install option to install menu

We'll need to edit the file iso/isolinux/txt.cfg

At the top of the file add the option:

<pre>
default install 
label autoinstall  
  menu label ^Auto-Install  
  kernel /install/vmlinuz  
  append file=/cdrom/preseed/ubuntu-server.seed initrd=/install/initrd.gz auto=true priority=high preseed/file=/cdrom/preseed/mypreseed.seed preseed/file/checksum=4e8ba65081a3ce9737670a58a35a47d8 --  
</pre>
  
#### Modifying Grub Configuration

We'll need to edit the file iso/boot/grub/grub.cfg

Following the two set menu_color lines
We need to add the menu entry for our auto-install

<pre>
set timeout=1  
menuentry "Auto-Install" {  
	set gfxpayload=keep  
	linux /install/vmlinuz append file=/cdrom/preseed/ubuntu-server.seed initrd=/install/initrd.gz auto=true priority=high preseed/file=/cdrom/preseed/mypreseed.seed quiet ---  
	initrd	/install/initrd.gz  
}
</pre>

### 5. Generating ISO Image

From inside the iso directory
aka cd iso/

Run the following to generate the iso image
<pre>
mkisofs -D -r -V "AUTOINSTALL" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../autoinstall.iso .
</pre>

A bootable installable ISO will be placed in the directory before your iso folder with the name autoinstall.iso
