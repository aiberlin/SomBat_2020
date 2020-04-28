# SomBat_2020 SC
 
 everything SuperCollider related



## Folder Structure:

### scwork
this goes into Raspi's home dir; 

- sclang is told to start with file ~/scwork/_startup.scd and the rest will autostart automagically. (Routine that loads all *.scd files in the "autoload" subdir)

### scwork/SomBat-touchosc

- "SomBat2.touchosc" is a TouchOsc layout to simulate the SomBat's HW interface. 
ToDo: make HW interface incl. python xlator. Copy OSC addresses from here. 
- the other file, "touchosc-SomBat.desc.scd" is a SC description for the incoming SC commands in the Modality format. 

### localQuarks
these are [Quarks](https://doc.sccode.org/Guides/UsingQuarks.html) dependencies to bestored locally: 

- adclib
- Influx
- JITLibExtensions
- Modality-toolkit
- Morse 
- SafetyNet
- Vowel

[ “JITLibExtensions”, “adclib”, “Influx”, “Modality-toolkit”, “Morse”, “Vowel”, "SafetyNet" ].do(Quarks.install(_));



ToDo: find right place for them in Raspi's dir structure so sclang finds 'em.

### usbStickSounds
these should be optionally residing on a connectd USB stick; auto loaded if present. 


### unused
well...:)