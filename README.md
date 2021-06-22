# SomBat_2020
 
 New firmware/software for the [*SomBat* musical weapon](http://www.earweego.net/#SomBat). Based on Raspi & SuperCollider. 

## HW

 - Raspi 3 or newer (RPI Zero with WiFi network at a later point)
 - I2S DAC: Adafruit Audio Bonnet or compatible (check smaller Adafruit I2S Stereo Decoder - UDA1334A)
 - I2C ADC IC mcp3008 for digitizing key input, switches, a joystick & a pot. 
 - custom hand-soldered key interface with 
 	- 5 pushbuttons, 
 	- 1 switch, 
 	- 1 2-axis joystick
	- 1 Pot (Volume?)
	- anything more? 
which makes at least 1 more input than the 8 chan IC can digest -> R bridges for pairs of binary keys to be read by single ADC channel.

## SW
- Linux w' realtime kernel (e.g. based on Blokas.io's patchbox) 
- autobooting jackd & headless sclang (SuperCollider language)
- auto-mounting any USB memory (fstab) and searching for two dirs with samples called "short" and "long". 
- sclang autoloads everything else, including 
- python script that reads the mcp3008 I2C ADC IC and converts it to OSC, sending data to localhost. 

## ToDo's
mainly

- get SC's autostart working
- make python mcp3008 script. Minimal mcp3008 tutorial file is collected; OSC out can be [PyOSC](https://pypi.org/project/pyOSC/) or [an other](https://stackoverflow.com/questions/22135511/a-plethora-of-python-osc-modules-which-one-to-use#22152877). 
- READ-ONLY raspian image that can be switched off power at any time. 

