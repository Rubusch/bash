#!/bin/bash
VAL=0
func()
{
	x=1
	while [ $x -le 5 ]; do
		echo "XXX go to sleep"
		sleep 1

		x=$(( $x + 1 ))
	done
	VAL=1
}

while true; do

	## enable job management, then background function
	set -m
	func &

	sleep 2

	## foreground function again
	fg %1

	VAL=1
	if [ $VAL -eq 1 ]; then
		break
	fi
done
echo "READY."
