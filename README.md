# SomBat_2020
 
 New firmware/software for the [*SomBat* musical weapon](http://www.earweego.net/#SomBat). Based on Raspi & SuperCollider. 

## HW

 - Raspi 3 or newer (RPI Zero with WiFi network at a later point)
 - I2S DAC: Adafruit Audio Bonnet or compatible 
 - I2C ADC IC mcp3008 for digitizing key input, switches, a joystick & a pot. 
 - custom hand-soldered key interface with 
 	- 5 pushbuttons, 
 	- 1 switch, 
 	- 1 2-axis joystick
	- 1 Pot - Mod-Wheel
which makes at least 1 more input than the 8 chan IC can digest -> R bridges for pairs of binary keys to be read by single ADC channel.

## SW
- Raspi image based on PiCore: lightweight, short boot time, RAM resident OS, may be switched off at any time
- autobooting jackd & headless sclang (SuperCollider language)
- auto-mounting any USB memory (fstab) and searching for two dirs with samples called "short" and "long". 
- sclang autoloads everything else, including 
- python script that reads the mcp3008 I2C ADC IC and converts it to OSC, sending data to localhost. 
