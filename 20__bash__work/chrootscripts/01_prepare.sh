#!/bin/bash -e
#
# logs in as user, mounts all necessary fils - in case remounts them
#
#set -x
die ()
{
    echo $@
    exit 1
}


CHROOTSYS="$@"
[[ -z "$CHROOTSYS" ]] && die "usage: $0 <folder>"
[[ -e "$CHROOTSYS" ]] || die "wrong path '${CHROOTSYS}'"

## path should end with '/'
LAST=${CHROOTSYS#${CHROOTSYS%?}}
[[ "$LAST" != '/' ]] && CHROOTSYS="${CHROOTSYS}/"

## in case umount
sudo umount ${CHROOTSYS}dev/pts &> /dev/null
sudo umount ${CHROOTSYS}dev &> /dev/null
sudo umount ${CHROOTSYS}sys &> /dev/null
sudo umount ${CHROOTSYS}proc &> /dev/null

## fix: sudo mount -o remount,rw,suid,dev
#sudo mount -o remount,rw,suid,dev $CHROOTSYS || die "remount failed, exit any folder placed under '$CHROOTSYS'"

## mount
sudo mount -t proc /proc ${CHROOTSYS}proc || die "failed"
sudo mount -t sysfs /sys ${CHROOTSYS}sys || die "failed"
sudo mount -o bind /dev ${CHROOTSYS}dev || die "failed"
sudo mount -t devpts /dev/pts ${CHROOTSYS}dev/pts || die "failed"

#sudo mount -o bind /proc ${CHROOTSYS}proc || die "failed"
#sudo mount -o bind /sys ${CHROOTSYS}sys || die "failed"
#sudo mount -o bind /dev ${CHROOTSYS}dev || die "failed"
#sudo mount -o bind /dev/pts ${CHROOTSYS}dev/pts || die "failed"

## set up X-server
sudo xhost local:user

## chroot
./02_chroot.sh ${CHROOTSYS}
