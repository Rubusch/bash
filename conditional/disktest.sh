#!/bin/bash
## disktest.sh
##
## prints the space of the disk
##

space=`df -h | awk '{print $5}' | grep % | grep -v Use | sort -n | tail -1 | cut -d "%" -f1 -`
alertvalue="80"

echo "check disk space"

if [ "$space" -ge "$alertvalue" ]; then
    echo "at least one of my disks is nearly fill!" | mail -s "daily diskcheck" root
else 
    echo "disk space normal."
fi

echo "READY."