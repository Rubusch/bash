#!/bin/bash

NUM=600

echo "cooling down for $(( $NUM / 60 )) min"

sudo ln -sf /etc/macfanctl.conf_6000 /etc/macfanctl.conf
sudo /etc/init.d/macfanctld restart

sleep $NUM

sudo ln -sf /etc/macfanctl.conf_NORMAL /etc/macfanctl.conf
sudo /etc/init.d/macfanctld restart
echo "READY."
