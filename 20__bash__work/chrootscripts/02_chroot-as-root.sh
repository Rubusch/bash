#!/bin/bash
##
## just chroots into the system, in case an additional tty is going to 
## enter a already mounted and configured system
##

die ()
{
    echo $@
    exit 1
}

CHROOTSYS="$@"
[[ -z "$CHROOTSYS" ]] && die "usage: $0 <folder>"
[[ -e "$CHROOTSYS" ]] || die "wrong path '${CHROOTSYS}'"


## copies
#sudo cp /home/users/rubuschl/.gvfs/build_output\ on\ rkams889/Roche.DP.NewGen/IS/pkg_00000163_ISNewGen/pkg_00000163_ISNewGen_*_ubu_10.04_no_os.tar.gz "$CHROOTSYS/home/rubuschl/.gvfs/build_output on rkams889/Roche.DP.NewGen/IS/pkg_00000163_ISNewGen/"

## path should end with '/'
LAST=${CHROOTSYS#${CHROOTSYS%?}}
[[ "$LAST" != '/' ]] && CHROOTSYS="${CHROOTSYS}/"

## chroot
#setarch linux32 sudo /usr/sbin/chroot ${CHROOTSYS} su user
setarch linux32 sudo /usr/sbin/chroot ${CHROOTSYS} /bin/bash
