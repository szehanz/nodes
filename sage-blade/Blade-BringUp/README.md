## Bringing up a Dell Blade 

### 1. Clone Repository

<pre>
git clone https://github.com/sagecontinuum/nodes.git
cd nodes/sage-blade/Blade-BringUp
</pre>

### 2. blade-bringup script usage

Command Line Usage:
<pre>
chmod +x blade-bringup.sh
./blade-bringup.sh {OS-Image IP Adress} {iDRAC IP Adress} {Port (default: 22)}

Example:
./blade-bringup.sh 10.0.0.50 192.168.0.10 52320
./blade-bringup.sh 10.0.0.50 192.168.0.10
</pre>

#### Script run time averages around 15 minutes, but following the script the OS is still being installed which averages around 20 minutes. The machine will boot up twice after OS is installed because it is running a service to get the machine in preferred state.

### 3. Post-Scipt Installation

After the OS has been installed on the machine there is still work to do. After waiting the allotted time for the OS to be installed, ~20 minutes, you need to ssh to the iDRAC IP address.

<pre>
ssh root@{iDRAC IP Address}

or 

sshpass -p waggle ssh root@{iDRAC IP Address}
</pre>

#### Password at this point should be 'waggle' 

Once you've connected, we need to start talking to the blade itself through the com2 port.

<pre>
console com2
</pre>

Now, we can execute the script that should connect us to the beehive and get the machine in it's correct initial state.

<pre>
/etc/waggle/unlock_registration.sh
# Still need to configure network
# For DHCP
rm /etc/NetworkManager/conf.d/99-disabled.conf
# For static interface configurations
# modify /etc/network/interfaces and read top comment for more information
# Finally restart Network-Manger service
systemctl restart NetworkManager
</pre>

#### Please contact us via https://docs.waggle-edge.ai/docs/contact-us for decryption key, if you think you should have access.

Congratulations! You just brought up a Dell Blade!
