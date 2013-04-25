#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3

## TODO coords

AVATARCOORDS=(4 6) # avatar coordinates (y x y x y x)
#AVATARCOORDS=(6 6 7 6) # avatar coordinates (y x y x y x)   
AVATARICON="L" # avatar icon

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

# TODO rm - check
#for signal in Rotate Left Right Down Up Exit Transf ; do
#for signal in Left Right Down Up Exit Transf ; do
for signal in Left Right Down Up Exit ; do
#    ((sig${signal}=++gis+24)) # signal definition

#for signal in Left Right Down Up ; do
    ((sig${signal}=++gis+24)) # signal definition
done

                                                                                
## tools (inline functions)

#sendkill(){ kill -${sigExit} ${pid}; } # signal transfer for exit
sendkill(){ kill -15 ${pid}; } # signal transfer for exit
setavatar(){ box=(${!1}); } # current block definition
xy2map(){
    local res=0 x=${1} y=${2}

#    (( res=y*PANELX+x/2 ))
    (( res = x + y*PANELX ))
    echo -n $res;
}

# TODO rm
#(j-INDENTY-1)*PANELX+y/2-INDENTY



# TODO rm
#radom(){ echo -n 7; }    TODO rm
#color(){ echo -n ${COLTAB[RANDOM/512]}; } # generate the randomly number between zero and sisty-three
#serxy(){ kbox="${sup}"; } # vertical and horizontal coordinates
#hdbox(){ echo -e "${oldbox//[]/  }\e[0m"; } # erase the old pieces
#check(){ (( map[(i-INDENTY-1)*PANELX+j/2-INDENTY] == 0 )) && break; } # check the current row whether it's fully filled up with pieces

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
    local mapidx wallcol="\e[1;34m"

    ## top and bottom

#    for((i=INDENTX+1; i<=PANELX+INDENTX; i+=1)); do
#        echo -e "${wallcol}\e[${INDENTY};${i}H##\e[$((PANELY+INDENTY+1));${i}H##\e[0m"

    for((i=INDENTX; i<=PANELX+INDENTX+1; ++i)); do
        echo -e "${wallcol}\e[${INDENTY};${i}H#\e[$((PANELY+INDENTY+1));${i}H#\e[0m"
    done


    ## side walls

#    for((i=INDENTY; i<=PANELY+INDENTY+1; ++i)); do
#        echo -e "${wallcol}\e[${i};$((INDENTX-1))H##\e[${i};$((PANELX+INDENTX+1))H##\e[0m"

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

    for ((idx=0; idx<${#x_walls[*]}; ++idx)) ; do
        x=${x_walls[idx]}
        y=${y_walls[idx]}

        ## draw single wall pieces
        echo -e "${wallcol}\e[$((INDENTY+1+y));$((INDENTX+1+x))H#\e[0m"

        ## colision detection array
        ##
        ## 2d-array conversion: "map" contains 400 elements
        ## for blockings (walls) contains 1, rest 0
        ## x=0, y=0 -> map[0]
        ## x=1, y=0 -> map[20]
        ## x=19, y=19 -> map[399]; max field
        mapidx=$(xy2map $x $y)
        ((map[mapidx]=1))

    done

## DEBUG - dump map
# local dbgidx=0
# echo "" > ./map.log
# for ((dbgidx=0; dbgidx<200; ++dbgidx)); do
#     echo "idx '$dbgidx' - map '${map[$dbgidx]}'" >> ./map.log
# done

    ## GOAL
    echo -e "${wallcol}\e[1;33m\e[$((INDENTY+1+GOALY));$((INDENTX+1+GOALX))HX\e[0m"
}

## user input and navigation
control()
{  # deal with the input messages
    local pid key arry pool STTY sig
    pid=${1}
    arry=(0 0 0)
    pool=$(echo -ne "\e")
    STTY=$(stty -g) # change terminal line settings
    trap "Quit 0" INT TERM
    trap "Quit 0 0" ${sigExit}
    echo -ne "\e[?25l"
    while :
    do
        read -s -n 1 key
        arry[0]=${arry[1]}
        arry[1]=${arry[2]}
        arry[2]=${key}
        sig=0
        if [[ ${key} == ${pool} && ${arry[1]} == ${pool} ]]; then Quit 0
        elif [[ ${arry[0]} == ${pool} && ${arry[1]} == "[" ]]; then
            case ${key} in
                A)    sig=${sigUp}        ;;
                B)    sig=${sigDown}      ;;
                C)    sig=${sigRight}     ;;
                D)    sig=${sigLeft}      ;;
            esac
        else
            case ${key} in
                Q|q)  Quit 0              ;;
            esac
        fi
        (( sig != 0 )) && kill -${sig} ${pid}
    done
}

## terminate
Quit()
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

## draw avatar
drawbox()
{
    (( $# == 1 )) && {
        setavatar AVATARCOORDS[*]
        colbox="$(echo -n ${COLTAB[RANDOM/512]})"
        coordinate box[@] repaint
    } || {
        colbox="${srmcbox}"
        coordinate rmcbox[@] repaint
    }
    oldbox="${cursor}"


    ## TODO rm - necessary? seems to be filled up tetris terminate condition
    # if ! movement globxypos; then
    #     kill -${sigExit} ${PPID}
    #     sendkill
    #     Quit
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
   local i sup coords
   coords=(${!1})
   for((i=0; i<${#coords[@]}; i+=2))
   do
       cursor+="\e[${coords[i]};${coords[i+1]}H${AVATARICON}"
       sup+="${coords[i]} ${coords[i+1]} "
   done
   ${2}
}


## hide track (or turn it on), and collision detection
repaint()
{
    ## repaint background - comment out for displaying the track
    oldbox="${cursor}"

    ## show cursor
    echo -e "\e[${colbox}${cursor}\e[0m"

    ## collision detection
    globxypos="${sup}"
}

chckposup(){
    local heady headx currxy blocked position
    echo "chckposup" >> ./debug.log   
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
    echo "position ${position//_/ } - blocked $blocked" >> ./debug.log 
    ((1 == blocked )) && echo -n "1" && return;

    echo -n "0";
}

chckposdown(){
    local heady headx currxy blocked position
    echo "chckposdown" >> ./debug.log   
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

    echo "position ${position//_/ } - blocked $blocked" >> ./debug.log 
    ((1==blocked)) && echo -n "1" && return;

    ## find position in backtrack
    blocked=$(findinbacktrack "${position}")
    (( 1 == $blocked)) && echo -n "1" && return;

    echo -n "0";
}

chckposleft(){
    local heady headx currxy blocked position
    echo "chckposleft" >> ./debug.log   
    currxy=($globxypos)
    blocked=0

    ((heady=currxy[0]))
    position="${heady}_"
    ((headx=currxy[1]-2))
    position="${position}${headx}_"
    blocked=$(isblocked $heady $headx)
    echo "position ${position//_/ } - blocked $blocked" >> ./debug.log 
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
    local heady headx currxy blocked position
    echo "chckposright" >> ./debug.log   
    currxy=($globxypos)
    blocked=0

    ((heady=currxy[0]))
    position="${heady}_"
# XXX
#    ((headx=currxy[1]+2)) 
    ((headx=currxy[1]+1))
    position="${position}${headx}_"
    blocked=$(isblocked $heady $headx)

#    ((1 == $blocked)) && echo -n "1" && return;
#     ((heady=currxy[2]))
#     position="${position}${heady}_"
# #    ((headx=currxy[3]+2)) 
#     ((headx=currxy[3]+1))
#     position="${position}${headx}_"
#    blocked=$(isblocked $heady $headx)

    echo "position ${position//_/ } - blocked $blocked" >> ./debug.log 
    ((1 == $blocked)) && echo -n "1" && return;

    ## find position in backtrack
    blocked=$(findinbacktrack "${position}")
    echo "position ${position//_/ } - blocked $blocked" >> ./debug.log 
    (( 1 == blocked )) && echo -n "1" && return;

    ## default: ok
    echo -n "0";
}

## check if specified field has a block entry in map
isblocked()
{
    local y=$1 x=$2 xoy res mapidx
    echo "y '$y' x '$x'" >> ./debug.log   

#    ((xoy=(x-INDENTY-1)*PANELX+y/2-INDENTY))
#    (( xoy < 0 )) && echo -n "1" && return

    ## boundaries
    boolx="x <= INDENTY || x > PANELY+INDENTY"
    booly="y > 2*PANELX+INDENTX || y <= INDENTX"
    (( boolx || booly )) && echo -n "1" && return

#    (( mapidx=((y-INDENTY-1) * PANELX) + (x-1-INDENTX-1) ));
    (( mapidx=((y-INDENTY-1) * PANELX) + (x-2-INDENTX) ));
    echo "mapidx $mapidx" >> ./debug.log   

    res=0; (( map[ $mapidx ] != 0 )) && res=1 || res=0
    echo -n "$res";
}

direction()
{
    local dx dy currxy sizegoalx sizegoaly headings idx headx heady blocked
    sizegoalx=2
    sizegoaly=2

    currxy=( $globxypos )

    ((dx=GOALX/2+1+sizegoalx - currxy[3]/2))
    ((dy=GOALY+1+2*sizegoaly - currxy[2]))

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

    ## check for blocking
    echo " " >> ./debug.log    
    item=""
    for item in ${headings[*]}; do
        echo $item  >> ./debug.log    
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
        "left" ) diff=(0 -2) ;;
        "right" ) diff=(0 2) ;;
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
    drawbox 0 # draw

#    for i in sigRotate sigTransf sigLeft sigRight sigDown sigUp ; do
#    for i in sigTransf sigLeft sigRight sigDown sigUp ; do
    for i in sigLeft sigRight sigDown sigUp ; do
        trap "sig=${!i}" ${!i}
    done

    trap "sendkill; Quit" ${sigExit}

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
#        direction
#        transform $(move)
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
        echo -e "${oldbox//${AVATARICON}/ }\e[0m"

# TODO refac
        local v
        for((v=0; v<${#box[*]}; v+=2))
        do
            ((box[v]+=dy))
            ((box[v+1]+=dx))
        done
        nbox=(${box[*]})
        coordinate box[*] repaint
        box=(${nbox[*]})

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
    echo "restarted xRun"  

# TODO rm - not used?
#    loop initialization # init each field (col), per line (row)

    boundary # paint game panel
    gameloop $!

} || {
    echo "Run"  
    ## restart game
    bash $0 Run ${1} &

    ## continue with navigation
    control $!
}
