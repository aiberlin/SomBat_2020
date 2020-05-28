#!/bin/bash

echo "***Kill Python"
killall python3 &
sleep 1
echo "** Pys booting ****"
python3 ~/Python/rgb_led_6.py &
python3 ~/Python/mcp3008_9.py &> ~/scwork/mcp.log
