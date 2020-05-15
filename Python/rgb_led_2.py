from gpiozero import RGBLED

led = RGBLED(22, 23, 24)
led.color = (1, 1, 0)
led.blink(1, 1, 1, 1, (1, 1, 1), (0.2, 0.1, 0.4), None, background=True)
print("dn")