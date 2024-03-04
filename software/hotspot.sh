#!/bin/bash

# This bash script will automate the process of setting everyting up, all you have to do is set the name and password
# All comments here are to help users understand how it works!


# CHECK-ROOT FUNCTION!
checkRoot() {
  if [[ $EUID -ne 0 ]]; then
    clear
    echo "rooted"
    sleep 1
    clear

    # Loading Animation
    echo "Launching."
    sleep 1
    clear
    echo "Launching.."
    sleep 1
    clear
    echo "Launching..."
    sleep 1
    clear

    echo "Done!" # Sorry for the loading animation
    clear

  else
    # Not rooted message
    echo "Please root!"
    sleep 2
  fi
}



# Call the function
checkRoot

# Prompt the user for the hotspot name and password
echo "Set Name:"
read SSID
echo "Set Password::"
read PASSWORD

# Prompt for additional configuration options
echo "Enter the channel (default is 7):"
read CHANNEL
if [ -z "$CHANNEL" ]; then
    CHANNEL=7
fi

# Define other variables
INTERFACE="wlan0"
DHCP_RANGE="192.168.1.2,192.168.1.100,255.255.255.0,12h"

# Stop instances
sudo killall hostapd dnsmasq

# Configure hostapd
cat > /etc/hostapd/hostapd.conf <<EOL
interface=$INTERFACE
driver=nl80211
ssid=$SSID
hw_mode=g
channel=$CHANNEL
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=$PASSWORD
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOL

# Start hostapd
sudo hostapd /etc/hostapd/hostapd.conf &

# Configure dnsmasq
cat > /etc/dnsmasq.conf <<EOL
interface=$INTERFACE
dhcp-range=$DHCP_RANGE
EOL

# Start dnsmasq
sudo dnsmasq &

# Configure IP forwarding and NAT
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i $INTERFACE -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i eth0 -o $INTERFACE -j ACCEPT

# Start web server
python server.py &

echo "Done!"
clear
echo "Hotspot Started"
echo "Captcha Portal Started"
echo " "
echp "You can now have other devices connect!"


# © 2024 Termux-Hotspot | by - CPScript/Disease
