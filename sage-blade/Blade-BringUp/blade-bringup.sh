#!/bin/bash
source ./utils

port=22
imageIP=-1
iDracIP=-1

# Validate Parameters
if [[ -n "$1" && -n "$2" ]]
then
	imageIP=$1
	iDracIP=$2
	
	if [[ -n "$3" &&  "$3" -eq "$3" ]] && [[ $3 -ge 0 && $3 -le 65353 ]]
	then
        	port=$3
	elif [[ -n "$3" && ! "$3" -eq "$3" ]] || [[ -n "$3" && ! $3 -ge 0 || ! $3 -le 65353 ]]
	then
		echo "The port entered is invalid please enter a port in valid range, 0 to 65353, or none at all for default 22"
		exit 1
	fi
	
	if ! valid_ip $imageIP || ! valid_ip $iDracIP
	then
		echo "One or both of the IP's you entered are not valid, IP addresses must be in IPV4 i.e. x.x.x.x where x => 0 and <= 255"
		exit 1
	fi
else
	echo "Missing a Neccessary Parameter"
	echo "Usage: "
	echo "./blade-bringup.sh [Image IP Address] [iDRAC IP Address] [iDRAC Port, optional, default 22]"
	echo "./blade-bringup.sh 192.168.9.1 192.168.9.2 58302"
	echo "./blade-bringup.sh 192.168.9.1 192.168.9.2"
	exit 1
fi


echo -e "Connecting to iDRAC at $iDracIP w/ port $port" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`

echo "Erasing all previous data and settings" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
sshpass -p calvin ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=quiet -o IdentitiesOnly=yes root@$iDracIP -p $port systemerase bios,diag,drvpack,idrac,lcdata,allapps,cryptographicerasepd,overwritepd,percnvcache,vflash,nvdimm | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
sshpass -p waggle ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=quiet -o IdentitiesOnly=yes root@$iDracIP -p $port systemerase bios,diag,drvpack,idrac,lcdata,allapps,cryptographicerasepd,overwritepd,percnvcache,vflash,nvdimm | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`

echo "All Previous Data Erased, sleeping for 12 minutes while waiting for system erase & iDRAC to reboot" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`

secs=$((12 * 60))
while [ $secs -gt 0 ]; do
   echo -ne "$secs\033[0K\r"
   sleep 1
   : $((secs--))
done

echo "Setting iDRAC password to Waggle" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'` 
sshpass -p calvin ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o IdentitiesOnly=yes root@$iDracIP -p $port set iDRAC.Users.2.Password waggle | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`

echo "Turning Blade Back On, and sleeping for 4 minutes for Lifecycle reboot" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
sshpass -p waggle ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o IdentitiesOnly=yes root@$iDracIP -p $port serveraction powerup | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`

secs=$((4 * 60))
while [ $secs -gt 0 ]; do
   echo -ne "$secs\033[0K\r"
   sleep 1
   : $((secs--))
done

echo "Rebooting, and waiting 4 minutes to identify system" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
sshpass -p waggle ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o IdentitiesOnly=yes root@$iDracIP -p $port serveraction powerup | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`

secs=$((4 * 60))
while [ $secs -gt 0 ]; do
   echo -ne "$secs\033[0K\r"
   sleep 1
   : $((secs--))
done

echo "Break SSD RAID" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`

sshpass -p waggle ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o IdentitiesOnly=yes root@$iDracIP -p $port storage converttononraid:Disk.Bay.7:Enclosure.Internal.0-1:RAID.Integrated.1-1 | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
sshpass -p waggle ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o IdentitiesOnly=yes root@$iDracIP -p $port jobqueue create RAID.Integrated.1-1 --realtime | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`

echo "Breaking Raid, sleeping for 2 minutes" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
secs=$((2 * 60))
while [ $secs -gt 0 ]; do
   echo -ne "$secs\033[0K\r"
   sleep 1
   : $((secs--))
done

echo "Ejecting any possible virtual media connected" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
sshpass -p waggle ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o IdentitiesOnly=yes root@$iDracIP -p $port remoteimage -d | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`

echo "Mounting Unattended ISO" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
sshpass -p waggle ssh -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -o LogLevel=quiet -o UserKnownHostsFile=/dev/null root@$iDracIP -p $port remoteimage -c -l http://$imageIP/blade-image.iso | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`

echo "Setting boot to ISO and rebooting" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`

sshpass -p waggle ssh -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -o LogLevel=quiet -o UserKnownHostsFile=/dev/null root@$iDracIP -p $port racadm config -g cfgServerInfo -o cfgServerFirstBootDevice vCD-DVD | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
sshpass -p waggle ssh -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -o LogLevel=quiet -o UserKnownHostsFile=/dev/null root@$iDracIP -p $port serveraction powercycle | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`

echo "Script Complete, please allow 20 minutes for OS to install and machine to be populated" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
