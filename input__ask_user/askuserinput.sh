#!/bin/bash
##
## ask for user input
##

for (( ; ; )); do
    echo -n "shall we proceed? [yes]/[no] "
    read answer
    answer=`echo ${answer} | tr "[:upper:]" "[:lower:]"`
    case "${answer}" in
        yes)
            ## action for 'yes'
            echo "    do the yes-action"
            echo

            break
            ;;

        no)
            ## action for 'no'
            echo "    do the no-action"
            echo

            break
            ;;

        *)
            echo "your answer was '${answer}' - please answer with [yes] or [no]"
            ;;
    esac
done


echo "READY."
echo

