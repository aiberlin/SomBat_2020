# SomBat_2020 Linux System
 
 base it on

1.  blokas.io patchbox 
 https://github.com/BlokasLabs/patchbox-os-gen/. 
 Debugging info [here](https://community.blokas.io/t/supercollider-headless-autostart-and-or-single-click-sh/246/18) (Old version SC3.9, though, now we are at 3.10 )
 

2. or on [this](http://sns.nerdkram.net/) fork looks perfect: 
"Builds a custom Raspbian image with a realtime kernel and supercollider as a headless service."
Hosted on [gitlab](https://gitlab.com/sns-bucket/sns-pi-gen). 

3. [Prynth](https://prynth.github.io/). Long developed & tested by Ivan Franco. with node.js web interface to all functions. Certainly runs SC very well; not sure if it has not too many features we don't need. 

3. or, for a greater challenge, this one here: [pi-core Linux](https://www.fredrikolofsson.com/f0blog/?q=node/672). "piCore has many advantages over the common Raspbian system. It will boot a lot faster, is extremely light weight and is easy to customise. And because the whole system always resides in RAM, SD card wear is minimal.
Its immutable-by-default design means one can unplug the power to the Raspberry Pi without performing and waiting for a proper shutdown nor risking corrupting the SD card."


fstab entry to autoboot USB Stick:
ToDo: copy from HH's running patchbox image. 