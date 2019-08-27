#!/bin/bash
##
## compare folder content
usage()
{
    echo "test: list all files; filter filenames w/o paths; sort alphabetical and compare"
    echo "$0 <folder A> <folder B>"
    echo
    exit 1
}

(( $# != 2 )) && usage

FOLDER_A=$1
TMP_A="/tmp/con.a"
FOLDER_B=$2
TMP_B="/tmp/con.b"

find ${FOLDER_A} -exec basename {} \; | sort > ${TMP_A}
find ${FOLDER_B} -exec basename {} \; | sort > ${TMP_B}
diff ${TMP_A} ${TMP_B}

## in case of '/bin/bash -e', the cleanup might be ignored
rm ${TMP_A} ${TMP_B}
echo "READY."
