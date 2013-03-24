#!/bin/bash


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

### TODO generate here lists for "special layout": src_speciallayout and dst_speciallayout
do_function()
{
    echo ">>> Creating special layout for ro/rw layout."
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

    #[ -z ${ROOTFS_ROOT} ] && die "$ROOTFS_ROOT not defined!"
    ## workaround: where is /exp0 generated?
    #[ -d ${ROOTFS_ROOT}/${rwflash_name} ] && rm_safely ${ROOTFS_ROOT}/${rwflash_name}

    ## to exp
    for idx in ${!srcname_toexp[@]}; do
        move_from_root_to_exp ${srcname_toexp[$idx]} ${dstname_toexp[$idx]} ${rwflash_name}
        if [[ "${srcname_toexp[$idx]}" =~ (/var|/usr|/opt) ]]; then
            ## if contains, /var, /usr/ or /opt
            TARGET_EXCLUDE_LIST="${TARGET_EXCLUDE_LIST} /mnt/${rwflash_name}${srcname_toexp[$idx]}"
        fi
    done

    ## to root
    for idx in ${!srcname_toroot[@]}; do
        move_from_exp_to_root ${srcname_toroot[$idx]} ${dstname_toroot[$idx]} ${rwflash_name}
    done
}

## array operations, handle elements via for loop
do_function
echo "target exclude list: $TARGET_EXCLUDE_LIST"

echo "READY."
echo ""
