#!/bin/sh -e

die()
{
    echo $@
    exit 1
}

usage()
{
cat <<EOF
    usage $0 <pattern> <+/-> <m|p|f|l>
    <pattern>       the pattern - no REGEX!!, e.g. 'mmc' or 'spi', not 'mmc\|spi'
    <+/->           enable / disable
    <p|m|f|l>       print information about
    p       print message
    m       module name
    f       function name
    l       linenumber
EOF
}

## MAIN
##
if [ $# -ne 3 ]; then usage; die; fi
PATTERN=$1

ENABLE=$2
if [ "${ENABLE}" != "+" ] && [ "${ENABLE}" != "-" ]; then usage; die; fi

OPTS=$3
if [ -z "$(echo ${OPTS} | grep "p\|m\|f\|l")" ]; then usage; die; fi

if [ ! -f /sys/kernel/debug/dynamic_debug/control ]; then
    mount -t debugfs nodev /sys/kernel/debug
fi
FILES=$(grep -i "${PATTERN}" /sys/kernel/debug/dynamic_debug/control | awk -F : '{ print $1 }' | uniq)

for item in ${FILES}; do
    echo "\t$item"
done
echo

echo -e "command:\n\techo \'file ${item} ${ENABLE}${OPTS}\' > /sys/kernel/debug/dynamic_debug/control"

echo -n "proceede (y|n)? "
read ans
ans=`echo "${ans}" | sed -e 's/[A-Z]/[a-z]/g'`
if [ $ans != "y" ]; then die; fi
echo

## set dyndebug flags
for item in ${FILES}; do
    set -x
    echo "file ${item} ${ENABLE}${OPTS}" > /sys/kernel/debug/dynamic_debug/control
    { set +x ; } 2> /dev/null
    echo
done

echo "READY."
