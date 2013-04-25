#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## resources: YongYe <expertshell@gmail.com> BeiJing China
##
## game panel (maze), and navigation demo

AVATARCOORDS=(4 6 5 6) # avatar coordinates (y x y x y x)
#AVATARCOORDS=(6 6 7 6) # avatar coordinates (y x y x y x)   
AVATARICON=[] # avatar icon

INDENTY=3 # indentation of the top area
INDENTX=5 # indentation of the left area
PANELY=20 # num y coords of the game area
PANELX=20 # num x coords of the game area
COLTAB=(1\;{30..37}\;{40..47}m) # color definition of the pieces

GOALX=38
GOALY=18

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
    local res=0 y=${1} x=${2}
    (( res=y*PANELX+x/2 ))
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

                             
## TODO - check not used??
invocation loop
loop()
{
    local i j
    for((i=INDENTY+1; i<=PANELY+INDENTY; ++i))
    do
        for((j=INDENTX+1; j<=2*(PANELX-1)+INDENTX+1; j+=2))
        do
            ## first arg, per field (col)
            ${1}
        done
        ## sec arg, per row
        ${2}
    done
}

## init of "map" and "pam" structs
initialization()
{
    local rsyx
    ((rsyx=(i-INDENTY-1)*PANELX+j/2-INDENTY)) ## TODO - not used?

    ## map of fields
    ((map[rsyx]=0)) # TODO - not used?

#    ((pam[rsyx]=0)) # TODO rm
}
                                

## generate game area
boundary()
{
    clear
#    wallcol="\e[1;36m"
    local wallcol="\e[1;34m"

    ## top and bottom
    for((i=INDENTX+1; i<=2*PANELX+INDENTX; i+=2)); do
        echo -e "${wallcol}\e[${INDENTY};${i}H##\e[$((PANELY+INDENTY+1));${i}H##\e[0m"
    done

    ## side walls
    for((i=INDENTY; i<=PANELY+INDENTY+1; ++i)); do
        echo -e "${wallcol}\e[${i};$((INDENTX-1))H##\e[${i};$((2*PANELX+INDENTX+1))H##\e[0m"
    done

#    x_walls=( 0 0 0 0 0 0 0 )  
#    y_walls=( 0 1 2 3 4 5 6 )  

    ## maze
    ## left, upper wall
    x_walls=( 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3  2  3  2  3  2  3  2  3  2  3  2  3 )
    y_walls=( 0 0 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10 11 11 12 12 13 13 14 14 15 15 )


    ## left, bottom wall
    x_walls=( ${x_walls[*]}  8  9  8  9  8  9  8  9  8  9  8  9  8  9  8  9  8  9  8  9 )
    y_walls=( ${y_walls[*]} 10 10 11 11 12 12 13 13 14 14 15 15 16 16 17 17 18 18 19 19 )


    ## L shaped wall
    x_walls=( ${x_walls[*]} 10 11 10 11 10 11 10 11 12 13 12 13 )
    y_walls=( ${y_walls[*]}  4  4  5  5  6  6  7  7  6  6  7  7 )


    ## C shaped wall pt.1
    x_walls=( ${x_walls[*]} 16 17 16 17 16 17 16 17 16 17 16 17 18 19 18 19 20 21 20 21 22 23 22 23 24 25 24 25 )
    y_walls=( ${y_walls[*]}  0  0  1  1  2  2  3  3  6  6  7  7  6  6  7  7  6  6  7  7  6  6  7  7  6  6  7  7 )


    ## pt.2
    x_walls=( ${x_walls[*]} 16 17 16 17 16 17 16 17 18 19 18 19 24 25 24 25 24 25 24 25 24 25 24 25 24 25 24 25 24 25 )
    y_walls=( ${y_walls[*]}  8  8  9  9 10 10 11 11 10 10 11 11  8  8  9  9 10 10 11 11 12 12 13 13 14 14 15 15 16 16 )

    x_walls=( ${x_walls[*]} 24 25 16 17 16 17 18 19 18 19 20 21 20 21 22 23 22 23 24 25 24 25 16 17 16 17 16 17 16 17 )
    y_walls=( ${y_walls[*]} 17 17 18 18 19 19 18 18 19 19 18 18 19 19 18 18 19 19 18 18 19 19 18 18 19 19 16 16 17 17 )


    ## pt.3
    x_walls=( ${x_walls[*]} 16 17 16 17 18 19 18 19 30 31 30 31 )
    y_walls=( ${y_walls[*]} 14 14 15 15 14 14 15 15  0  0  1  1 )


    ## I block wall, right
    x_walls=( ${x_walls[*]} 30 31 30 31 30 31 30 31 30 31 30 31 30 31 30 31 30 31 30 31 )
    y_walls=( ${y_walls[*]}  4  4  5  5  6  6  7  7  8  8  9  9 10 10 11 11 12 12 13 13 )


    ## right, bottom wall
    x_walls=( ${x_walls[*]} 34 35 34 35 34 35 34 35 34 35 34 35 34 35 34 35 34 35 34 35 )
    y_walls=( ${y_walls[*]} 10 10 11 11 12 12 13 13 14 14 15 15 16 16 17 17 18 18 19 19 )


    ## horizontal small wall, right
    x_walls=( ${x_walls[*]} 34 35 34 35 36 37 36 37 38 39 38 39 )
    y_walls=( ${y_walls[*]}  6  6  7  7  6  6  7  7  6  6  7  7 )


    for ((idx=0; idx<${#x_walls[*]}; ++idx)) ; do
        x=${x_walls[idx]}
        y=${y_walls[idx]}

#        echo "x '$x' y '$y'"   


## draw walls
#        echo -e "${wallcol}\e[$((INDENTY+1+y));$((INDENTX+1+x))H##\e[0m"
        echo -e "${wallcol}\e[$((INDENTY+1+y));$((INDENTX+1+x))H#\e[0m"


## colision detection
# TODO wall( x, y )

        ## 2d-array conversion: "map" contains 400 elements
        ## for blockings (walls) contains 1, rest 0
        ## x=0, y=0 -> map[0]
        ## x=1, y=0 -> map[20]
        ## x=19, y=19 -> map[399]; max field

#        ((yox=(y)*(INDENTX + PANELX-INDENTX) + (x/2) ))
#        ((yox=y*PANELX + x/2 ))


        yox=$(xy2map $y $x)
        
#        echo "yox $yox"  
        

#        ((yox=(x-INDENTY-1)*PANELX+y/2-INDENTY))  

        ((map[yox]=1)) # collision detection

#        echo $(map[xy2map 4 8 ] )
#        pam[yox]="${colbox}" # TODO

    done

#    echo "${map[*]}"

    ## target
# TODO rm
#    x=38
#    y=18
    echo -e "${wallcol}\e[1;33m\e[$((INDENTY+1+GOALY));$((INDENTX+1+GOALX))HGO\e[$((INDENTY+2+GOALY));$((INDENTX+1+GOALX))HAL\e[0m"
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
        1) echo "XXX ${TRACKING[*]}"
#            set -x
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
#        setavatar box$(radom)[@] # TODO rm
#        setavatar box7[*] # TODO rm
        setavatar AVATARCOORDS[*]
        colbox="$(echo -n ${COLTAB[RANDOM/512]})"
        coordinate box[@] repaint
    } || {
        colbox="${srmcbox}"
        coordinate rmcbox[@] repaint
    }
    oldbox="${cursor}"


    ## TODO rm - necessary? seems to be filled up tetris terminate condition
    # if ! movebox pose; then
    #     kill -${sigExit} ${PPID}
    #     sendkill
    #     Quit
    # fi
}

## detect if movement is possible
movebox()
{
                                                
    local x y i j xoy vor boolx booly
    vor=(${!1})
    smu=${#vor[@]}
    for((i=0; i<${#vor[@]}; i+=2)); do
        ((x=vor[i]+dx))
        ((y=vor[i+1]+dy))

        ## 
        ((xoy=(x-INDENTY-1)*PANELX+y/2-INDENTY))
        (( xoy < 0 )) && return 1

        ## within panel
        boolx="x <= INDENTY || x > PANELY+INDENTY"
        booly="y > 2*PANELX+INDENTX || y <= INDENTX"
        (( boolx || booly )) && return 1

        if (( map[xoy] == 1 )); then
            if (( smu == 2 )); then
                for((j=PANELY+INDENTY; j>x; --j)); do
                    (( map[(j-INDENTY-1)*PANELX+y/2-INDENTY] == 0 )) && return 0
                done
            fi
            return 1
        fi

    done
    return 0
}

## get coordinates of the avatar
coordinate()
{
   local i sup vor
   vor=(${!1})
   for((i=0; i<${#vor[@]}; i+=2))
   do
       cursor+="\e[${vor[i]};${vor[i+1]}H${AVATARICON}"
       sup+="${vor[i]} ${vor[i+1]} "
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
    pose="${sup}"
}

chckposup(){
    echo -n "0";
}
chckposdown(){
    echo -n "0";
}
chckposleft(){
    echo -n "0";
}


chckposright(){
    local heady headx currxy blocked position
    currxy=($pose)
    blocked=0

    ((heady=currxy[0]))
    position="${heady}_"
    ((headx=currxy[1]+2))
    position="${position}${headx}_"
    blocked=$(isblocked $heady $headx)
    ((0 != $blocked)) && echo -n "1" && return;

    ((heady=currxy[2]))
    position="${heady}_"
    ((headx=currxy[3]+2))
    position="${position}${headx}_"
    blocked=$(isblocked $heady $headx)
    ((0 != $blocked)) && echo -n "1" && return;

    ## find position in backtrack
    [[ 1==$(findinbacktrack "${position}") ]] && echo -n "1" && return;

    ## default: ok
    echo -n "0";
}


isblocked()
{
    local y=$1 x=$2 xoy res mapidx

    ((xoy=(x-INDENTY-1)*PANELX+y/2-INDENTY))
    (( xoy < 0 )) && echo -n "1" && return

    boolx="x <= INDENTY || x > PANELY+INDENTY"
    booly="y > 2*PANELX+INDENTX || y <= INDENTX"
    (( boolx || booly )) && echo -n "1" && return

    (( mapidx=((y-INDENTY-1) * PANELX) + (x-1-INDENTX-1) ));
    res=0
    (( map[ $mapidx ] != 0 )) && res=1 || res=0
    echo -n "$res";
}

direction()
{
    local dx dy currxy sizegoalx sizegoaly headings idx headx heady blocked
    sizegoalx=2
    sizegoaly=2

    currxy=( $pose )

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
    item=""
    for item in ${headings[*]}; do
#        echo $item  
        HEADING=$item
        if [[ "up" == $item ]]; then
            ((heady=currxy[0]-1))
            ((headx=currxy[1]))
#            echo $heady $headx  
            blocked=$(isblocked $heady $headx)
#            echo $blocked  

        elif [[ "down" == $item ]]; then
            ((heady=currxy[2]+1))
            ((headx=currxy[3]))
#            echo $heady $headx  
            blocked=$(isblocked $heady $headx)
#            echo $blocked  

        elif [[ "left" == $item ]]; then
            ((heady=currxy[0]))
            ((headx=currxy[1]-2))
#            echo $heady $headx  
            blocked=$(isblocked $heady $headx)
#            echo $blocked  
            ((0 != $blocked)) && continue

            ((heady=currxy[2]))
            ((headx=currxy[3]-2))
#            echo $heady $headx   
            blocked=$(isblocked $heady $headx)
#            echo $blocked   

        elif [[ "right" == $item ]]; then
            ((1==$(chckposright))) && continue
            
#             ((heady=currxy[0]))
#             ((headx=currxy[1]+2))
# #            echo $heady $headx   
#             blocked=$(isblocked $heady $headx)
# #            echo $blocked  
#             ((0 != $blocked)) && continue

#             ((heady=currxy[2]))
#             ((headx=currxy[3]+2))
# #            echo $heady $headx   
#             blocked=$(isblocked $heady $headx)
# #            echo $blocked   

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
    for item in ${TRACKING[*]}; do
        [[ "${item}" == "${position}" ]] && echo -n "1" && return;
    done
    echo -n "0";
}

## history of positions
backtrack()
{
    local item
    TRACKING=( ${TRACKING[*]} "${pose// /_}" )
    ((TRACKIDX+=1))

## DEBUG TRACKING
#    echo $TRACKIDX
#    echo ${TRACKING[*]}
#    for item in ${TRACKING[*]}; do
#        echo "$item"
#    done

## DEBUG find
#    res=$(findinbacktrack "${pose// /_}")
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
                ${sigLeft}   )  transform 0 -2  ;;
                ${sigRight}  )  transform 0  2  ;;
                ${sigDown}   )  transform 1  0  ;;
                ${sigUp}     )  transform -1 0  ;;
            esac
        done

        
# TODO algorithm
# - go right, if not possible,
# - go down, if not possible,
# - go up, if not possible - do bugfix, go left, then.. something

        ## go 
        direction
        transform $(move)
        backtrack

        ## go right
#       transform 0 1 # TODO algorithm
#        break   
    done
}


## move piece

## perform type of movement
transform()
{
    local dx dy cursor smu
    dx=${1}
    dy=${2}
    (( $# == 2 )) && moveon # || rotate
}


## move the avatar within the boundaries
moveon()
{
    if movebox pose; then
        echo -e "${oldbox//[]/  }\e[0m"

#        hdbox # TODO rm
#        (( smu == 2 )) && across ## TODO rm
        
#        increment # TODO rm
        
   local v
   for((v=0; v<${#box[@]}; v+=2))
   do
      ((box[v]+=dx))
      ((box[v+1]+=dy))
   done
   nbox=(${box[@]})
   coordinate box[@] repaint
   box=(${nbox[@]})
        
# TODO collision detection
#             ((map[yox]=1))  

#  loop check mapbox


# TODO not chocking with x_walls y_walls
# if lower bottom, tetris handling, etc
#    else
#        echo "XXX" 
#        (( dx == 1 )) && {  
#        offset # calculate score, update panel (remove pieces)

#            drawbox

#        showbox # preview
#        }
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
