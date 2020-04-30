# SomBat_2020 Linux System
 
 based on [pi-core Linux](https://www.fredrikolofsson.com/f0blog/?q=node/672). 
 "piCore has many advantages over the common Raspbian system. It will boot a lot faster, is extremely light weight and is easy to customise. And because the whole system always resides in RAM, SD card wear is minimal. Its immutable-by-default design means one can unplug the power to the Raspberry Pi without performing and waiting for a proper shutdown nor risking corrupting the SD card."

## notes on the picore installation

if tce-load gets stuck on ca-certificates error while following the manual, remove the tcz broken packages and that should do it.

there is something wrong with cloning GIT from Https... quick hack:  
``` git config --global http.sslVerify false ```





* * *

fstab entry to autoboot USB Stick:
ToDo: copy from HH's running patchbox image.
