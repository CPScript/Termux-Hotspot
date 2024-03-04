> WARNING! This information can be used for phishing attacks, phone camera hacking, and malicious `apk` file downloads, please be cautious and don't download anything if asked to by a webpage to allow you to connect!

# USING INTERNET CONNECTION
> ABOUT: Information on how to `host a hotspot using a network connection from a router/data for free using Termux`

## Step 1: Install Termux
First, ensure you have Termux installed on your Android device. If you don't have it yet, you can download it from the Google Play Store or F-Droid.

## Step 2: Grant Termux Permissions
For Termux to create a hotspot, it needs certain permissions. Open Termux and type the following command to request root access:
```
su
``` 
You might need to grant root permissions to Termux in your device's settings. (you will need to install the termux root repo!)

## Step 3: Check for Wi-Fi Adapter
Before proceeding, ensure your device has a Wi-Fi adapter that supports AP (Access Point) mode. You can check this by running:
```
ip link
``` 
Look for a device named `wlan0` or similar, which indicates a Wi-Fi adapter.

## Step 4: Create the Hotspot
To create a hotspot, you'll use the `hostapd` tool. First, you need to install it. Since Termux doesn't have `hostapd` in its repositories, you'll need to download and compile it from source. This process can be complex and requires a good understanding of Linux and compilation processes.

Alternatively, you can use a precompiled binary if available. However, finding and using such binaries can pose security risks, especially if they're not from a trusted source.

## Step 5: Configure the Hotspot
After installing `hostapd`, you need to configure it. Create a configuration file, for example, `hostapd.conf`, with the following content:

```conf
interface=wlan0
driver=nl80211
ssid=Your_Hotspot_Name            < EDIT | numbers and letters only!
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=Your_Password      < EDIT | numbers and letters only!
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
```

Replace `Your_Hotspot_Name` with the name you want for your hotspot and `Your_Password` with a strong password.

## Step 6: Start the Hotspot
With the configuration file in place, you can start the hotspot by running:
```
hostapd hostapd.conf
```
This command starts the hotspot with the settings defined in `hostapd.conf`.


## Step 7: Enable IP Forwarding
To allow devices connected to your hotspot to access the internet, you need to enable IP forwarding. Run:
```
echo 1 > /proc/sys/net/ipv4/ip_forward
```

## Step 8: Configure NAT
To route traffic from the hotspot to the internet, you need to set up NAT (Network Address Translation). Assuming your device's internet connection is on `eth0`, run:
```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

## Step 9: DHCP Server
To assign IP addresses to devices connecting to your hotspot, you can use a `DHCP` server. This step is optional but recommended for a fully functional hotspot.

### Security Considerations
Creating a hotspot exposes your device to potential security risks, especially if it's connected to the internet. Ensure you have strong security measures in place, such as using `WPA2` for encryption and regularly updating your hotspot's software.






