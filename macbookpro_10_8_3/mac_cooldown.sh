#!/bin/bash
echo "cooling down for 5 min"
sudo ln -sf /etc/macfanctl.conf_6000 /etc/macfanctl.conf
sudo /etc/init.d/macfanctld restart

sleep 300

sudo ln -sf /etc/macfanctl.conf_NORMAL /etc/macfanctl.conf
sudo /etc/init.d/macfanctld restart
echo "READY."
