## ASSIGNMENT08
## Lothar Rubusch
##
## maze shell script

#box0=(4 30) # shape definition 
box7=(4 30 5 30) # pixel coordinates (x y x y x y x y)

mrx=[] # piece definition
modh=3 # height of the top area
modw=5 # width of the left area
height=20 # height of the game area
width=20 # width of the game area
coltab=(1\;{30..37}\;{40..47}m) # color definition of the pieces

                                                                                
## signal traps
#for signal in Rotate Left Right Down AllDown Exit Transf
for signal in Rotate Left Right Down Up Exit Transf
do
    ((sig${signal}=++gis+24)) # signal definition
done

                                                                                
## tools (inline functions)
radom(){ echo -n 7; }   
kisig(){ kill -${sigExit} ${pid}; } # signal transfer for exit
piece(){ box=(${!1}); } # current block definition
color(){ echo -n ${coltab[RANDOM/512]}; } # generate the randomly number between zero and sisty-three
serxy(){ kbox="${sup}"; } # vertical and horizontal coordinates
hdbox(){ echo -e "${oldbox//[]/  }\e[0m"; } # erase the old pieces
check(){ (( map[(i-modh-1)*width+j/2-modh] == 0 )) && break; } # check the current row whether it's fully filled up with pieces

## function
resume()
{  # restore to the normal stty settings
   stty ${STTY}
   echo -e "\e[?25h\e[36;4H" 
}


loop()
{  # a shared loop structure used for invocation
    local i j
    for((i=modh+1; i<=height+modh; ++i))
    do
        for((j=modw+1; j<=2*(width-1)+modw+1; j+=2))
        do
            ${1}
        done
        ${2}
    done
}

initialization()
{  # initial all the background pieces to be empty 
    local rsyx
    ((rsyx=(i-modh-1)*width+j/2-modh))
    ((map[rsyx]=0))
    ((pam[rsyx]=0))
}

boundary()
{  # the boundary of the game area
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

    #labyrinth
#    x_walls=( 2 2 2 2 2  2  2  2   8  8  8  8  8  10 10 12  16 16  16 18 20 22 24  16 16 18 24 24 24 24 24 16 18 20 22 24 16 16 16 18 30 30 30 30 30 30  34 34 34 34 34  34 36 38 )
#    y_walls=( 0 2 4 6 8 10 12 14  10 12 14 16 18   4  6  6   0  2   6  6  6  6  6   8 10 10  8 10 12 14 16 18 18 18 18 18 18 16 14 14  0  4  6  8 10 12  10 12 14 16 18   6  6  6 )

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
#    echo -e "${boncol}\e[$((modh+1+18));$((modw+1+19))H##\e[$((modh+2+19));$((modw+1+19))H##\e[0m"
}

getsig()
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
#        elif [[ "[${key}]" == ${mrx} ]]; then sig=${sigAllDown}
        elif [[ ${arry[0]} == ${pool} && ${arry[1]} == "[" ]]; then
            case ${key} in
#                A)    sig=${sigRotate}    ;;
                A)    sig=${sigUp}        ;;
                B)    sig=${sigDown}      ;;
                C)    sig=${sigRight}     ;;
                D)    sig=${sigLeft}      ;;
            esac
        else
            case ${key} in
#                W|w)  sig=${sigRotate}    ;;  
#                T|t)  sig=${sigTransf}    ;;
#                S|s)  sig=${sigDown}      ;;
#                A|a)  sig=${sigLeft}      ;;
#                D|d)  sig=${sigRight}     ;;
#                P|p)  pause ${pid}  0     ;;
#                R|r)  pause ${pid}  1     ;;

#                R|r)  sig=${sigRotate}    ;;  
                Q|q)  Quit 0              ;;
            esac
        fi
        (( sig != 0 )) && kill -${sig} ${pid}
    done
}

Quit()
{  # function used for exiting invocation
   case $# in
        0) echo "Quit() - 0)" ;;                                  
# \e[0m reset shell colors
#       0) echo -e "\e[?25h\e[36;26HGame Over!\e[0m" ;;
        1) echo "Quit() - 1)"  
           kisig
           resume ;;
        2) echo "Quit() - 2)"  
           resume ;;
   esac
           exit
}

# showbox()
# {  # draw the pieces used for preview
#    local smobox
#    colbox="${srmcbox}"
#    olbox=(${rmcbox[@]})
#    invoke ${#}
#    smobox=""
#    piece box$(radom)[@]
#    rmhbox=(${box[@]})
#    srmhbox="$(color)"
#    preview box[@] crsbox -36 srmhbox
#    crsbox="${smobox}"
#    box=(${olbox[@]})
# }

# invoke() 
# {  # a highly abstracted  function intended for invoking the pipebox
#    local aryA aryB aryC i
#    aryA=(m{c..h}box)
#    for((i=0; i<5; ++i))
#    do
#         aryB=(r${aryA[i]} r${aryA[i+1]}[@] ${aryA[i]})
#         aryC=($((12*(2-i))) ${1} s${aryB[0]} sr${aryA[i+1]})
#         pipebox ${aryB[@]} ${aryC[@]}
#    done
# }

# pipebox() 
# {  # core function used for piping the output of one preview to the input of the next one
#    smobox=""
#    (( ${5} != 0 )) && {
#    piece box$(radom)[@]
#    eval ${1}="(${box[@]})"
#    colbox="$(color)"
#    eval ${6}=\"${colbox}\"
#    preview box[@] ${3} ${4} colbox
#    } || {
#    eval ${1}="(${!2})"
#    eval ${6}=\"${!7}\"
#    preview ${2} ${3} ${4} ${7}
#    }
#    eval ${3}=\"${smobox}\"
# }


drawbox()
{   # draw the current pieces
    (( $# == 1 )) && {
        piece box$(radom)[@]
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

movebox()
{  # detect whether it's possible to move the pieces to a new position
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


coordinate()
{  # locate the coordinates of the pieces on the terminal
   local i sup vor
   vor=(${!1})
   for((i=0; i<${#vor[@]}; i+=2))
   do
       cdn+="\e[${vor[i]};${vor[i+1]}H${mrx}"
       sup+="${vor[i]} ${vor[i+1]} "
   done
   ${2}
}

ptbox()
{  # draw the current pieces
   oldbox="${cdn}"
   echo -e "\e[${colbox}${cdn}\e[0m"
}

regxy()
{  # invoke the ptbox function and get the coordinates
   ptbox
   locus="${sup}"
}

## game loop

persig()
{  # deal with the detected signals
#set -x  
    local sigSwap pid
    pid=${1}

#   showbox 0 # preview bar

    drawbox 0 # draw

#   for i in sigRotate sigTransf sigLeft sigRight sigDown sigAllDown ; do
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
#            ${sigAllDown})
#            transform $(value $(bottom)) 0  ;;
            esac
        done
#       transform 1  0 # falling down
    done
}


## move piece

transform()
{  # function invocation
   local dx dy cdn smu
   dx=${1}
   dy=${2}
   (( $# == 2 )) && parallelbox # || rotate
}

parallelbox()
{   # move straight within bounderies
    # move the pieces or generate new one when the bottom is the current position
    if movebox locus; then
        hdbox
        (( smu == 2 )) && across
        increment

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

across()
{  # move the 1x1 block in a special manner
   local i j m one
   one=(${locus})
   ((i=one[0]))
   ((j=one[1]))
   ((m=(i-modh-1)*width+j/2-modh))
   (( map[m] == 1 )) && echo -e "\e[${i};${j}H\e[${pam[m]}${mrx}\e[0m"
}

increment()
{  # add the increment of the coordinates according to the direction that pieces will move to
   local v
   for((v=0; v<${#box[@]}; v+=2))
   do
      ((box[v]+=dx))
      ((box[v+1]+=dy))
   done
   nbox=(${box[@]})
   coordinate box[@] regxy
   box=(${nbox[@]})
}

# ## rotate stuff

# rotate()
# {  # rotate or transpose the pieces
#     local m n p q mp nq tbox mbox vbox kbox
#     centralpoint box[@] mp nq
#     procedure box[@]  equation vbox "/" m n
#     algorithm
#     mbox=(${mbox})
#     procedure mbox[@] equation tbox "*" p q
#     component
#     coordinate tbox[@] serxy
#     dx=0
#     if movebox kbox; then
#         hdbox
#         locus="${kbox}"
#         ptbox
#         box=(${kbox})
#     fi
# }

# centralpoint()
# {  # get the central coordinates of the pieces
#    BOX=(${!1})
#    if (( ${#BOX[@]}%4 == 0 )); then
#         ((${2}=BOX[${#BOX[@]}/2]))
#         ((${3}=BOX[${#BOX[@]}/2+1]))
#    else
#         ((${3}=BOX[${#BOX[@]}/2]))
#         ((${2}=BOX[${#BOX[@]}/2-1]))
#    fi
# }

# procedure()
# {  # function invocation
#    multiple ${1} ${2} ${3} "${4}"
#    eval ${3}="(${!3})"
#    centralpoint ${3}[@] ${5} ${6}
# }

# multiple()
# {  # transformation between double and a half of the coordinates
#     local x y cy ccx ccy cdx cdy vor
#     vor=(${!1})
#     for((i=0; i<${#vor[@]}; i+=2)) ; do
#         ((x=vor[i]))
#         ((y=vor[i+1]))
#         ((ccx=x))
#         ((ccy=y))
#         ${2} ${3} "${4}"
#         ((cy=y))
#         ((cdx=ccx))
#         ((cdy=ccy))
#     done
# }

# algorithm()
# {  # the most core algorithm used for pieces rotation and matrix transposition
#    local row col
#    for((i=0; i<${#vbox[@]}; i+=2))
#    do
#           ((row=m+vbox[i+1]-n))  # row=(x-m)*zoomx*cos(a)-(y-n)*zoomy*sin(a)+m
#        if (( dx != 1 )); then    # col=(x-m)*zoomx*sin(a)+(y-n)*zoomy*cos(a)+n
#           ((col=m-vbox[i]+n))    # a=-pi/2 zoomx=+1 zoomy=+1 dx=0 dy=0
#        else                      # a=-pi/2 zoomx=-1 zoomy=+1 dx=0 dy=0
#           ((col=vbox[i]-m+n))    # a=+pi/2 zoomx=+1 zoomy=-1 dx=0 dy=0
#        fi
#           mbox+="${row} ${col} "
#    done
# }

# equation()
# {  # core algorithm used for doubling and halving the coordinates
#    [[ ${cdx} ]] && ((y=cy+(ccy-cdy)${2}2))
#    eval ${1}+=\"${x} ${y} \"
# }

# component()
# {  # add the difference of two central coordinates
#    local i
#    for((i=0; i<${#tbox[@]}; i+=2))
#    do
#        ((tbox[i]+=mp-p))
#        ((tbox[i+1]+=nq-q))
#    done
# }


        

movebox()
{  # detect whether it's possible to move the pieces to a new position
   local x y i j xoy vor boolx booly
   vor=(${!1})
   smu=${#vor[@]}
   for((i=0; i<${#vor[@]}; i+=2))
   do
        ((x=vor[i]+dx))
        ((y=vor[i+1]+dy))
        ((xoy=(x-modh-1)*width+y/2-modh))
        (( xoy < 0 )) && return 1
        boolx="x <= modh || x > height+modh"
        booly="y > 2*width+modw || y <= modw"
        (( boolx || booly )) && return 1
        if (( map[xoy] == 1 )); then
           if (( smu == 2 )); then
              for((j=height+modh; j>x; --j))
              do
                   (( map[(j-modh-1)*width+y/2-modh] == 0 )) && return 0
              done
           fi
           return 1
        fi
   done
   return 0
}


                                                                                
## START
[[ "x${1}" == "xRun" ]] && {
    echo "restarted xRun"  

    loop initialization # init each field, per line
    boundary # paint game panel
    persig $! # game loop

} || {
    echo "Run"  
    ## restart game
    bash $0 Run ${1} &

    ## continue with navigation
    getsig $!
}
