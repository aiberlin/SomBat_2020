#!/bin/bash

sleep 20

#sudo pkill wpa_supplicant

#sleep 1

#sudo ifconfig wlan0 down
#sudo iwconfig wlan0 mode Ad-Hoc
#sudo ifconfig wlan0 up

#sleep 5

#sudo iwconfig wlan0 essid x-OSC1
#sudo iwconfig wlan0 channel 1

wpa_passphrase NTMI-003 NTMINTMI > /tmp/wpa_supplicant.conf
#sudo wpa_supplicant -B -Dnl80211 -iwlan0 -c/tmp/wpa_supplicant.conf

#sudo dhcpcd wlan0

sudo ifconfig wlan0 169.254.1.2

pkill Xvfb
pkill xvfb-run

Xvfb :0 & 
echo | DISPLAY=:0 sclang /home/patch/NTMI/NTMI*/00_loadMe.scd  &> /home/patch/ntmi.log
