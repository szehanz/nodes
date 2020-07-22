## Bringing up a Dell Blade 

### 1. Clone Repository

<pre>
git clone https://github.com/sagecontinuum/nodes/tree/master/sage-blade/Blade-BringUp
</pre>

### 2. Prepare/Download Unattended ISO Image

For this step, instructions can be found here:  
https://github.com/sagecontinuum/nodes/tree/master/sage-blade/Blade-Image

### 3. Hosting Image Locally on Machine

To be updated...  
For now we use apache, eventually we will switch to a GO fileserver that matches machine hardware.

### 4. blade-bringup script usage

This script was built using the Redfish iDRAC API library.  
If you are interested in making changes you can find other possible iDRAC commands here:  
https://github.com/dell/iDRAC-Redfish-Scripting/tree/master/Redfish%20Python

Command Line Usage:
<pre>
chmod +x blade-bringup.sh
./blade-bringup.sh {iDRAC IP Adress} {y/n} 
# (y if iDRAC has had script run on it before)/(n if machine is in fresh state/never used)

Example:
./blade-bringup.sh 192.168.0.10 y
</pre>

#### Script run time averages around 10 minutes, but following the script the OS is still being installed which averages around 20 minutes. The machine will boot up twice after OS is installed because it is running a script to get the machine in preferred state including ssh keys to allow remote access easily.

Congratulations! You just brought up a Dell Blade!
