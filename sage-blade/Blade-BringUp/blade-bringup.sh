#!/bin/bash

echo -e "Connecting to iDRAC at $1" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`

echo "Erasing all previous data and settings" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
python3 SystemEraseREDFISH.py -ip $1 -u root -p calvin -c AllApps,BIOS,CryptographicErasePD,DIAG,DrvPack,IDRAC,LCData,OverwritePD,PERCNVCache | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'` > error.log
python3 SystemEraseREDFISH.py -ip $1 -u root -p waggle -c AllApps,BIOS,CryptographicErasePD,DIAG,DrvPack,IDRAC,LCData,OverwritePD,PERCNVCache | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'` >> error.log

echo "All Previous Data Erased, sleeping for 5 minutes while waiting for iDRAC to reboot" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
#sleep 300
secs=$((5 * 60))
while [ $secs -gt 0 ]; do
   echo -ne "$secs\033[0K\r"
   sleep 1
   : $((secs--))
done

echo "Setting iDRAC password to Waggle" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'` 
python3 ChangeIdracUserPasswordREDFISH.py -ip $1 -u root -p calvin -id 2 -np waggle | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'` >> error.log

echo "Turning Blade Back On, and sleeping for 3 minutes for Lifecycle reboot" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
python3 SetPowerStateREDFISH.py -ip $1 -u root -p waggle -r PushPowerButton | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'` >> error.log

#sleep 180
secs=$((3 * 60))
while [ $secs -gt 0 ]; do
   echo -ne "$secs\033[0K\r"
   sleep 1
   : $((secs--))
done

echo "Rebooting, and waiting 4 minutes to identify system" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
python3 SetPowerStateREDFISH.py -ip $1 -u root -p waggle -r PushPowerButton | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'` >> error.log

#sleep 180
secs=$((4 * 60))
while [ $secs -gt 0 ]; do
   echo -ne "$secs\033[0K\r"
   sleep 1
   : $((secs--))
done

echo "Break SSD RAID" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
python3 ConvertToNonRAIDREDFISH.py -ip $1 -u root -p waggle -n Disk.Bay.7:Enclosure.Internal.0-1:RAID.Integrated.1-1 | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'` >> error.log

echo "Grabbing Machine ID, nowhere to send it for now" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
python3 ExportSystemConfigurationLocalREDFISH.py -ip $1 -u root -p waggle -t IDRAC > system.txt
sed -n 16p system.txt

echo "Ejecting any possible virtual media connected" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
python3 InsertEjectVirtualMediaREDFISH.py -ip $1 -u root -p waggle -o 2 -d 1 | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'` >> error.log

echo "Mounting Unattended ISO" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
python3 InsertEjectVirtualMediaREDFISH.py -ip $1 -u root -p waggle -o 1 -d 1 -i http://10.0.0.10/greenhouse.iso | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'` >> error.log

echo "Setting boot to ISO and rebooting" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
python3 SetNextOneTimeBootVirtualMediaDeviceOemREDFISH.py -ip $1 -u root -p waggle -d 1 -r y | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'` >> error.log

echo "Script Complete, please allow 20 minutes for OS to install and machine to be populated" | xargs -L 1 echo `date +'[%Y-%m-%d %H:%M:%S]'`
