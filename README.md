# SomBat_2020
 
 New firmware/software for [*SomBat* musical weapon](http://www.earweego.net/#SomBat). Based on Raspi & SuperCollider. 

## HW

 - Raspi 3 or newer (RPI Zero with WiFi network at a later point)
 - I2S DAC: Adafruit Audio Bonnet or compatible (check smaller Adafruit I2S Stereo Decoder - UDA1334A)
 - ADC IC for digitizing key input, switches, a joystick & a pot. 

## SW
 - Linux w' realtime kernel (e.g. based on Blokas.io's patchbox) 
 - autobooting jackd & headless sclang (SuperCollider language)
 - auto-mounting any USB memory (fstab) and searching for two dirs with samples called "short" and "long". 
 - python script that reads the I2C ADC IC and converts it to OSC, sending data to localhost. 
- sclang autoloads 

