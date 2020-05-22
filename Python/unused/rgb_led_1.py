#!/usr/bin/python3

# OSC controlled RGB LED, SomBat_2020
# cc HH 2020 - hannes@airborneinstruments.eu

# call like this from SC: 
# unixCmd("python3 /path/to/led.py --port %".format(NetAddr.localAddr.port) );

portnum = 9999
pwmfreq = 100;

import sys
import time

import argparse
from pythonosc import udp_client
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BOARD)
GPIO.setup(22, GPIO.OUT)
GPIO.setup(24, GPIO.OUT)
GPIO.setup(25, GPIO.OUT)

pins = [GPIO.PWM(22, pwmfreq), GPIO.PWM(24, pwmfreq), GPIO.PWM(25, pwmfreq)]
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
		    
		print("pwm", components)
		# for pin in pins:
		for i, pin in zip(range(len(pins)), pins):
			components[i] = int(components[i] * (11.456 - i) + (i+1*1))%100
			pin.ChangeDutyCycle(components[i])
		time.sleep(1/5)
