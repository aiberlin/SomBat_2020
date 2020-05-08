BlokasLabs on Raspi 3:

1st login: user name is ‘patch’ and its password is 'blokaslabs
pass: SomBat2020

IP: 
192.169.178.122

setup wizard:
sudo patchbox-config wizard
startx to run gui

successfully made autostart: 
https://www.wikihow.com/Execute-a-Script-at-Startup-on-the-Raspberry-Pi
:

sudo nano /home/pi/.config/lxsession/LXDE-pi/autostart

https://github.com/redFrik/supercolliderStandaloneRPI2
xvfb-run sclang

#// this workx fine:
jackd -P75 -p16 -t2000 -dalsa -dhw:0 -p1024 -n2 -s -r44100 &
jackd -P75 -p24 -t2000 -dalsa -dhw:0 -p64 -n2 -s -r48000 &
jackd -P75 -p32 -t2000 -dalsa -dhw:0 -p64 -n2 -s -r48000 -zs -P &
#>> 2.7 ms latency !!
#>> 1.3 ms Jack latency !!


backup OSX:
dd if=/dev/rdisk2 of=/Volumes/QUARTERA_II/PiNux-Quartera/backups/patchblox_hh_2020_03_28 bs=1m


#3Edit 
/etc/jackdrc
 to set the command line for Jack backend, if you are using a different card than Pisound.

#4Ensure that all the critical services are running, if one of them failed, the UI won’t be accessible. Start fixing from the jack service errors, then modep-mod-host and finally modep-mod-ui. Most likely cause of issues is Jack misconfiguration.
sudo systemctl status jack

#5To get MODEP to autorun on startup run:
sudo systemctl enable modep-mod-ui


//## ext drive:
on 
/dev/sda1 

mount with 
https://www.raspberrypi.org/documentation/configuration/external-storage.md
method 2 + CAVEATS !!

look if dirs 'short' and 'long' exist
if necessary, convert stuff to wav ! > ffmpeg > gonna be trouble with write permissions!!!

UUID of 1st test USB key: 
8444-1AA5
5B54-461A
-- no need, just tyoe /dec/sda1/ in fstab, and it will boot anything :)

tollgemachtizotope

##########################################
### NTMI
user: patch
password: ntmi2019
hostname: patchbox

if you connect a network cable it should be on the network via dhcp

it will look for NTMI-003 wifi network.

### Lessons from NTMI patch app:
DISPLAY=:0 sclang

start_ntmi.sh # wo is? in ~/ folder.
sagt wahrsch
echo | DISPLAY=:0 sclang /home/patch/loadme.scd &> /home/patch/ntmi.log

// .sh wird gelaunched in
/etc/.rc.local

#### me copy to my Patchbox image:
su patch -c "bash /home/patch/start_sombat2020.sh" &


// what worx and what not:
 - [systemd had almost worked, too]
 - etc/rc.local works! launches the shell script at login.
 - shell script starts jackd, OK, then sclang
 - sclang boots scsynth, OK, but sclang dies - see .log file. 
 
