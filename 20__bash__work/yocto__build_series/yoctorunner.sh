#!/bin/bash
## test script to regression test building the ELDK targets

TEST_PREFIX="TESTBUILD_"


## XXX customized settings
PTH="/work/lothar/"
PTH_RECIPES="${PTH}eldk/"
PTH_LOG="${PTH}${TEST_PREFIX}LOGS/"
PTH_SSTATE="${PTH}${TEST_PREFIX}SSTATE"

PTH_OPTBUILD="/opt/eldk/build/"



## test all available machines
#TEST_MACHINES=( $(ls ${PTH_RECIPES}*/conf/machine/ | grep \.conf | sed 's/\.conf//') )

## test all available ELDK machines
#TEST_MACHINES=( $(ls ${PTH_RECIPES}meta-eldk/conf/machine/ | grep \.conf | sed 's/\.conf//') )

## test selection
TEST_MACHINES=( \
#    "m28evk" \
#    "m53evk" \
#    "generic-armv5te" \
    "generic-armv7a" \
)  


## test all possible images
#TEST_IMAGES=( $(find ${PTH_RECIPES} -name images -exec ls {} \; | sed 's/\.bb//g') )

## test just a selection
TEST_IMAGES=( \
    "core-image-minimal" \
#    "core-image-qte-sdk" \
)  


function die(){
    echo $@
    exit 1
}

function remove_dir(){
    local _dir=$1
    [[ ! -n "$(echo ${_dir} | grep '/work/lothar')" ]] && die "ERROR: can't remove '${_dir}'"
    echo "ATTENTION, removing '${_dir}'! "
    rm -rf ${_dir}
}

function fancy_echo(){
    if [[ -n "${1}" ]]; then
        local message="$@ "
    fi
    local max=80
    local cnt=$(expr ${max} - length "${message}")
    echo -n "${message}"
    for i in $(seq ${cnt}); do echo -n '-'; done
    echo
}

function usage(){
    cat <<EOF
He who is valiant and pure of spirit may find the Holy Grail in the castle of AAAAaaaaaargh
        -f        delete folder between each testbuild, only keep log
        -v        verbose output
        -h        show this text
EOF
    exit 0
}

## XXX customized paths
function apply_patches(){
    ## setting number of build threads, appending meta-eldk
    patch -p0 -b < ~/patches/lothars__m28evk-m53evk__bblayers.conf.patch > /dev/null
    patch -p0 -b < ~/patches/lothars__local.conf.patch > /dev/null

#     ## central SSTATE
#     pth_work="${1}"
#     [[ -z "${pth_work}" ]] && die "ERROR: no work path set"
#     mkdir -p "${PTH_SSTATE}"
# #    local pth_sstate="${PTH_SSTATE///\/}"
# #    sed -i -e "/^#SSTATE_DIR ?= /s/.*/SSTATE_DIR ?= \"${PTH_SSTATE///\/}\"/" ${pth_work}conf/local.conf
# #    sed -i "/#SSTATE_DIR ?= /s/.*/SSTATE_DIR ?= \"${PTH_SSTATE///\/}\"/" ${pth_work}conf/local.conf
#     patch -p0 -b < ~/patches/lothars__sstate.patch > /dev/null
}

function check_machine(){
    local machine=$1
    [[ ! -n "${machine}" ]] && die "ERROR: machine was empty"

    ## restrict to just ELDK
#    local selection=( $(ls ${PTH_RECIPES}meta-eldk/conf/machine/ | sed -n 's/^\(.*\)\.conf/\1/p') )
#    if [[ ! -n "$(echo ${selection[*]} | grep " ${machine} " )" ]]; then

    ## all possible MACHINEs
    local selection=( $(ls ${PTH_RECIPES}*/conf/machine/ | sed -n 's/^\(.*\)\.conf/\1/p') )
    if [[ ! -n "$(echo ${selection[*]} | grep " ${machine} " )" ]]; then
        die "ERROR: MACHINE '${machine}' is not contained in list of possible machines: ${selection[*]}"
    fi
}

function check_image(){
    local image=$1
    [[ ! -n "${image}" ]] && die "ERROR: image was empty"

    ## all possible images
    local selection=( $(find ${PTH_RECIPES} -name images -exec ls {} \; | sed 's/\.bb//g') )
    if [[ ! -n "$( echo ${selection[*]} | grep " ${image} " )" ]]; then
        die "ERROR: IMAGE '${image}' is not contained in list of possible images: ${selection[*]}"
    fi
}

function build(){
    local machine=$1
    [[ ! -n "${machine}" ]] && die "ERROR: machine was empty"

    local image=$2
    [[ ! -n "${image}" ]] && die "ERROR: image was empty"

    fancy_echo
    fancy_echo "BUILD: MACHINE='${machine}' IMAGE='${image}'"
    echo

    local pth_work="${PTH}${TEST_PREFIX}${machine}-${image}/"

    dont_patch=""
    [[ -e "${pth_work}" ]] && dont_patch="1"

    pushd $(pwd) > /dev/null
    cd "${PTH_RECIPES}" || die "ERROR: no path '${PTH_RECIPES}' available"

    ## init yocto environment
    BUILD_NAME=$(git branch | sed -ne '/(no branch)/d' -e 's/$/-/' -e 's/^\* //p')$(git log --format="%ad-%h" --date=short HEAD^\!)
    BDIR="${pth_work}"
    source oe-init-build-env ${PTH_OPTBUILD}${BUILD_NAME}-${machine}-${image}

    ## apply individual patches...
    if [[ ! -n "${dont_patch}" ]]; then
        apply_patches "${pth_work}"
    fi

    ## logging
    local logdir="${PTH_LOG}${machine}__${image}/"
    mkdir -p "${logdir}" || die "ERROR: not possible to create '${logdir}'"
    MACHINE="${machine}" bitbake -s > "${logdir}packagelist.txt"

    ## run
    MACHINE="${machine}" bitbake ${do_verbose} "${image}"

    ## list of products to expect
    tmpfile="/tmp/$(date +%Y%m%d%H%M%S)-testenv.txt"
    MACHINE=${machine} bitbake -e ${image} > ${tmpfile}
    local test_products=( $(cat ${tmpfile} | sed -n 's/KERNEL_IMAGETYPE="\(.*\)".*/\1/p') )
    local extensions=( $(cat ${tmpfile} | sed -n 's/IMAGE_FSTYPES="\(.*\)".*/\1/p') )
    for extension in ${extensions[*]}; do
        test_products=( ${test_products[*]} "${image}-${machine}.${extension}" )
    done

    for product in ${test_products[*]}; do
        echo
        echo "check '${product}': "
        if [[ -e "${pth_work}tmp/deploy/images/${product}" ]]; then
# TODO further tests, e.g. size,...
            fancy_echo "ok"
            echo "checked product: '${product}': Ok" >> "${logdir}tested.txt"
        else
            ## no products generated = FAILED
            fancy_echo "FAILED"
            echo "checked product: '${product}': FAIL" >> "${logdir}tested.txt"
            echo "FAILED - '${pth_work}tmp/deploy/images/${product}' not found"
            if [[ -d "${pth_work}tmp/log/cooker" ]]; then
                mv "${pth_work}tmp/log/cooker/${machine}" "${logdir}BROKEN"
            else
                touch "${logdir}BROKEN"
                break
            fi
        fi
    done

    popd > /dev/null

    ## clean to save space
    [[ "1" == "${do_force}" ]] && remove_dir "${pth_work}"
}




                                                                                
## BEGIN                                                                        
while getopts hvf cmd; do
    case ${cmd} in
        h) usage;;
        v) do_verbose="-v";;
        f) do_force=1;;
    esac
done

[[ -e "${PTH_LOG}" ]] && remove_dir "${PTH_LOG}"
mkdir -p "${PTH_LOG}"

echo "Run all permutations of..."
echo

for machine in ${TEST_MACHINES[*]}; do
    check_machine "${machine}"
    echo " * ${machine}"
done
echo

echo "...and..."
echo

for image in ${TEST_IMAGES[*]}; do
    check_image "${image}"
    echo " * ${image}"
done
echo

echo "Proeceed (y|n)? "
read resp

## obtain first letter, and convert to lower case
resp="$(echo "${resp}" | head -c 1 | tr A-Z a-z )"
[[ "y" == "${resp}" ]] || die "Aborted"
echo "Starting..."
for image in ${TEST_IMAGES[*]}; do
    for machine in ${TEST_MACHINES[*]}; do
        echo
        build "${machine}" "${image}"
    done
done

printf "READY.\n"
