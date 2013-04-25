#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3

## TODO coords

## global coords
AVATARSTART=(4 6) # TODO rm??
AVATARCOORDS=(4 6) # avatar coordinates (y x y x y x)
AVATARICON="2" # avatar icon

INDENTY=3 # indentation of the top area
INDENTX=5 # indentation of the left area
PANELX=20 # num x coords of the game area
PANELY=10 # num y coords of the game area
COLTAB=(1\;{30..37}\;{40..47}m) # color definition of the pieces

GOALX=19
GOALY=9

TRACKING=()
TRACKIDX=0

HEADING="right"
                                                                                
## signal traps

for signal in Left Right Down Up Exit ; do
    ((sig${signal}=++gis+24)) # signal definition
done

                                                                                
## tools (inline functions)

sendkill(){ kill -15 ${pid}; } # signal transfer for exit
#setavatar(){ box=(${!1}); } # current block definition
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
#    local mapidx wallcol="\e[1;31m"

    ## top and bottom
    for((i=INDENTX; i<=PANELX+INDENTX+1; ++i)); do
        echo -e "${wallcol}\e[${INDENTY};${i}H#\e[$((PANELY+INDENTY+1));${i}H#\e[0m"
    done


    ## side walls
    for((i=INDENTY; i<=PANELY+INDENTY; ++i)); do
        echo -e "${wallcol}\e[${i};$((INDENTX))H#\e[${i};$((PANELX+INDENTX+1))H#\e[0m"
    done

# DEBUG
#    x_walls=( 0 )  
#    y_walls=( 0 )  

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

## DEBUG - dump map
# local dbgidx=0
# echo "" > ./map.log
# for ((dbgidx=0; dbgidx<200; ++dbgidx)); do
#     echo "idx '$dbgidx' - map '${map[$dbgidx]}'" >> ./map.log
# done

    ## draw a GOAL
#    echo -e "${wallcol}\e[1;33m\e[$((INDENTY+1+GOALY));$((INDENTX+1+GOALX))H3\e[0m"
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
        1)
#            kill -15 ${pid};
            sendkill
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
#    coordinate box[@] repaint
    coordinate AVATARCOORDS[@] repaint
    oldbox="${cursor}"

    (( $# == 1 )) && {
        setavatar AVATARCOORDS[*]
        colbox="$(echo -n ${COLTAB[RANDOM/512]})"
#        coordinate box[@] repaint
        coordinate AVATARCOORDS[@] repaint
    } || {
        colbox="${srmcbox}"
        coordinate rmcbox[@] repaint
    }
    oldbox="${cursor}"


    ## TODO rm - necessary? seems to be filled up tetris terminate condition
    # if ! movement globxypos; then
    #     kill -${sigExit} ${PPID}
    #     sendkill
    #     Die
    # fi
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
#   local i sup coords
   local sup coords=(${!1})
#   for((i=0; i<${#coords[@]}; i+=2))
#   do
#       cursor+="\e[${coords[i]};${coords[i+1]}H${AVATARICON}"
#       sup+="${coords[i]} ${coords[i+1]} "
#   done
   cursor="\e[${coords[0]};${coords[1]}H${AVATARICON}"
   sup="${coords[0]} ${coords[1]} "

   ${2}
}


## hide track (or turn it on), and collision detection
repaint()
{
    ## repaint background - comment out for displaying the track
    oldbox="${cursor}"

    ## show cursor
#    echo -e "\e[${colbox}${cursor}\e[0m"
    echo -e "\e[42m\e[31m${cursor}\e[0m"

    ## collision detection
    globxypos="${sup}"
}

chckposup(){
    local heady headx currxy blocked position
#    echo "chckposup" >> ./debug.log   
    currxy=($globxypos)
    blocked=0

    ((heady=currxy[0]-1))
    position="${heady}_"
    ((headx=currxy[1]))
    position="${position}${headx}_"
    blocked=$(isblocked $heady $headx)
    ((1 == $blocked)) && echo -n "1" && return;

    # ((heady=currxy[2]-1))
    # position="${position}${heady}_"
    # ((headx=currxy[3]))
    # position="${position}${headx}_"

    ## find position in backtrack
#    [[ "1"==$(findinbacktrack "${position}") ]] && echo -n "1" && return;

    blocked=$(findinbacktrack "${position}")
#    echo "position ${position//_/ } - blocked $blocked" >> ./debug.log 
    ((1 == blocked )) && echo -n "1" && return;

    echo -n "0";
}

chckposdown(){
    local heady headx currxy blocked position
#    echo "chckposdown" >> ./debug.log   
    currxy=($globxypos)
    blocked=0

    ((heady=currxy[0]+1))
    position="${heady}_"
#    ((headx=currxy[1]))
    ((headx=currxy[1]+1))  
    position="${position}${headx}_"

#     ((heady=currxy[2]+1))
#     position="${position}${heady}_"
# #    ((headx=currxy[3]))
#     ((headx=currxy[3]+1))  
#     position="${position}${headx}_"

    blocked=$(isblocked $heady $headx)

#    echo "position ${position//_/ } - blocked $blocked" >> ./debug.log 
    ((1==blocked)) && echo -n "1" && return;

    ## find position in backtrack
    blocked=$(findinbacktrack "${position}")
    (( 1 == $blocked)) && echo -n "1" && return;

    echo -n "0";
}

chckposleft(){
    local heady headx currxy blocked position
#    echo "chckposleft" >> ./debug.log   
    currxy=($globxypos)
    blocked=0

    ((heady=currxy[0]))
    position="${heady}_"
    ((headx=currxy[1]-2))
    position="${position}${headx}_"
    blocked=$(isblocked $heady $headx)
#    echo "position ${position//_/ } - blocked $blocked" >> ./debug.log 
    ((1 == $blocked)) && echo -n "1" && return;

    # ((heady=currxy[2]))
    # position="${position}${heady}_"
    # ((headx=currxy[3]-2))
    # position="${position}${headx}_"
#    blocked=$(isblocked $heady $headx)
#    echo "position ${position//_/ } - blocked $blocked" >> ./debug.log 
#    ((1 == $blocked)) && echo -n "1" && return;

    ## find position in backtrack
    blocked=$(findinbacktrack "${position}")
    ((1 == blocked )) && echo -n "1" && return;
#    [[ "1"==$(findinbacktrack "${position}") ]] && echo -n "1" && return;

    echo -n "0";
}


chckposright(){
# TODO headxy -> panelxy   
    local heady headx currxy blocked position
    echo "chckposright" >> ./debug.log   
#    currxy=($globxypos)

    blocked=0

#    ((heady=currxy[0])) 
#    ((heady=AVATARCOORDS[0]))
    heady=$(getpanely ${AVATARCOORDS[0]})
    position="${heady}_"

#    ((headx=currxy[1]+1)) 
#    ((headx=AVATARCOORDS[1]+1))
    headx=$(getpanelx ${AVATARCOORDS[0]})
    position="${position}${headx}_"

    blocked=$(isblocked $heady $headx)
#    echo "position ${position//_/ } - blocked $blocked" >> ./debug.log 
    ((1 == $blocked)) && echo -n "1" && return;

    ## find position in backtrack
    blocked=$(findinbacktrack "${position}")
#    echo "position ${position//_/ } - blocked $blocked" >> ./debug.log 
    (( 1 == blocked )) && echo -n "1" && return;

    ## default: ok
    echo -n "0";
}

## check if specified field has a block entry in map
isblocked()
{
# TODO rm
# TODO need to be panelxy!!!   
#    echo "y '$y' x '$x'" >> ./debug.log   
#    ((xoy=(x-INDENTY-1)*PANELX+y/2-INDENTY))
#    (( xoy < 0 )) && echo -n "1" && return
#    boolx="x <= INDENTY || x > PANELY+INDENTY"
#    booly="y > 2*PANELX+INDENTX || y <= INDENTX"

    local y=$1 x=$2 mapidx

    ## is blocked by panel boundaries?
    boolx="x < 0 || x >= PANELX"
    booly="y < 0 || y >= PANELY"
    (( boolx || booly )) && echo -n "1" && return

    ## is blocked by a wall?
    mapidx=$(xy2map $x $y)
    echo "y $y - x $x - mapidx $mapidx" >> ./debug.log   
    (( map[$mapidx] == 1 )) && echo -n "1" || echo -n "0";
}

direction()
{
#    local dx dy currxy sizegoalx sizegoaly headings idx headx heady blocked
    local dx dy currx curry headings

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


    ## check for blocking walls
#    echo " " >> ./debug.log    
    local blocked item=""
    for item in ${headings[*]}; do
#        echo $item  >> ./debug.log    
        HEADING=$item
        if [[ "up" == "$item" ]]; then
            ((1==$(chckposup))) && continue
            blocked=0

        elif [[ "down" == "$item" ]]; then
            ((1==$(chckposdown))) && continue
            blocked=0

        elif [[ "left" == "$item" ]]; then
            ((1==$(chckposleft))) && continue
            blocked=0

        elif [[ "right" == "$item" ]]; then
            ((1==$(chckposright))) && continue
            blocked=0

        fi
        if (( 0 == $blocked )); then
            break;
        fi
    done
# TODO don't allow going back, only if everything is blocked -> going back -> crossing with tracked path -> continue at last fork
# TODO follow this way in abnormal manner until some new possibilities arrive (don't go back!)
}


move()
{
    local diff
    case $HEADING in
        "down" ) diff=(1 0) ;;
        "up" ) diff=(-1 0) ;;
        "left" ) diff=(0 -1) ;;
        "right" ) diff=(0 1) ;;
# TODO default action
    esac
    echo -n "${diff[*]}";
}

## search for position already visited
findinbacktrack()
{
    local item position="$1"
#    echo "TRACKING - ${TRACKING[*]}"   
    for item in ${TRACKING[*]}; do
        [[ "${item}" == "${position}" ]] && echo -n "1" && return;
    done
    echo -n "0";
}

## history of positions
backtrack()
{
    local item position="${globxypos// /_}"
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
##    position="5_6_6_6_" # negative test: 0  
#    res=$(findinbacktrack "${position}")
#    echo "$res"
}

## game loop, handle user control input
gameloop()
{
    local sigSwap pid
    pid=${1}

    ## draw avatar and set old
#    setavatar AVATARCOORDS[*]
    setavatar AVATARSTART[*]
    colbox="$(echo -n ${COLTAB[RANDOM/512]})"
#    coordinate box[@] repaint
    coordinate AVATARCOORDS[@] repaint
    oldbox="${cursor}"

    drawbox 0 # draw

#    for i in sigRotate sigTransf sigLeft sigRight sigDown sigUp ; do
#    for i in sigTransf sigLeft sigRight sigDown sigUp ; do
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

        
# TODO algorithm
# - go right, if not possible,
# - go down, if not possible,
# - go up, if not possible - do bugfix, go left, then.. something

# TODO uncomment                                                 
        ## go
        direction
        transform $(move)
#        backtrack
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
        echo -e "${oldbox//2/ }\e[0m"
#        echo -e "${oldbox//${AVATARICON}/ }\e[0m"

# # TODO refac
#         local v
#         for((v=0; v<${#box[*]}; v+=2)); do
#             ((box[v]+=dy))
#             ((box[v+1]+=dx))
#         done
#         echo "box ${box[*]}" >> ./debug.log
#         nbox=(${box[*]})
#         coordinate box[*] repaint
#         box=(${nbox[*]})

        local v
        for((v=0; v<${#AVATARCOORDS[*]}; v+=2)); do
            ((AVATARCOORDS[v]+=dy))
            ((AVATARCOORDS[v+1]+=dx))
        done
#        echo "AVATARCOORDS ${AVATARCOORDS[*]}" >> ./debug.log
        nbox=(${AVATARCOORDS[*]})
        coordinate AVATARCOORDS[*] repaint
        AVATARCOORDS=(${nbox[*]})


# TODO why not possible?
        # ((box[2]+=dx))
        # ((box[1]+=dy))
        # nbox=(${box[*]})
        # coordinate box[*] repaint
        # box=(${nbox[*]})

        # ((AVATARCOORDS[2]+=dx))
        # ((AVATARCOORDS[1]+=dy))
        # nbox=(${AVATARCOORDS[*]})
        # coordinate AVATARCOORDS[*] repaint
        # AVATARCOORDS=(${nbox[*]})
    fi
}


                                                                                
## START
[[ "x${1}" == "xRun" ]] && {
    ## daemon - restarted to paint game panel
    boundary
    gameloop $!

} || {
    echo "Run"
    ## restart/daemon trick to draw board
    bash $0 Run ${1} &

    ## keep controls active via traps
    control $!
}
