#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## resources: YongYe <expertshell@gmail.com> BeiJing China
##
## game panel (maze), and navigation demo

box7=(4 6 5 6) # avatar icon coordinates (x y x y x y x y)

mrx=[] # piece definition
modh=3 # height of the top area
modw=5 # width of the left area
height=20 # height of the game area
width=20 # width of the game area
coltab=(1\;{30..37}\;{40..47}m) # color definition of the pieces

                                                                                
## signal traps
for signal in Rotate Left Right Down Up Exit Transf ; do
    ((sig${signal}=++gis+24)) # signal definition
done

                                                                                
## tools (inline functions)
#radom(){ echo -n 7; }    TODO rm
kisig(){ kill -${sigExit} ${pid}; } # signal transfer for exit
piece(){ box=(${!1}); } # current block definition
color(){ echo -n ${coltab[RANDOM/512]}; } # generate the randomly number between zero and sisty-three
serxy(){ kbox="${sup}"; } # vertical and horizontal coordinates
hdbox(){ echo -e "${oldbox//[]/  }\e[0m"; } # erase the old pieces
check(){ (( map[(i-modh-1)*width+j/2-modh] == 0 )) && break; } # check the current row whether it's fully filled up with pieces

## function

## restore default stty settings
resume()
{
   stty ${STTY}
   echo -e "\e[?25h\e[36;4H"
}

## invocation loop
loop()
{
    local i j
    for((i=modh+1; i<=height+modh; ++i))
    do
        for((j=modw+1; j<=2*(width-1)+modw+1; j+=2))
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
{  # initial all the background pieces to be empty 
    local rsyx
    ((rsyx=(i-modh-1)*width+j/2-modh))
    ((map[rsyx]=0))
#    ((pam[rsyx]=0)) # TODO rm
}

## generate game area
boundary()
{
    clear
    boncol="\e[1;36m"

    ## top and bottom
    for((i=modw+1; i<=2*width+modw; i+=2)); do
        echo -e "${boncol}\e[${modh};${i}H##\e[$((height+modh+1));${i}H##\e[0m"
    done

    ## side walls
    for((i=modh; i<=height+modh+1; ++i)); do
        echo -e "${boncol}\e[${i};$((modw-1))H##\e[${i};$((2*width+modw+1))H##\e[0m"
    done

    ## maze
    ## left, upper wall
    x_walls=( 2 2 2 2 2 2 2 2 2 2  2  2  2  2  2  2 )
    y_walls=( 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 )

    ## left, bottom wall
    x_walls=( ${x_walls[*]}  8  8  8  8  8  8  8  8  8  8 )
    y_walls=( ${y_walls[*]} 10 11 12 13 14 15 16 17 18 19 )

    ## L shaped wall
    x_walls=( ${x_walls[*]} 10 10 10 10 12 12 )
    y_walls=( ${y_walls[*]}  4  5  6  7  6  7 )

    ## C shaped wall pt.1
    x_walls=( ${x_walls[*]} 16 16 16 16 16 16 18 18 20 20 22 22 24 24 )
    y_walls=( ${y_walls[*]}  0  1  2  3  6  7  6  7  6  7  6  7  6  7 )

    ## pt.2
    x_walls=( ${x_walls[*]} 16 16 16 16 18 18 24 24 24 24 24 24 24 24 24 24 16 16 18 18 20 20 22 22 24 24 16 16 16 16 )
    y_walls=( ${y_walls[*]}  8  9 10 11 10 11  8  9 10 11 12 13 14 15 16 17 18 19 18 19 18 19 18 19 18 19 18 19 16 17 )

    ## pt.3
    x_walls=( ${x_walls[*]} 16 16 18 18 30 30 )
    y_walls=( ${y_walls[*]} 14 15 14 15  0  1 )

    ## I block wall, right
    x_walls=( ${x_walls[*]} 30 30 30 30 30 30 30 30 30 30 )
    y_walls=( ${y_walls[*]}  4  5  6  7  8  9 10 11 12 13 )

    ## right, bottom wall
    x_walls=( ${x_walls[*]} 34 34 34 34 34 34 34 34 34 34 )
    y_walls=( ${y_walls[*]} 10 11 12 13 14 15 16 17 18 19 )

    ## horizontal small wall, right
    x_walls=( ${x_walls[*]} 34 34 36 36 38 38 )
    y_walls=( ${y_walls[*]}  6  7  6  7  6  7 )

    for ((idx=0; idx<${#x_walls[*]}; ++idx)) ; do
        x=${x_walls[idx]}
        y=${y_walls[idx]}

#        echo "x $x; y $y"


## paint labyrinth
#        echo -e "${boncol}\e[$((modh+1+y));$((modw+1+x))H##\e[$((modh+2+y));$((modw+1+x))H##\e[0m"
        echo -e "${boncol}\e[$((modh+1+y));$((modw+1+x))H##\e[0m"


## colision detection
# TODO wall( x, y )

        ## 2d-array conversion: "map" contains 400 elements
        ## for blockings (walls) contains 1, rest 0
        ## x=0, y=0 -> map[0] 
        ## x=1, y=0 -> map[20]
        ## x=19, y=19 -> map[399]; max field
#        ((yox=(x-modh-1)*width+y/2-modh))   
        ((yox=(y)*(modw + width-modw) + (x/2) )) ## only works for first line

#        echo "yox ${yox}"  
        ((map[yox]=1)) # collision detection   

#        pam[yox]="${colbox}" # TODO

    done

    ## target
    x=38
    y=18
    echo -e "${boncol}\e[$((modh+1+y));$((modw+1+x))HGO\e[$((modh+2+y));$((modw+1+x))HAL\e[0m"

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
        if   [[ ${key} == ${pool} && ${arry[1]} == ${pool} ]];then Quit 0
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
        1) kisig
            resume ;;
        2) resume ;;
    esac
    exit
}

## draw avatar
drawbox()
{
    (( $# == 1 )) && {
#        piece box$(radom)[@] # TODO rm
        piece box7[*]
        colbox="$(color)"
        coordinate box[@] regxy
    } || {
        colbox="${srmcbox}"
        coordinate rmcbox[@] regxy
    }
    oldbox="${cdn}"
    if ! movebox locus; then
        kill -${sigExit} ${PPID}
        kisig
        Quit
    fi
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
        ((xoy=(x-modh-1)*width+y/2-modh))
        (( xoy < 0 )) && return 1
        boolx="x <= modh || x > height+modh"
        booly="y > 2*width+modw || y <= modw"
        (( boolx || booly )) && return 1
        if (( map[xoy] == 1 )); then
            if (( smu == 2 )); then
                for((j=height+modh; j>x; --j)); do
                    (( map[(j-modh-1)*width+y/2-modh] == 0 )) && return 0
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
       cdn+="\e[${vor[i]};${vor[i+1]}H${mrx}"
       sup+="${vor[i]} ${vor[i+1]} "
   done
   ${2}
}

# TODO rm
# draw avatar path
# ptbox()
# {
#    oldbox="${cdn}" # comment out for displaying the track
#    echo -e "\e[${colbox}${cdn}\e[0m"
# }


## hide track (or turn it on), and collision detection
regxy()
{
   oldbox="${cdn}" # comment out for displaying the track
#   echo -e "\e[${colbox}${cdn}\e[0m"
   locus="${sup}" # collision detection
}

## game loop, handle user control input
persig()
{
    local sigSwap pid
    pid=${1}
    drawbox 0 # draw

    for i in sigRotate sigTransf sigLeft sigRight sigDown sigUp ; do
        trap "sig=${!i}" ${!i}
    done
    trap "kisig; Quit" ${sigExit}

    while : # game loop
    do

# TODO rm
#set +x
#Quit
#continue   

        for ((i=0; i<20-level; ++i)); do
            sleep 0.02
            sigSwap=${sig}
            sig=0
            case ${sigSwap} in
                ${sigRotate} )  transform 0     ;;
                ${sigTransf} )  transform 1     ;;
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

        ## go down
#       transform 1  0 # falling down

        ## go right
#       transform 0 1 # TODO algorithm
    done
}


## move piece

## perform type of movement
transform()
{
   local dx dy cdn smu
   dx=${1}
   dy=${2}
   (( $# == 2 )) && move_straight # || rotate
}

## move the avatar within the boundaries
move_straight()
{
    if movebox locus; then
        hdbox
#        (( smu == 2 )) && across ## TODO rm
        
#        increment # TODO rm
        
   local v
   for((v=0; v<${#box[@]}; v+=2))
   do
      ((box[v]+=dx))
      ((box[v+1]+=dy))
   done
   nbox=(${box[@]})
   coordinate box[@] regxy
   box=(${nbox[@]})
        
# TODO collision detection
#             ((map[yox]=1))  

#  loop check  mapbox


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

    loop initialization # init each field (col), per line (row)
    boundary # paint game panel
    persig $! # game loop

} || {
    echo "Run"  
    ## restart game
    bash $0 Run ${1} &

    ## continue with navigation
    control $!
}
