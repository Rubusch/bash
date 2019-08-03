#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##

#set -x

PREV_TOTAL=0
PREV_IDLE=0
PREV_TOTAL0=0
PREV_IDLE0=0
PREV_TOTAL1=0
PREV_IDLE1=0

function die()
{
    echo $@
    exit 1
}

function usage()
{
cat <<EOF
        `basename $0` <seconds>

        DESCRIPTION:
                pipe output into a .csv file, in order to work and plot the data
                as spreadsheet, e.g. by running
                $ ./`basename $0` 1 >> ./stats.csv
                or if you want to display the output
                $ ./`basename $0` 1 | tee 2>&1 ./stats.csv
EOF
}

function XXX_printstats()
{
    echo
    echo "XXX CPU '${CPU[*]}'"
    echo "XXX CPU0 '${CPU0[*]}'"
    echo "XXX CPU1 '${CPU1[*]}'"
    echo "XXX CTXT '${CTXT[*]}'"
    echo "XXX BTIME '${BTIME[*]}'"
    echo "XXX PROCESSES '${PROCESSES[*]}'"
    echo "XXX PROCS_RUNNING '${PROCS_RUNNING[*]}'"
    echo "XXX PROCS_BLOCKED '${PROCS_BLOCKED[*]}'"
    echo "XXX SOFTIRQ '${SOFTIRQ[*]}'"
    echo
}

function calculate_stats()
{
    local whichone=$1; shift
    local vals=($@)

    local idle=${vals[3]}
    local total=0
    for item in ${vals[*]}; do
        let total+=$item
    done

    ## differential behavior
    case $whichone in
        cpu)
            local prev_idle=$PREV_IDLE
            local prev_total=$PREV_TOTAL
        ;;
        cpu0)
            local prev_idle=$PREV_IDLE0
            local prev_total=$PREV_TOTAL0
            ;;
        cpu1)
            local prev_idle=$PREV_IDLE1
            local prev_total=$PREV_TOTAL1
            ;;
        *) die "ERROR"
    esac

    let DIFF_IDLE=$idle-$prev_idle
    let DIFF_TOTAL=$total-$prev_total
    let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"

    case $whichone in
        cpu)
            PREV_IDLE=$idle
            PREV_TOTAL=$total
            CPU=(${vals[*]} "$DIFF_USAGE")
        ;;
        cpu0)
            PREV_IDLE0=$idle
            PREV_TOTAL0=$total
            CPU0=(${vals[*]} "$DIFF_USAGE")
            ;;
        cpu1)
            PREV_IDLE1=$idle
            PREV_TOTAL1=$total
            CPU1=(${vals[*]} "$DIFF_USAGE")
            ;;
        *) die "ERROR"
    esac
}



(( $# == 0 )) && usage && exit 1
INTERVAL_SECONDS=$1; shift


echo -n "cat /proc/stat for x86 - "
date '+20%y-%m-%d %Hh%M'
echo "time interval: '$INTERVAL_SECONDS'"
echo "calculation based on the amount of time, measured in units of USER_HZ (1/100ths of a second on most architectures, use sysconf(_SC_CLK_TCK) to obtain the right value),  that  the  system spent in user mode, user mode with low priority (nice), system mode, and the idle task, respectively.  The last value should be USER_HZ times the second entry in the uptime pseudo-file."
echo

## first line
echo "cpu;;;;;;;;;;;cpu1;;;;;;;;;;;cpu2;;;;;;;;;;"

## second line
echo -n "time in user mode;time in user mode (nice);time in system mode;time in idle task;iowait - time waiting for io to complete;irq - time  servicing  interrupts;softirq - time servicing softirqs - time servicing softirqs;steal - stolen time, which is the time spent in other operating systems when running in a virtualized environment;guest, which is the time spent running a virtual CPU for guest operating systems under the control of the Linux kernel;guest (nice);usage in percent;"
echo -n "time in user mode;time in user mode (nice);time in system mode;time in idle task;iowait - time waiting for io to complete;irq - time  servicing  interrupts;softirq - time servicing softirqs - time servicing softirqs;steal - stolen time, which is the time spent in other operating systems when running in a virtualized environment;guest, which is the time spent running a virtual CPU for guest operating systems under the control of the Linux kernel;guest (nice);usage in percent;"
echo -n "time in user mode;time in user mode (nice);time in system mode;time in idle task;iowait - time waiting for io to complete;irq - time  servicing  interrupts;softirq - time servicing softirqs - time servicing softirqs;steal - stolen time, which is the time spent in other operating systems when running in a virtualized environment;guest, which is the time spent running a virtual CPU for guest operating systems under the control of the Linux kernel;guest (nice);usage in percent;"

echo -n "ctxt - The number of context switches that the system underwent;btime - boot time, in seconds since the Epoch;processes - Number of forks since boot;procs_running - Number of processes in runnable state;procs_blocked - Number of processes blocked waiting for I/O to complete;SOFTIRQ;"
echo

while true; do
    OUTPUT=`cat /proc/stat`

    CPU=( $(printf "%s\n" "$OUTPUT" | grep "cpu ") )
    CPU0=( $(printf "%s\n" "$OUTPUT" | grep "cpu0") )
    CPU1=( $(printf "%s\n" "$OUTPUT" | grep "cpu1") )
    CTXT=( $(printf "%s\n" "$OUTPUT" | grep "ctxt") )
    BTIME=( $(printf "%s\n" "$OUTPUT" | grep "btime") )
    PROCESSES=( $(printf "%s\n" "$OUTPUT" | grep "processes") )
    PROCS_RUNNING=( $(printf "%s\n" "$OUTPUT" | grep "procs_running") )
    PROCS_BLOCKED=( $(printf "%s\n" "$OUTPUT" | grep "procs_blocked") )
    SOFTIRQ=( $(printf "%s\n" "$OUTPUT" | grep "softirq") )

    ## unset description
    unset CPU[0]
    unset CPU0[0]
    unset CPU1[0]
    unset CTXT[0]
    unset BTIME[0]
    unset PROCESSES[0]
    unset PROCS_RUNNING[0]
    unset PROCS_BLOCKED[0]
    unset SOFTIRQ[0]

#    XXX_printstats

    calculate_stats "cpu" ${CPU[*]}
    calculate_stats "cpu0" ${CPU0[*]}
    calculate_stats "cpu1" ${CPU1[*]}
    LINE=(${CPU[*]} ${CPU0[*]} ${CPU1[*]} ${CTXT[1]} ${BTIME[1]} ${PROCESSES[1]} ${PROCS_RUNNING[1]} ${PROCS_BLOCKED[1]} ${SOFTIRQ[1]})

    LINE=$(echo "${LINE[*]}" | sed 's/ /;/g')
    sleep ${INTERVAL_SECONDS}
    echo "${LINE}"
done

