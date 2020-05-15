from gpiozero import RGBLED

import time
import random

             #gbr
led = RGBLED(25, 22, 24)
led.color = (1, 1, 0)

components = [0,0,0]
c = 0;
dt = 1

while True:
	#led.blink(1, 1, 1, 1, (random.random(), random.random(), random.random()/2), (0.0, 0.0, 0.0), None, background=True)
	#led.color = (random.random(), random.random(), random.random()/2)
	led.color = (components[0],components[1], components[2])

	for i, component in zip(range(len(components)), components):
		components[i] = int(components[i] * 100 * (11.456 - i) + (i+1*1))%100 / 100



	time.sleep(1/2)
	led.color = (1,0,0)
	time.sleep(dt)

	led.color = (0,1,0)
	time.sleep(dt)

	led.color = (0,0,1)
	time.sleep(dt)

	print("l00p")