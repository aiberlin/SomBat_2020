#!/bin/bash
echo ""
echo "*** HELLO SOMBAT startup script ****"
echo ""

sleep 3

#sudo pkill wpa_supplicant

#sleep 1

#sudo ifconfig wlan0 down
#sudo iwconfig wlan0 mode Ad-Hoc
#sudo ifconfig wlan0 up

#sleep 5

#sudo iwconfig wlan0 essid x-OSC1
#sudo iwconfig wlan0 channel 1

###wpa_passphrase NTMI-003 NTMINTMI > /tmp/wpa_supplicant.conf
#sudo wpa_supplicant -B -Dnl80211 -iwlan0 -c/tmp/wpa_supplicant.conf

#sudo dhcpcd wlan0

###sudo ifconfig wlan0 169.254.1.2
echo "*** Killing Jack & scsynth"
pkill jackd
pkill scsynth
sleep 2
echo ""
echo "*** Resurrecting Jack"
echo ""
jackd -P75 -p32 -t2000 -dalsa -dhw:0 -p64 -n2 -s -r4800 -zs -P &
sleep 3

echo ""
echo "** Booting SClang"
echo ""

pkill Xvfb
pkill xvfb-run

Xvfb :0 & 
# fine till here, sclang comes up, boots scsynth, then sclang exists - see .logs

#echo | DISPLAY=:0 sclang /home/patch/NTMI/NTMI*/00_loadMe.scd  &> /home/patch/ntmi.log
echo | DISPLAY=:0 sclang &> /home/patch/sombat.log
