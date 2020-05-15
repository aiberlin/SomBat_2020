#!/usr/bin/python3

# OSC controlled RGB LED, SomBat_2020
# cc HH 2020 - hannes@airborneinstruments.eu

# ver 5: incl. OSC client
# call like this from SC: 
# unixCmd("python3 /path/to/led.py --port %".format(NetAddr.localAddr.port) );

portnum = 9999


import sys
import time
import argparse
#from pythonosc import udp_client
from pythonosc import dispatcher
from pythonosc import osc_server
#import RPi.GPIO as GPIO # more complcated - complains that ports are used by sth. else...
from gpiozero import RGBLED # much more easy to use, maybe heavier to install..

led = RGBLED(25, 22, 24)
led.color = (1, 1, 0)
components = [0,0,0]
cnt=0

def print_rgb_handler(unused_addr, args, r, g, b):
#	print("rgb = {0}, {1}, {2}! ".format(r,g,b))
	try:
		components = [r/255.0, g/255.0, b/255.0]
		led.color = (components[0],components[1], components[2])
	except ValueError: pass


if __name__ == "__main__":
	print("*** OSC controlled RGB LED, SomBat_2020")
	parser = argparse.ArgumentParser()
	parser.add_argument("--ip", default="127.0.0.1",
		help="The ip of the OSC server")
	parser.add_argument("--port", type=int, default=portnum,
		help="The port the OSC server is listening on")
	args = parser.parse_args()

	#### start with a little blinkin orgy for 10 seconds
	while (cnt < 100):
		#################################################
		    
		#print("rgb", components)
		# for pin in pins:
		#for component in components:
		for i, component in zip(range(len(components)), components):
			components[i] = ((component * (11.456 - i) + (i+102*1.3))) % 1
	
		led.color = (components[0],components[1], components[2])
		time.sleep(1/10)
		cnt = cnt + 1

	dispatcher = dispatcher.Dispatcher()
	dispatcher.map("/rgb_led", print_rgb_handler, "r", "g", "b")
#	dispatcher.map("/filter", print)
#	dispatcher.map("/logvolume", print_compute_handler, "Log volume", math.log)

	server = osc_server.ThreadingOSCUDPServer(
		(args.ip, args.port), dispatcher)
	print("Serving on {}".format(server.server_address))
	server.serve_forever()
