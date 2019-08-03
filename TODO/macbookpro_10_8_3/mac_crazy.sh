#!/bin/bash

sleep 20

pushd . > /dev/null
cd /etc
sudo ln -sf /etc/macfanctl.conf_6000 ./macfanctl.conf
sudo /etc/init.d/macfanctld restart > /dev/null
popd > /dev/null

sleep 5
interval=0.02
counter=1000
for item in $(seq 1 300); do

    if (( 100 < $counter )); then
            counter=$(( $counter - 15 ))
            interval="0.$counter"
    else
        interval=0.08
    fi

    sleep $interval

    if (( 50 == $item )); then
         xscreensaver-command -activate &
    fi

    if (( 255 == $( cat /sys/class/leds/smc\:\:kbd_backlight/brightness ) )); then
	echo "0" | sudo tee /sys/class/leds/smc\:\:kbd_backlight/brightness > /dev/null

    else
	echo "255" | sudo tee /sys/class/leds/smc\:\:kbd_backlight/brightness > /dev/null
#       val=$(( $RANDOM % 255 ))
#	echo "${val}" | sudo tee /sys/class/leds/smc\:\:kbd_backlight/brightness > /dev/null
        sleep "0.0$(( $RANDOM % 10 ))"
    fi
done

pushd . > /dev/null
cd /etc
sudo ln -sf /etc/macfanctl.conf_NORMAL ./macfanctl.conf
sudo /etc/init.d/macfanctld restart > /dev/null
popd > /dev/null
echo "0" | sudo tee /sys/class/leds/smc\:\:kbd_backlight/brightness > /dev/null

echo "READY."
