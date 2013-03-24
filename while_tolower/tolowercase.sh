#!/bin/bash
##
## demonstrates a the usage of "continue" 
##
## converts filenames to lower case, if nothing needs to be done
## it resumes the iteration by doing a "continue"
##

LIST="$(ls)"

for name in "$LIST"; do
    if [[ "$name" != *[[:upper:]]* ]]; then
	continue
    fi
    
    ORIG="$name"
    NEW=`echo $name | tr 'A-Z' 'a-z'`
    
    echo "old names: $ORIG"
    echo "new names: $NEW"
done

echo "READY."
