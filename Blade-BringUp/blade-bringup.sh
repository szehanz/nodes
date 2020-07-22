#!/bin/bash

echo "Connecting to iDRAC at $1"

if [[ $2 == "y" ]]
then
	echo "Machine Previously In Use"
	echo "Erasing all previous data and settings"
	python3 SystemEraseREDFISH.py -ip $1 -u root -p waggle -c AllApps,BIOS,CryptographicErasePD,DIAG,DrvPack,IDRAC,LCData,OverwritePD,PERCNVCache > output.txt
else
        echo "Fresh iDRAC Install"
	echo "Erasing All Possible Stored Data"
	python3 SystemEraseREDFISH.py -ip $1 -u root -p calvin -c AllApps,BIOS,CryptographicErasePD,DIAG,DrvPack,IDRAC,LCData,OverwritePD,PERCNVCache > output.txt
fi

echo "All Previous Data Erased, sleeping for 5 minutes while waiting for iDRAC to reboot"
sleep 300

echo "Setting iDRAC password to Waggle"
python3 ChangeIdracUserPasswordREDFISH.py -ip $1 -u root -p calvin -id 2 -np waggle >> output.txt

echo "Turning Blade Back On, and sleeping for 3 minutes for Lifecycle reboot"
python3 SetPowerStateREDFISH.py -ip $1 -u root -p waggle -r PushPowerButton >> output.txt

sleep 180

echo "Grabbing Machine ID, nowhere to send it for now"
python3 ExportSystemConfigurationLocalREDFISH.py -ip $1 -u root -p waggle -t IDRAC > system.txt
sed -n 16p system.txt

echo "Break SSD RAID"
python3 ConvertToNonRAIDREDFISH.py -ip $1 -u root -p waggle -n Disk.Bay.7:Enclosure.Internal.0-1:RAID.Integrated.1-1

echo "Ejecting any possible virtual media connected"
python3 InsertEjectVirtualMediaREDFISH.py -ip $1 -u root -p waggle -o 2 -d 1

echo "Mounting Unattended ISO"
python3 InsertEjectVirtualMediaREDFISH.py -ip $1 -u root -p waggle -o 1 -d 1 -i http://192.168.0.10/mini.iso

echo "Setting boot to ISO and rebooting"
python3 SetNextOneTimeBootVirtualMediaDeviceOemREDFISH.py -ip $1 -u root -p waggle -d 1 -r y

echo "Script Complete, please allow 20 minutes for OS to install and machine to be populated"
