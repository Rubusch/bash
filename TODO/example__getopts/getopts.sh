#!/bin/bash
##
## 2016 Lothar Rubusch

usage()
{
cat <<EOF
Bla Blub
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

if [[ $# -eq 0 ]]; then usage; die; fi

## ':' read out further arguments, e.g. "-v foo"
while getopts hv:f cmd; do
    case ${cmd} in
    h)
        usage
        ;;
    v)
        do_verbose $1
        ;;

    f) do_force
        ;;

    \?)
        echo "FAIL: invalid option"
        ;;
    esac
done

echo "READY."
