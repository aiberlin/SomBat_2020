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

# create an analog input channel on pin 0
chanArray = [AnalogIn(mcp, MCP.P0),AnalogIn(mcp, MCP.P1),AnalogIn(mcp, MCP.P2),AnalogIn(mcp, MCP.P3),AnalogIn(mcp, MCP.P4),AnalogIn(mcp, MCP.P5),AnalogIn(mcp, MCP.P6),AnalogIn(mcp, MCP.P7)]

joyXmin = 20000
joyXmax = 40000
joyYmin = 20000
joyYmax = 40000


if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("--ip", default="127.0.0.1",
		help="The ip of the OSC server")
	parser.add_argument("--port", type=int, default=57120,
		help="The port the OSC server is listening on")
	args = parser.parse_args()

	client = udp_client.SimpleUDPClient(args.ip, args.port)
	while True:
	#first the joystixx
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
		client.send_message("/joystick", [floatOut, joyYfloat])	
		# neat! next is poti,


		# last is the 3 Button pairs:


		txt = ""
		vals = []
		chanI = 0
		for chan in chanArray:
			#print('Raw ADC Value: ', chan.value)
			txt = txt + " " + str(chan.value)
			vals.append(chan.value)
			chanI = chanI+1
		#print(txt)
		#client.send_message("/analogVals", vals)
		time.sleep(1/50)
