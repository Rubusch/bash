#!/bin/bash
## FIXME

## check for number
checknumber()
{
    for item in $@; do
        if [[ "${item}" =~ [\d\d] ]]; then
            echo "XXX failed"
        else
            echo "XXX pass"
        fi
    done
}

## check for regex (older bash)
do_regex()
{
    local target=$1
    ## for bash below version 3.2 put the regex in quotes, and use [[ ]] like here
    if [[ "${target}" =~ "^(/bin|/boot|/dev|/etc|/home|/lib|/mnt|/opt|/proc|/root|/sbin|/sys|/tmp|/usr|/var)/?$" ]]; then
        echo "TRUE: '$target'"
    else
        echo "FALSE: '$target'"
    fi
}

## condition, usage of regex
echo "should be TRUE:"
do_regex /bin
do_regex /boot
do_regex /dev
do_regex /etc
do_regex "/home"
do_regex "/lib"
do_regex "/mnt"
do_regex "/opt"
do_regex "/proc"
do_regex "/root"
do_regex "/sbin"
do_regex "/sys"
do_regex "/tmp"
do_regex "/usr"
do_regex "/var"
do_regex "/usr/"
echo "should be FALSE:"
do_regex "usr"
do_regex "usr/"
do_regex "/usrf"
do_regex /home/usr
do_regex "/var/bin/foo"
do_regex "/usr/bin"

checknumber 45 34 2 asdf

echo "READY."
echo ""

