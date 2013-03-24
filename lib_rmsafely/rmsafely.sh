#!/bin/bash

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

    if [[ -z "${target}" ]]; then
        echo "Nothing to remove here: '${target}'!"
        return
    fi

    if [[ "${target}" = "/" ]]; then
        die "ERROR: Remove target was root: '${target}'!"
    fi

    if [[ "${target}" =~ "^(/bin|/boot|/dev|/etc|/home|/lib|/mnt|/opt|/proc|/root|/sbin|/sys|/tmp|/usr|/var)/?$" ]]; then
        die "ERROR: Something is odd here, are you trying to remove the root file system: '${target}'?!"
    fi

    if [[ -d "$target" ]]; then
        rm -rfv "${target}"
    else
        rm -v "${target}"
    fi
}

