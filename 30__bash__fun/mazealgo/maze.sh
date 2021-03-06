#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3

# FIXME artefarcts when trail is turned off

AVATARCOORDS=(4 6) # avatar global coordinates (y x)
AVATARICON="2" # avatar icon

INDENTY=3 # indentation of the top area
INDENTX=5 # indentation of the left area
PANELX=20 # num x coords of the game area
PANELY=10 # num y coords of the game area
COLTAB=(1\;{30..37}\;{40..47}m) # color definition of the pieces

GOALX=19
GOALY=9

TRACKING=( "0_0_" )
TRACKIDX=0

GOBACKTO=""

HEADING="right"

                                                                                
## signal traps

for signal in Left Right Down Up Exit ; do
    ((sig${signal}=++gis+24)) # signal definition
done

                                                                                
## regular stack implementation, with BP and SP for around 100 elements
BP=100
SP=$BP
DATA=declare -a STACK
push()
{
    [[ -z "$1" ]] && return;
    ((SP -= 1))
    STACK[$SP]=$1
    return
}

pop()
{
    DATA=
    [[ "$SP" -eq "$BP" ]] && return;
    DATA=${STACK[$SP]}
    ((SP += 1))
    echo -n "$DATA";
}

                                                                                
## further functions

sendkill(){ kill -15 ${pid} > /dev/null; } # signal transfer for exit
setavatar(){ AVATARCOORDS=(${!1}); } # current block definition
getpanely(){
    local panely=$1
    ((panely=panely-INDENTY-1))
    echo -n $panely;
}
getpanelx(){
    local panelx=$1
    ((panelx=panelx-INDENTX-1))
    echo -n $panelx
}

xy2map(){ local res=0; ((res=$1+$2*PANELX)); echo -n $res; }

map2x(){
    local x=0 idx=$1
    ((x= idx % PANELX))
    echo -n $x;
}
map2y(){
    local idx=$1 y=0
    ((y=idx / PANELX))
    echo -n $y;
}

## function

## restore default stty settings
resume()
{
   stty ${STTY}
   echo -e "\e[?25h\e[36;4H"
}


## generate game area
boundary()
{
    clear
    local mapidx wallcol="\e[1;34m" x y

    ## top and bottom
    for((i=INDENTX; i<=PANELX+INDENTX+1; ++i)); do
        echo -e "${wallcol}\e[${INDENTY};${i}H#\e[$((PANELY+INDENTY+1));${i}H#\e[0m"
    done


    ## side walls
    for((i=INDENTY; i<=PANELY+INDENTY; ++i)); do
        echo -e "${wallcol}\e[${i};$((INDENTX))H#\e[${i};$((PANELX+INDENTX+1))H#\e[0m"
    done

    ## maze
    ## left, upper wall
    x_walls=( 1 1 1 1 1 1 1 1 )
    y_walls=( 0 1 2 3 4 5 6 7 )

    ## left, bottom wall
    x_walls=( ${x_walls[*]} 4 4 4 4 4 )
    y_walls=( ${y_walls[*]} 5 6 7 8 9 )

    ## L shaped wall
    x_walls=( ${x_walls[*]} 5 5 6 )
    y_walls=( ${y_walls[*]} 2 3 3 )

    ## C shaped wall pt.1
    x_walls=( ${x_walls[*]} 9 8 8 8 9 10 11 12 12 12 12 12 12 12 11 10 9 8 8 8 9 )
    y_walls=( ${y_walls[*]} 5 5 4 3 3  3  3  3  4  5  6  7  8  9  9  9 9 9 8 7 7 )

    ## mini wall, top
    x_walls=( ${x_walls[*]} 8 8 )
    y_walls=( ${y_walls[*]} 0 1 )

    ## I block wall, right
    x_walls=( ${x_walls[*]} 15 15 15 15 15 15 )
    y_walls=( ${y_walls[*]}  0  1  2  3  4  5 )

    ## right, bottom wall
    x_walls=( ${x_walls[*]} 17 18 19 )
    y_walls=( ${y_walls[*]}  3  3  3 )

    ## horizontal small wall, right
    x_walls=( ${x_walls[*]} 17 17 17 17 17 )
    y_walls=( ${y_walls[*]}  5  6  7  8  9 )

    ## convert coords to map and set walls
    for ((idx=0; idx<${#x_walls[*]}; ++idx)) ; do
        mapidx=$(xy2map ${x_walls[idx]} ${y_walls[idx]})
        ((map[mapidx]=1))
    done

    ## double check - reconvert map to draw walls on display
    x=0; y=0
    for (( idx=0; idx<PANELX*PANELY; ++idx )) ; do
        if (( 1 == map[$idx] )); then
            x=$(map2x $idx)
            y=$(map2y $idx)
            echo -e "${wallcol}\e[$((INDENTY+1+y));$((INDENTX+1+x))H1\e[0m"
        fi
    done

## DEBUG: dump map here

    ## draw a GOAL
    echo -e "${wallcol}\e[44m\e[1;31m\e[$((INDENTY+1+GOALY));$((INDENTX+1+GOALX))H3\e[0m"
}

## user input and navigation
control()
{  # deal with the input messages
    local pid key arry pool STTY sig
    pid=${1}
    arry=(0 0 0)
    pool=$(echo -ne "\e")
    STTY=$(stty -g) # change terminal line settings
    trap "Die 0" INT TERM
    trap "Die 0 0" ${sigExit}
    echo -ne "\e[?25l"
    while :
    do
        read -s -n 1 key
        arry[0]=${arry[1]}
        arry[1]=${arry[2]}
        arry[2]=${key}
        sig=0
        if [[ ${key} == ${pool} && ${arry[1]} == ${pool} ]]; then Die 0
        elif [[ ${arry[0]} == ${pool} && ${arry[1]} == "[" ]]; then
            case ${key} in
                A)    sig=${sigUp}        ;;
                B)    sig=${sigDown}      ;;
                C)    sig=${sigRight}     ;;
                D)    sig=${sigLeft}      ;;
            esac
        else
            case ${key} in
                Q|q)  Die 0              ;;
            esac
        fi
        (( sig != 0 )) && kill -${sig} ${pid}
    done
}

## terminate
Die()
{
    case $# in
        0 ) ;;
        1) sendkill
           resume ;;
        2) resume ;;
    esac
    exit
}

# TODO needed?
## draw avatar
drawbox()
{
    setavatar AVATARCOORDS[*]
    colbox="$(echo -n ${COLTAB[RANDOM/512]})"
    coordinate AVATARCOORDS[@] repaint
    oldbox="${cursor}"

    (( $# == 1 )) && {
        setavatar AVATARCOORDS[*]
        colbox="$(echo -n ${COLTAB[RANDOM/512]})"
        coordinate AVATARCOORDS[@] repaint
    } || {
        colbox="${srmcbox}"
        coordinate rmcbox[@] repaint
    }
    oldbox="${cursor}"
}

## detect if movement is possible
movement()
{
    local globx globy panelx panely mapidx coords numofcoords boolx booly
    coords=(${!1})
    numofcoords=${#coords[*]}

    ((globy=coords[0]+dy))
    ((globx=coords[1]+dx))

    ## check - within panel
    boolx="globy <= INDENTY || globy > PANELY+INDENTY"
    booly="globx > PANELX+INDENTX || globx <= INDENTX"
    (( boolx || booly )) && return 1

    ## panel coords conversion
    ((panely=globy-INDENTY-1))
    ((panelx=globx-INDENTX-1))

    ## conversion to mapidx
    mapidx=$(xy2map $panelx $panely)
    (( mapidx < 0 )) && return 1

    ## check for blocks in map
    (( 1 == map[mapidx] )) && return 1
    return 0
}

## get coordinates of the avatar
coordinate()
{
   local sup coords=(${!1})
   cursor="\e[${coords[0]};${coords[1]}H${AVATARICON}"
   sup="${coords[0]} ${coords[1]} "
   ${2}
}


## hide track (or turn it on), and collision detection
repaint()
{
    ## repaint background - comment out for displaying the track
#    oldbox="${cursor}" # FIXME

    ## show cursor
    echo -e "\e[${colbox}${cursor}\e[0m"

    ## collision detection
    globxypos="${sup}"
}


chckposleft()
{
    local panely panelx blocked=0 position

    panely=$(getpanely ${AVATARCOORDS[0]})
    position="${panely}_"
    panelx=$(getpanelx ${AVATARCOORDS[1]})
    ((panelx-=1)) ## it's just a jump to the left...
    position="${position}${panelx}_"
    blocked=$(isblocked $panely $panelx)
    ((1 == blocked)) && echo -n "1" && return;

    blocked=$(findinbacktrack ${position})
    ((1 ==blocked )) && echo -n "1" || echo -n "0";
}


chckposright()
{
    local panely panelx blocked=0 position

    panely=$(getpanely ${AVATARCOORDS[0]})
    position="${panely}_"
    panelx=$(getpanelx ${AVATARCOORDS[1]})
    ((panelx+=1)) ## and then a step to the right...
    position="${position}${panelx}_"
    blocked=$(isblocked $panely $panelx)
    ((1 == $blocked)) && echo -n "1" && return;

    blocked=$(findinbacktrack ${position})
    ((1 ==blocked )) && echo -n "1" || echo -n "0";

}

chckposup(){
    local panely panelx blocked=0 position

    panely=$(getpanely ${AVATARCOORDS[0]})
    ((panely-=1)) ## up
    position="${panely}_"
    panelx=$(getpanelx ${AVATARCOORDS[1]})
    position="${position}${panelx}_"
    blocked=$(isblocked $panely $panelx)
    ((1 == blocked)) && echo -n "1" && return;

    blocked=$(findinbacktrack ${position})
    (( 1 == blocked )) && echo -n "1" || echo -n "0";
}

chckposdown(){
    local panely panelx blocked=0 position

    panely=$(getpanely ${AVATARCOORDS[0]})
    ((panely+=1)) ## and down
    position="${panely}_"
    panelx=$(getpanelx ${AVATARCOORDS[1]})
    position="${position}${panelx}_"
    blocked=$(isblocked $panely $panelx)
    ((1 == blocked)) && echo -n "1" && return;

    blocked=$(findinbacktrack ${position})
    ((1 ==blocked )) && echo -n "1" || echo -n "0";
}


## check if specified field has a block entry in map
isblocked()
{
    local y=$1 x=$2 mapidx

    ## is blocked by panel boundaries?
    boolx="x < 0 || x >= PANELX"
    booly="y < 0 || y >= PANELY"
    (( boolx || booly )) && echo -n "1" && return

    ## is blocked by a wall?
    mapidx=$(xy2map $x $y)
    (( map[$mapidx] == 1 )) && echo -n "1" || echo -n "0";
}

direction()
{
    local dx dy currx curry headings dir possible possibledirs

    curry=$(getpanely ${AVATARCOORDS[0]})
    currx=$(getpanelx ${AVATARCOORDS[1]})
    ((dx=GOALX+1 - currx))
    ((dy=GOALY+1 - curry))

    ## orientation priority
    if (( 0 <= dx && 0 <= dy )); then
        if (( dx > dy )); then
            headings=("right" "down" "up" "left")
        else
            headings=("down" "right" "left" "up")
        fi
    elif (( 0 <= dx && 0 > dy )); then
        if (( dx > -dy )); then
            headings=("right" "up" "down" "left")
        else
            headings=("up" "right" "left" "down")
        fi
    elif (( 0 > dx && 0 <= dy )); then
        if (( -dx > dy )); then
            headings=("left" "down" "up" "right")
        else
            headings=("down" "left" "right" "up")
        fi
    elif (( 0 > dx && 0 > dy )); then
        if (( -dx > -dy )); then
            headings=("left" "up" "down" "right")
        else
            headings=("up" "left" "right" "down")
        fi
    fi

    possibledirs=( $(peekaround) )
    if [[ "0" != ${#possibledirs} ]]; then

        ## DEBUG: print possible dirs here

        HEADING=""
        for dir in ${headings[*]}; do
            for possible in ${possibledirs[*]}; do
                if [[ "$dir" == "$possible" ]]; then
                ## possible direction
                    HEADING="$dir"
                    break
                fi
            done
            [[ ! -z "${HEADING}" ]] && break
        done
    else
        pop > /dev/null
        GOBACKTO=$(pop)
        GOBACKTO=$(pop)

        if [[ "${GOBACKTOBACKUP}" == "${GOBACKTO}" ]]; then
            ## just accelerating a bit
            GOBACKTO=$(pop)
            GOBACKTO=$(pop)
            GOBACKTO=$(pop)
            GOBACKTO=$(pop)
        fi
        GOBACKTOBACKUP=GOBACKTO
        ## DEBUG: print go back here
    fi

    ## more than one free direction (ahead)
    (( 1 < ${#possibledirs[*]} )) && push "${curry}_${currx}_"
}


## direction code: up=1; rightt=2; down=4; left=8
## needs local coords
peekaround()
{
    local directions=()

    (( 0==$(chckposup) )) && directions=( ${directions[*]} "up" )
    (( 0==$(chckposdown) )) && directions=( ${directions[*]} "down" )
    (( 0==$(chckposleft) )) && directions=( ${directions[*]} "left" )
    (( 0==$(chckposright) )) && directions=( ${directions[*]} "right" )

    echo -n ${directions[*]};
}


move()
{
    local diff
    case $HEADING in
        "down" ) diff=(1 0) ;;
        "up" ) diff=(-1 0) ;;
        "left" ) diff=(0 -1) ;;
        "right" ) diff=(0 1) ;;
        *) ;;
    esac
    echo -n "${diff[*]}";
}

## search for position already visited
findinbacktrack()
{
    local item position="$1"
    for item in ${TRACKING[*]}; do
        [[ "${item}" == "${position}" ]] && echo -n "1" && return;
    done
    echo -n "0";
}

## history of positions
backtrack()
{
    local item position
    position="$(getpanely ${AVATARCOORDS[0]})_$(getpanelx ${AVATARCOORDS[1]})_"

    [[ "1" == $(findinbacktrack "$position") ]] && return
    TRACKING=( ${TRACKING[*]} "${position}" )
    ((TRACKIDX+=1))

## DEBUG TRACKING
#    echo $TRACKIDX
#    echo ${TRACKING[*]}
#    for item in ${TRACKING[*]}; do
#        echo "$item"
#    done

## DEBUG find
#    position="5_6_" # negative test: 0
#    res=$(findinbacktrack "${position}")
#    echo "$res"
}

## game loop, handle user control input
gameloop()
{
    local sigSwap pid
    pid=${1}

    ## draw avatar and set old
    setavatar AVATARCOORDS[*]
    colbox="$(echo -n ${COLTAB[RANDOM/512]})"
    coordinate AVATARCOORDS[@] repaint
    oldbox="${cursor}"
    drawbox 0
    for i in sigLeft sigRight sigDown sigUp ; do
        trap "sig=${!i}" ${!i}
    done

    trap "sendkill; Die" ${sigExit}

    while :
    do
        for ((i=0; i<20-level; ++i)); do
            sleep 0.02
            sigSwap=${sig}
            sig=0
            case ${sigSwap} in
                ${sigLeft}   )  transform 0 -1  ;;
                ${sigRight}  )  transform 0  1  ;;
                ${sigDown}   )  transform 1  0  ;;
                ${sigUp}     )  transform -1 0  ;;
            esac
        done

        ## algorithm
        local curry=0 currx=0
        if [[ -n "${GOBACKTO}" ]]; then
            ## conversion
            GOBACKTO=(${GOBACKTO//_/ })
            ((curry=INDENTY+1+GOBACKTO[0]))
            ((currx=INDENTX+1+GOBACKTO[1]))
            AVATARCOORDS=($curry $currx)
            GOBACKTO=""
        fi

        ## in case no direction was found, skip further steps
        direction
        transform $(move)

        curry=$(getpanely ${AVATARCOORDS[0]})
        currx=$(getpanelx ${AVATARCOORDS[1]})
        if (( curry == 9 && currx == 19 )); then
            echo "DONE - Q to exit!"
            Die;
        fi

        backtrack
    done
}


## move piece

## perform type of movement
transform()
{
    local dx dy cursor numofcoords
    dy=${1}
    dx=${2}

    (( $# != 2 )) && return

    ## move the AVATAR within boundaries
    if movement globxypos; then

        ## remove artefact trails
        echo -e "${oldbox//${AVATARICON}/ }\e[0m"

        ((AVATARCOORDS[0]+=dy))
        ((AVATARCOORDS[1]+=dx))

        nbox=(${AVATARCOORDS[*]})
        coordinate AVATARCOORDS[*] repaint
        AVATARCOORDS=(${nbox[*]})
    fi
}


                                                                                
## START
[[ "x${1}" == "xRun" ]] && {
    ## daemon - restarted to paint game panel
    boundary
    gameloop $!

} || {
#    echo "Run"
    ## restart/daemon trick to draw board
    bash $0 Run ${1} &

    ## keep controls active via traps
    control $!
}
