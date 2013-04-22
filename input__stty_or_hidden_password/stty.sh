#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## demonstrates how to turn off console output when writing with stty

read -p "Username: " username

## ask for hidden password
stty -echo
read -p "Password: " password
stty echo
echo ## this 'echo' is important


printf "READY.\n"
