#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3

TARGET_EXCLUDE_LIST=""

move_from_root_to_exp()
{
    echo "srcname_toexp[idx] = '$1';  dstname_toexp[idx] = '$2';  rwflash_name = '$3'"
}
undo_move_from_root_to_exp()
{
    move_from_root_to_exp $2 $1 $3
}

move_from_exp_to_root()
{
    echo "srcname_toroot[idx] = '$1';  dstname_toroot[idx] = '$2';  rwflash_name = '$3'"
}
undo_move_from_exp_to_root()
{
    move_from_exp_to_root $2 $1 $3
}

undo_function()
{
###
    local rwflash_name="exp0"
    local srcname_toexp=( \
        "/dev" \
        "/etc" \
        "/var/fwinfo" \
        "/var/osservices" \
        "/var/spool" \
        "/var/swinfo" \
        "/var/tmp" \
        "/var/lib" \
        "/usr/lib" \
        "/usr/share" \
        "/usr/local" \
        "/opt/log" \
        "/opt/fs20" \
        )
    local dstname_toexp=( \
        "/dev" \
        "/etc" \
        "/var/fwinfo" \
        "/var/osservices" \
        "/var/spool" \
        "/var/swinfo" \
        "/var/tmp" \
        "/var/lib" \
        "/usr/lib" \
        "/usr/share" \
        "/usr/local" \
        "/opt/log" \
        "/opt/fs20" \
        )
    local srcname_toroot=( \
        "/opt/fs20/scripts" \
        "/opt/fs20/ini" \
        "/opt/fs20/lib" \
        )
    local dstname_toroot=( \
        "/opt/fs20.ro/scripts" \
        "/opt/fs20.ro/ini" \
        "/opt/fs20.ro/lib" \
        )

    ## undo toroot
    srcname_toroot_revert=(`echo ${srcname_toroot[@]} | tac -s ' '`)
    dstname_toroot_revert=(`echo ${dstname_toroot[@]} | tac -s ' '`)
    for idx in ${!srcname_toroot_revert[@]}; do
        undo_move_from_exp_to_root ${srcname_toroot_revert[$idx]} ${dstname_toroot_revert[$idx]} ${rwflash_name}
    done


    ## undo toexp
    srcname_toexp_revert=(`echo ${srcname_toexp[@]} | tac -s ' '`)
    dstname_toexp_revert=(`echo ${dstname_toexp[@]} | tac -s ' '`)
    for idx in ${!srcname_toexp_revert[@]}; do
        undo_move_from_root_to_exp ${srcname_toexp_revert[$idx]} ${dstname_toexp_revert[$idx]} ${rwflash_name}
    done
}

## array operations, revert array element order
undo_function

echo "READY."
echo ""

