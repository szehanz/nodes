import requests
import json
import urllib3


urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


print("\nUsing Redfish to mount an ISO image.") 
print("\nCurrent version assumes Server has booted to its OS OR during POST.")


proxy_url = input("\nEnter your proxy server url, if N/A, please enter none: ")


proxies = {
    "http": proxy_url,
    "https": proxy_url
}


print("\nProxy used: ", proxy_url)


ilo5_ip = input("\nEnter the iLO5 IP address of your server: ")
iso_url = input("\nEnter the url to your ISO image: ")


# Command 1
url = f"https://{ilo5_ip}/redfish/v1/sessionService/Sessions"
headers = {"Content-Type": "application/json"}
data = {"UserName": "Administrator", "Password": "password"}
response = requests.post(url, headers=headers, data=json.dumps(data), proxies=proxies, verify=False)


# Command 2
url = f"https://{ilo5_ip}/redfish/v1/sessionService/Sessions"
headers = {"Content-Type": "application/json"}
data = {"UserName": "Administrator", "Password": "password"}
response = requests.post(url, headers=headers, data=json.dumps(data), proxies=proxies, verify=False)
token = response.headers.get("X-Auth-Token")


# Command 3
url = f"https://{ilo5_ip}/redfish/v1/Managers/1/VirtualMedia/2"
headers = {"Content-Type": "application/json", "X-Auth-Token": token}

# Send the GET request to retrieve the virtual media information
response = requests.get(url, headers=headers, proxies=proxies, verify=False)

# Check the response status code
if response.status_code == 200:
    # Parse the response data as JSON
    data = json.loads(response.text)

    # Check if virtual media is attached
    if data['Inserted']:
        print("\nVirtual media is currently attached.")
        # Command 4
        url = f"https://{ilo5_ip}/redfish/v1/Managers/1/VirtualMedia/2/Actions/VirtualMedia.EjectMedia"
        headers = {"Content-Type": "application/json", "X-Auth-Token": token}
        data = {"Image": "", "Inserted": False, "WriteProtected": True}
        response = requests.post(url, headers=headers, data=json.dumps(data), proxies=proxies, verify=False)

        # Command 5
        url = f"https://{ilo5_ip}/redfish/v1/Managers/1/VirtualMedia/2"
        headers = {"Content-Type": "application/json", "X-Auth-Token": token}
        data = {"Oem": {"Hpe": {"BootOnNextServerReset": True}}}
        response = requests.patch(url, headers=headers, data=json.dumps(data), proxies=proxies, verify=False)

        # Command 6
        url = f"https://{ilo5_ip}/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"
        headers = {"Content-Type": "application/json", "X-Auth-Token": token}
        data = {"Action": "Reset", "ResetType": "ForceRestart"}
        response = requests.post(url, headers=headers, data=json.dumps(data), proxies=proxies, verify=False)

        print("\nVirtual media detached successfully, rebooting system now.\n")
    else:
        print("\nVirtual media is not currently attached.")
        # Command 7
        url = f"https://{ilo5_ip}/redfish/v1/Managers/1/VirtualMedia/2/Actions/VirtualMedia.InsertMedia"
        headers = {"Content-Type": "application/json", "X-Auth-Token": token}
        data = {"Image": iso_url, "Inserted": True, "WriteProtected": True}
        response = requests.post(url, headers=headers, data=json.dumps(data), proxies=proxies, verify=False)

        # Command 8
        url = f"https://{ilo5_ip}/redfish/v1/Managers/1/VirtualMedia/2"
        headers = {"Content-Type": "application/json", "X-Auth-Token": token}
        data = {"Oem": {"Hpe": {"BootOnNextServerReset": True}}}
        response = requests.patch(url, headers=headers, data=json.dumps(data), proxies=proxies, verify=False)

        # Command 9
        url = f"https://{ilo5_ip}/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"
        headers = {"Content-Type": "application/json", "X-Auth-Token": token}
        data = {"Action": "Reset", "ResetType": "ForceRestart"}
        response = requests.post(url, headers=headers, data=json.dumps(data), proxies=proxies, verify=False)

        print("\nISO image mounted successfully, rebooting system now.\n")
else:
    print("\nFailed to retrieve virtual media information. Error code: " + str(response.status_code))







