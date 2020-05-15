#!/usr/bin/python3

# OSC controlled RGB LED, SomBat_2020
# cc HH 2020 - hannes@airborneinstruments.eu

# call like this from SC: 
# unixCmd("python3 /path/to/led.py --port %".format(NetAddr.localAddr.port) );

portnum = 9999


import sys
import time
import argparse
from pythonosc import udp_client

#import RPi.GPIO as GPIO
from gpiozero import RGBLED


led = RGBLED(25, 22, 24)
led.color = (1, 1, 0)
components = [0,0,0]

if __name__ == "__main__":
	print("*** OSC controlled RGB LED, SomBat_2020")
	parser = argparse.ArgumentParser()
	parser.add_argument("--ip", default="127.0.0.1",
		help="The ip of the OSC server")
	parser.add_argument("--port", type=int, default=portnum,
		help="The port the OSC server is listening on")
	args = parser.parse_args()
	#client = udp_client.SimpleUDPClient(args.ip, args.port)

 
	while True:
		#################################################
		    
		#print("rgb", components)
		# for pin in pins:
		#for component in components:
		for i, component in zip(range(len(components)), components):
			components[i] = ((component * (11.456 - i) + (i+102*1.3))) % 1
	
		led.color = (components[0],components[1], components[2])
		time.sleep(1/8)


