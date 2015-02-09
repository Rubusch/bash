#!/bin/bash

usage ()
{
cat << EOF
RAVEN version '${RAVEN_VERSION}'
usage $0 <arg1> <arg2>

        arg1
                some argument

        arg2
                another argument
EOF
}


echo "show usage if wrong command line arguments are used..."
echo
usage

echo "READY."