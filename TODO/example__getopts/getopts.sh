#!/bin/bash
##
## 2016 Lothar Rubusch

usage()
{
cat <<EOF
usage: $0 <h|v|f|?>

*: fallback (also anything else)
-v <args>: verbose
-f: force
-h: help

e.g.
> $0 -f -v 3
EOF
}

die()
{
    echo "FAILED! $@"
    exit 1
}

do_verbose()
{
    VAR=$1
    echo "do_verbose( '$VAR' )"
}

do_force()
{
    echo "do_force()"
}

if (( $# == 0 )); then usage; die; fi

## ':' read out further arguments, e.g. "-v foo"
while getopts hv:f cmd; do
    case ${cmd} in
    h)
        usage
        ;;
    v)
        echo "verbose"
	do_verbose $OPTARG
        ;;

    f)
	echo "force"
        do_force
        ;;

    \?)
        echo "FAIL: invalid option"
        ;;
    esac
done

echo "READY."
