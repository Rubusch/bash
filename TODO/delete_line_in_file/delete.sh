#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3


echo "BEFORE"
cat ./test.txt
cp ./test.txt ./test.txt.bk
echo

## delete line in textfile
(echo "g/jack and/d"; echo 'wq') | ex -s ./test.txt

## or
#sed -ie '/jack and/d' ./test.txt

echo "AFTER"
cat ./test.txt
cp ./test.txt.bk ./test.txt
echo


echo "READY."
echo