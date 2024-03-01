## About:
* These scripts all work together to automate the creation of a hotspot via `Termux`

## How to use:
* **First**: Add the scripts to Termux's home directory 
* **Second**: Run `chmod +x setup_hotspot.sh` to maake the script executable
* **Third**: Execute the script by typing `./setup_hotspot.sh`

## Important Notes:
* **ROOT**: This script uses sudo which requires root access
* **SSID and Password**: Replace YourHotspotName and YourPassword with your desired hotspot name and password.
* **Channel**: The CHANNEL variable is set to 7, which is a common channel for Wi-Fi networks. You might need to adjust this based on your local regulations and Wi-Fi congestion.
* **Interface**: The script assumes the Wi-Fi interface is wlan0. This might vary depending on your device. You can check your Wi-Fi interface by running ip link.
* **DHCP Range**: The DHCP range is set to assign IP addresses from 192.168.1.2 to 192.168.1.100. Adjust this range as needed.
* **Permissions**: The script uses sudo for commands that require root privileges. Ensure your Termux has root access.
* **Security**: This script sets up a basic hotspot and captive portal. Ensure you understand the security implications, especially regarding the use of sudo and the handling of passwords.
