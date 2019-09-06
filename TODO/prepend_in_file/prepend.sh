#!/bin/bash -e
##
##

echo "BEFORE"
cat ./test.txt
cp ./test.txt /tmp/test.txt.bk
echo

## prepend, 1st line i-nsert
sed -i '1i once upon a time...' ./test.txt
#sed -ie 's/ill/ock/' ./test.txt

## insert second line, at 5th line i-nsert
sed -i '5i ...and the insurance didn`t pay anything!!!' ./test.txt

#sed -i '2i if \[\[ \$\{CURR_SC\} == \"1\" \]\]; then' ./test.txt

echo "AFTER"
cat ./test.txt
mv /tmp/test.txt.bk ./test.txt
echo
