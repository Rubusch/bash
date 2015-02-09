#!/bin/bash

echo "BEFORE"
cat ./test.txt
cp ./test.txt ./test.txt.bk
echo

## prepend
sed -i '1i once upon a time' ./test.txt
#sed -ie 's/ill/ock/' ./test.txt

## insert second line
sed -i '5i and the insurance didn`t pay anything!' ./test.txt

#sed -i '2i if \[\[ \$\{CURR_SC\} == \"1\" \]\]; then' ./test.txt

echo "AFTER"
cat ./test.txt
cp ./test.txt.bk ./test.txt
echo
