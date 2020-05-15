#!/bin/bash
echo ""
echo "*** HELLO SOMBAT startup script ****"
echo ""

sleep 1
echo "** Pys booting ****"
python3 ~/Python/rgb_led_6.py &
python3 ~/Python/mcp3008_9.py &

sleep 1

echo "** SC booting ****"
# echo | DISPLAY=:0 sclang /home/patch/NTMI/NTMI*/00_loadMe.scd  &> /home/patch/ntmi.log
# ./sclang -a -l ~/scwork/sclang_sombat.yaml ~/scwork/_startup.scd &> ~/sombat.log
# echo | DISPLAY=:0 sclang &> ~/sombat.log
# echo | DISPLAY=:0 sclang -a -l ~/scwork/sclang_sombat.yaml ~/scwork/_startup.scd &> ~/sombat.log
echo | sclang -a -l ~/scwork/sclang_sombat.yaml ~/scwork/_startup.scd &> ~/scwork/sombat.log
