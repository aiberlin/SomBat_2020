#!/usr/in/python3

# Analog input to OSC, SomBat_2020, cc HH 2020
# hannes@airborneinstruments.eu
# ver 0.7 is final

import time
import busio
import digitalio
import board
import argparse
from pythonosc import udp_client
import adafruit_mcp3xxx.mcp3008 as MCP
from adafruit_mcp3xxx.analog_in import AnalogIn

# create the spi bus
spi = busio.SPI(clock=board.SCK, MISO=board.MISO, MOSI=board.MOSI)

# create the cs (chip select)
cs = digitalio.DigitalInOut(board.D5)

# create the mcp object
mcp = MCP.MCP3008(spi, cs)

# create an analog input channel on pin 0..7
chanArray = [AnalogIn(mcp, MCP.P0),AnalogIn(mcp, MCP.P1),AnalogIn(mcp, MCP.P2),AnalogIn(mcp, MCP.P3),AnalogIn(mcp, MCP.P4),AnalogIn(mcp, MCP.P5),AnalogIn(mcp, MCP.P6),AnalogIn(mcp, MCP.P7)]

# init vars
joyXmin = 20000
joyXmax = 40000
joyYmin = 20000
joyYmax = 40000
oldjoyXY = 1.0
oldPotVal = 30000
potMin = 10000
potMax = 50000

### button vars
# button addresses: 
buttonAddrs = [ ['1/switch1', '1/trig1'], ['1/switch2', '1/trig3'], ['1/toggleM', '1/trig2'] ]
buttonStates    = [0, 0, 0]
buttonStatesOld = [0, 0, 0]
#         66 45 32 26 
#>> state  0  1  2  3 

# current > prev
stateChangeDict = {
0: { 
	1: ["upper off", [0], [0]],
	2: ["lower off", [1], [0]],
	3: ["both off", [0,1], [0,0]]
},
1: {
	0: ["upper on", [0], [1]],
	2: ["lower off, upper on", [0,1], [0,1]],
	3: ["lower off", [1], [0]]
}, 
# hin: 2>3 und 3>2
2: {
	0: ["lower on", [1], [1]],
	1: ["lower on, upper off", [0,1], [1,0]],
	3: ["upper off", [0], [0]]
}, 
3: { 
	0: ["both on", [0,1], [1,1]],
	1: ["lower on", [1], [1]],
	2: ["upper on", [0], [1]],
}
}


if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("--ip", default="127.0.0.1",
		help="The ip of the OSC server")
	parser.add_argument("--port", type=int, default=57120,
		help="The port the OSC server is listening on")
	args = parser.parse_args()

	client = udp_client.SimpleUDPClient(args.ip, args.port)
	while True:
		#################################################
		# the 3 Button pairs:
		for i in range(3):
			readVal = chanArray[i].value;
			if (readVal > 55000):
				buttonStates[i] = 0
			elif (readVal > 38000):
				buttonStates[i] = 1
			elif (readVal > 29000):
				buttonStates[i] = 2
			else:
				buttonStates[i] = 3
			# xition - without debouncing for now
			if(buttonStates[i] != buttonStatesOld[i]):
				statechange = stateChangeDict.get( buttonStates[i] ).get(buttonStatesOld[i] ) 
				# print("chan: {} state from: {}, to: {}, xition {}".format(i, buttonStatesOld[i], buttonStates[i], statechange))
				buttonStatesOld[i] = buttonStates[i]

				ii = 0
				for obenOderUnten in statechange[1]:
				#	print(buttonAddrs[i], "** ii:", ii, " *** statechange:", statechange[1]) 
				#	print(buttonAddrs[i], " *** statechange:", statechange[1], " *** obenOderUnten:", obenOderUnten) 
					oscaddress = buttonAddrs[i][ obenOderUnten ]
					client.send_message(oscaddress, statechange[2][ii])
					ii = ii+1

		#################################################
		# joystixx
		# one axis (x)
		readVal = chanArray[6].value;
		if readVal < joyYmin:
			joyYmin = readVal
		if readVal > joyYmax:
			joyYmax = readVal
		joyYfloat = (readVal - joyYmin) / (joyYmax-joyYmin)

		# other axis (x)
		readVal = chanArray[7].value; 
		if readVal < joyXmin:
			joyXmin = readVal
		if readVal > joyXmax:
			joyXmax = readVal
		floatOut = (readVal - joyXmin) / (joyXmax-joyXmin)
		if (floatOut + joyYfloat) != oldjoyXY:
			client.send_message("/1/xy1", [floatOut, joyYfloat])
			oldjoyXY = (floatOut + joyYfloat)	
			# very neat! super jitter free adc!! 

		#################################################
		# next is poti:
		readVal = chanArray[5].value; 
		if readVal != oldPotVal:
			oldPotVal = readVal
			if readVal < potMin:
				potMin = readVal
			if readVal > potMax:
				 potMax = readVal
			floatOut = (readVal - potMin) / (potMax-potMin)
			client.send_message("/1/fader1", floatOut)




		time.sleep(1/50)
