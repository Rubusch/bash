#!/bin/bash
##
## print 80 times one character
## means fill with 80 times the same token

## as function
function fancy_echo(){
    if [[ -n "${1}" ]]; then
        local message="$@ "
    fi
    local max=80
    local cnt=$(expr ${max} - length "${message}")
    echo -n "${message}"
    for i in $(seq ${cnt}); do echo -n '.'; done
    echo
}


## the basic approach, this may need BASH 3.0 or higher
for i in {1..80}; do
    echo -n '='
done
echo

echo "printf"
printf %80s |tr " " "="

echo "another printf approach"
printf '=%.0s' {1..80}; echo

echo "using printf and echo"
str=$( printf "%80s" ); echo ${str// /=}

echo "seq"
seq -s= 81|tr -d '[:digit:]'

echo "perl way"
perl -E 'say "=" x 80'

echo "using head"
head -c 80 < /dev/zero | tr '\0' '='

echo "fill options, quick"
text='something'
cnt=$(expr 80 - length $text)
echo $text$(perl -E 'say "=" x '$cnt)

echo "fill up, just based on echo and seq"
echo -n ${text}
cnt=$(expr 80 - length $text)
for i in $(seq ${cnt}); do echo -n '='; done
echo

echo "fill up, as function..."
fancy_echo
fancy_echo "something"

echo "READY."
