#!/bin/bash
if (( 255 == $( cat /sys/class/leds/smc\:\:kbd_backlight/brightness ) )); then
	echo "turning backlight off"
	echo "0" | sudo tee /sys/class/leds/smc\:\:kbd_backlight/brightness > /dev/null
else
	echo "turning backlight on"
	echo "255" | sudo tee /sys/class/leds/smc\:\:kbd_backlight/brightness > /dev/null
fi

