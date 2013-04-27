#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3

string_empty()
{
    if [[ -z "${1}" ]]; then
        echo "func: string was zero"
        return 0
    else
        echo "func: string was not zero"
        return 1
    fi
}

return_values()
{
    echo "1 2"
}



## START

## bool return value
echo "bool return value.."
if string_empty ; then
    echo "string was not empty"
fi
echo

## int or string return value
echo "int or string return values.."
arr=$(return_values)
for item in ${arr[@]}; do
    echo $item
done
echo
