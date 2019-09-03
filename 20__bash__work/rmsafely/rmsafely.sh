#!/bin/bash -e
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3

die()
{
    echo
    echo "ERROR: $@"
    echo "aborting"
    exit 1
}

rm_safely()
{
    local target=$1

## e.g. rm $VAR and VAR was empty
    if [[ -z "${target}" ]]; then
        echo "Nothing to remove here: '${target}'!"
        return
    fi

## e.g. $VAR/... and VAR was empty, results to /...
    if [[ "${target}" == "/" ]]; then
        die "ERROR: Remove target was root: '${target}'!"
    fi

## e.g. $VAR1/$VAR2/... and both are empty, results to //...
	if [[ "${target}" =~ (/)+ ]]; then
        die "ERROR: Remove target was root: '${target}'!"
    fi

## e.g. match fundamental system folders
    if [[ "${target}" =~ "^(/bin|/boot|/dev|/etc|/home|/lib|/mnt|/opt|/proc|/root|/sbin|/sys|/tmp|/usr|/var)/?$" ]]; then
        die "ERROR: Something is odd here, are you trying to remove the root file system: '${target}'?!"
    fi

## removal
    if [[ -d "$target" ]]; then
        rm -rfv "${target}"
    else
        rm -v "${target}"
    fi
}


### START

echo "execute 'rm -rf \$FOO/\$BAR/*'"
echo

set -x
rm_safely $FOO/$BAR/*
{ set +x ; } 2> /dev/null

echo "READY."
