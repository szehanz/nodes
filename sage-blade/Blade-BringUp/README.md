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

#### Script run time averages around 15 minutes, but following the script the OS is still being installed which averages around 20 minutes. The machine will boot up twice after OS is installed because it is running a script to get the machine in preferred state including ssh keys to allow remote access easily.

### 3. Post-Scipt Installation

After the OS has been installed on the machine there is still work to do. After waiting the allotted time for the OS to be installed, ~20 minutes, you need to ssh to the iDRAC IP address.

<pre>
ssh root@{iDRAC IP Adress}

or 

sshpass -p waggle ssh root@{iDRAC IP Adress}
</pre>

#### Password at this point should be 'waggle' 

Once you've connected, we need to start talking to the blade itself through the com2 port.

<pre>
console com2
</pre>

Now, we can execute the script that should connect us to the beehive and get the machine in it's correct initial state.

<pre>
chmod +x manual-first-boot.sh
./manual-first-boot.sh
...
reboot
</pre>

#### Please contact ozorob@anl.gov for decryption key, if you think you should have access.
Finally, simply reboot the machine.

Congratulations! You just brought up a Dell Blade!
