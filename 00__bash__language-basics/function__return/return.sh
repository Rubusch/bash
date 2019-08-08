#!/bin/bash -e
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3

return_result()
{
    if [[ -z "${1}" ]]; then
        echo "func: string was zero"
        return 1
    else
        echo "func: string was not zero"
        return 0
    fi
}

return_array()
{
#    echo "1 2"
    echo "${1}aaa ${1}bbb ${1}ccc"
}

_RET=""
return_string()
{
    _RET="${1}${1}${1}"
}


## START
echo "usage: ${0} <string argument|empty>"
echo

## return bool result
echo "bool return value.."
if return_result ${1}; then
    echo "returned: string was not empty"
fi
echo


## return via echo
echo "int or string return values.."
arr=$(return_array ${1})
for item in ${arr[@]}; do
    echo "returned: ${item}"
done
echo

## return via global variable e.g. '_RET'
echo "classic 'return' approach"
return_string ${1}
echo "returned: '${_RET}'"

echo "READY."
