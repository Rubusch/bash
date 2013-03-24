#!/bin/bash
# by Paul Colby (http://colby.id.au), no rights reserved ;)
#set -x

# PREV_TOTAL=0
# PREV_IDLE=0

PREV_TOTAL1=0
PREV_IDLE1=0

PREV_TOTAL2=0
PREV_IDLE2=0

echo "cpu1; cpu2"

while true; do
#    CPU2=(${echo ${OUTPUT} | grep '^cpu\[1\]'})

#  CPU=(`cat /proc/stat | grep '^cpu '`) # Get the total CPU statistics.
#  CPU1=(`cat /proc/stat | grep '^cpu\[0\]'`) # Get the total CPU statistics.
#  CPU2=(`cat /proc/stat | grep '^cpu\[1\]'`) # Get the total CPU statistics.
    CPU1=( `grep 'cpu0' /proc/stat` )
    CPU2=( `grep 'cpu1' /proc/stat` )
#    echo "XXX CPU1 - '${CPU1[*]}'"
#    echo "XXX CPU2 - '${CPU2[*]}'"

#  unset CPU[0]                          # Discard the "cpu" prefix.
  unset CPU1[0]
  unset CPU2[0]

#  IDLE=${CPU[4]}                        # Get the idle CPU time.
  IDLE1=${CPU1[4]}                        # Get the idle CPU time.
  IDLE2=${CPU2[4]}                        # Get the idle CPU time.

  # # Calculate the total CPU time.
  # TOTAL=0
  # for VALUE in "${CPU[@]}"; do
  #   let "TOTAL=$TOTAL+$VALUE"
  # done

  # Calculate the total CPU time.
  TOTAL1=0
  for VALUE1 in "${CPU1[@]}"; do
    let "TOTAL1=$TOTAL1+$VALUE1"
  done

    # Calculate the total CPU time.
  TOTAL2=0
  for VALUE2 in "${CPU2[@]}"; do
    let "TOTAL2=$TOTAL2+$VALUE2"
  done

  # # Calculate the CPU usage since we last checked.
  # let "DIFF_IDLE=$IDLE-$PREV_IDLE"
  # let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
  # let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"

  let "DIFF_IDLE1=$IDLE1-$PREV_IDLE1"
  let "DIFF_TOTAL1=$TOTAL1-$PREV_TOTAL1"
  let "DIFF_USAGE1=(1000*($DIFF_TOTAL1-$DIFF_IDLE1)/$DIFF_TOTAL1+5)/10"

  let "DIFF_IDLE2=$IDLE2-$PREV_IDLE2"
  let "DIFF_TOTAL2=$TOTAL2-$PREV_TOTAL2"
  let "DIFF_USAGE2=(1000*($DIFF_TOTAL2-$DIFF_IDLE2)/$DIFF_TOTAL2+5)/10"


#  echo -en "\rCPU: $DIFF_USAGE%  \b\b"
#  echo "$DIFF_USAGE%"

  echo "$DIFF_USAGE1%; $DIFF_USAGE2%"

  # Remember the total and idle CPU times for the next check.
#  PREV_TOTAL="$TOTAL"
#  PREV_IDLE="$IDLE"

  PREV_TOTAL1="$TOTAL1"
  PREV_IDLE1="$IDLE1"

  PREV_TOTAL2="$TOTAL2"
  PREV_IDLE2="$IDLE2"

  # Wait before checking again.
  sleep 1
done