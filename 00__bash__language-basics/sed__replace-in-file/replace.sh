#!/bin/bash -e
##
## sed file operations

echo "BEFORE"
cat ./test.txt
cp ./test.txt /tmp/test.txt.bk
echo


## first in every line
#sed -i 's/ill/ock/' ./test.txt

## all in file
sed -i 's/ill/ock/g' ./test.txt

## alternative for more flexibility in REGEX use perl (if available)
#perl -p -i -e 's/old_word/new_word/g' ./input.file


echo "AFTER"
cat ./test.txt
cp /tmp/test.txt.bk ./test.txt
echo

echo "READY."

