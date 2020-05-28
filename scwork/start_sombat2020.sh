#!/bin/bash
echo ""
echo "*** HELLO SOMBAT startup script ****"
echo ""

echo "***Kill Python and Xvfb"
killall python3
killall Xvfb

sleep 1
echo "** Pys booting ****"
python3 /home/patch/Python/rgb_led_6.py &
python3 /home/patch/Python/mcp3008_9.py &

sleep 1

echo "** SC booting ****"
# echo | DISPLAY=:0 sclang /home/patch/NTMI/NTMI*/00_loadMe.scd  &> /home/patch/ntmi.log
# ./sclang -a -l ~/scwork/sclang_sombat.yaml ~/scwork/_startup.scd &> ~/sombat.log
# echo | DISPLAY=:0 sclang &> ~/sombat.log
# echo | DISPLAY=:0 sclang -a -l ~/scwork/sclang_sombat.yaml ~/scwork/_startup.scd &> ~/sombat.log

#echo "*** Kill jackd"
#sudo killall jackd

#sleep 1
#echo "*** awake jackd"
#sudo jackd -P75 -p32 -t2000 -dalsa -dhw:0 -p64 -n2 -s -r48000 -P &&
#exec /usr/bin/jackd -t 2000 -R -P 95 -d alsa -d hw:sndrpihifiberry -r 48000 -p 64 -n 2 -X seq -s -S 

sleep 1
echo "*** awake SC"
# open SC, with this .yaml config file to load neccessary extensions, load this startup file, go to backgnd and log stdout in that .log file.

# dis good inside the gfx envir
#echo | sclang -a -l ~/scwork/sclang_sombat.yaml ~/scwork/_startup.scd &> ~/scwork/sombat.log

# dis good in terminal AND on screen
echo | xvfb-run sclang -a -l /home/patch/scwork/sclang_sombat.yaml /home/patch/scwork/_startup.scd &> /home/patch/scwork/sombat.log

