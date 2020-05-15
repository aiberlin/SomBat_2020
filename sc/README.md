# SomBat_2020 SC
 
 everything SuperCollider related

####ToDo:
- merge nu osx code into linux code, incl. local Quarks and all
- unify code for linux headless and laptop, with better instructions for laptop use. 
- add cheat key combos for ending all current sounds: both switches together. 
- don't use pot for amp - use amp's pot instead! So, pot is free as mod wheel ... :)
- granular player for long samples ! overlap, don't stop, for polyphonic textures. stop 'em with the cheat. Joy maps to stretch and pitch. 
- add a Master FX ? Safty net etc. 
- adjust levels of loud ones to the softer ones. 

## SC Folder Structure:

### scwork
this goes into Raspi's home dir; 

### scwork/autoload
- sclang is told to start with file ~/scwork/_startup.scd and the rest will autostart automagically. (Routine that loads all *.scd files in the "autoload" subdir)

### scwork/SomBat-touchosc

- "SomBat2.touchosc" is a TouchOsc layout to simulate the SomBat's HW interface. 
Done: make HW interface incl. python xlator. Copy OSC addresses from here. 
- the other file, "touchosc-SomBat.desc.scd" is a SC description for the incoming SC commands in the Modality format. 

### scwork/localQuarks
these are [Quarks](https://doc.sccode.org/Guides/UsingQuarks.html) dependencies to be stored locally: 

- adclib
- Influx
- JITLibExtensions
- Modality-toolkit
- Morse 
- SafetyNet
- Utopia (for networked live coding)
- Vowel


ToDo: find right place for them in Raspi's dir structure so sclang finds 'em. >> local Quarks > point to them with .yaml file and 

-  include Quarks location in yaml:
- add yaml path as -l option to sclang call in autostart:
```    
    ./sclang -a -l ~/path/to/sclang_sombat.yaml mycode.scd
```


### scwork/unused
scraps and recyclables

### defaultSounds

we look for sounds stored on external memory stick (fstab entry!), 
but if absent, we can load these. 

