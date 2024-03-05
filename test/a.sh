#!/bin/bash

# Constants and Variables
HOSTAPD_CONF="/etc/hostapd/hostapd.conf"
DNSMASQ_CONF="/etc/dnsmasq.conf"
INTERFACE="wlan0"
DHCP_RANGE="192.168.1.2,192.168.1.100,255.255.255.0,12h"

# Function to check root privileges
checkRoot() {
  if [[ $EUID -ne 0 ]]; then
    echo "Please run the script as root!"
    exit 1
  fi
}

# Function to check command existence
checkCommand() {
  command -v $1 > /dev/null 2>&1 || { echo >&2 "$1 is not installed. Aborting."; exit 1; }
}

# Function to set up hostapd
setupHostapd() {
  cat > $HOSTAPD_CONF <<EOL
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

  sudo hostapd $HOSTAPD_CONF &
}

# Function to set up dnsmasq
setupDnsmasq() {
  cat > $DNSMASQ_CONF <<EOL
  interface=$INTERFACE
  dhcp-range=$DHCP_RANGE
  EOL

  sudo dnsmasq &
}

# Function to set up IP forwarding and NAT
setupIPForwarding() {
  sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  sudo iptables -A FORWARD -i $INTERFACE -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
  sudo iptables -A FORWARD -i eth0 -o $INTERFACE -j ACCEPT
}

# Main Script

# Check root privileges
checkRoot

# Check required commands
checkCommand "hostapd"
checkCommand "dnsmasq"
checkCommand "python"

# Prompt the user for hotspot name and password
echo "Set Name:"
read -r SSID
echo "Set Password:"
read -r PASSWORD

# Prompt for additional configuration options
echo "Enter the channel (default is 7):"
read -r CHANNEL
CHANNEL=${CHANNEL:-7}

# Stop instances
sudo killall hostapd dnsmasq

# Set up hostapd
setupHostapd

# Set up dnsmasq
setupDnsmasq

# Set up IP forwarding and NAT
setupIPForwarding

# Start web server
echo "starting server.py"
sleep 1
python server.py &

# Alert
echo "Captcha Portal Started"
sleep 1
clear

echo "Your hotspot is up and running, please be responsible"
echo "You can now have other devices connect!"
