# SomBat_2020 Linux System
 
 based on [pi-core Linux](https://www.fredrikolofsson.com/f0blog/?q=node/672). 
 "piCore has many advantages over the common Raspbian system. It will boot a lot faster, is extremely light weight and is easy to customise. And because the whole system always resides in RAM, SD card wear is minimal. Its immutable-by-default design means one can unplug the power to the Raspberry Pi without performing and waiting for a proper shutdown nor risking corrupting the SD card."

## notes on the picore installation

if tce-load gets stuck on ca-certificates error while following the manual, remove the tcz broken packages and that should do it.

there is something wrong with cloning GIT from Https... quick hack:  
``` git config --global http.sslVerify false ```

## DAC installation
following [adafruit DAC howto (the manual part, not the script)](https://learn.adafruit.com/adafruit-i2s-audio-bonnet-for-raspberry-pi/raspberry-pi-usage)  
just edit the /boot/config.txt commenting and add  
```dtoverlay=hifiberry-dac
dtoverlay=i2s-mmap
```

in theory you have to create asound.conf, but it doesn't seem necessary.  

## python installation

install python 3.6
```tce-load -wi python3.6.tcz```
install pip  
```mkdir cd /home/tc/pip3
cd /home/tc/pip3
wget https://bootstrap.pypa.io/get-pip.py
sudo -H python3.6 get-pip.py
```
temporarily load development libraries
```tce-load -wil compiletc python3.6-dev```

install pip packages
```sudo pip3.6 install adafruit-circuitpython-mcp3xxx
sudo pip3.6 install python-osc
```

add the python libraries to the permanent storage at the end of /opt/.filetool.lst
```usr/local/lib/python3.6/site-packages/```

save the local storage
```filetool.sh -b```

## sombat codebase
probably better to create a tcz with only the needed parts, but for now this works:  
```git clone https://github.com/aiberlin/SomBat_2020/
rm -rf SomBat_2020/HW SomBat_2020/varia SomBat_2020/LinuxRaspi
```

add these lines to autostart.sh  
```
python3.6 /home/tc/SomBat_2020/Python/mcp3008_8.py
sclang /home/tc/SomBat_2020/sc/scwork/_startup.scd
```
save to permanent storage and reboot!  
```filetool.sh -b
sudo reboot
```

you should see the infamous loading sound :)



* * *
old notes/todo

fstab entry to autoboot USB Stick:
ToDo: copy from HH's running patchbox image.
