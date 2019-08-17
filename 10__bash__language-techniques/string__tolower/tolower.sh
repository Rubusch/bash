#!/bin/bash
##
## convert string to lower case
##

TEXT="aBcD EfGh"
text=""
echo "TEXT '${TEXT}', text '${text}'"; echo

## tr
text=""
text="$(echo ${TEXT} | tr '[A-Z]' '[a-z]')"
echo "TEXT '${TEXT}', text '${text}'"; echo

## awk
text=""
text="$(echo ${TEXT} | awk '{print tolower($0)}')"
echo "TEXT '${TEXT}', text '${text}'"; echo

## bash >4.0
text=""
text="${TEXT,,}"
echo "TEXT '${TEXT}', text '${text}'"; echo

## perl
text=""
text="$(echo ${TEXT} | perl -e 'print lc <>;')"
echo "TEXT '${TEXT}', text '${text}'"; echo


echo "READY."
