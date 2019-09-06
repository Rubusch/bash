#!/bin/bash -e
##
## demonstrates the redirection of streams into files
##
## makes an index of important config files,
## puts them together in a backup file and allows for adding comment for each file
##

CONFIG=./sysconfig.txt
touch $CONFIG

## reset
rm "$CONFIG" 2>/dev/null

echo "output will be saved in $CONFIG"

## set input stream 7 (fd) 
exec 7<&0

## opens the /etc/passwd
exec < /etc/passwd

## read the first line of /etc/passwd
read rootpasswd

echo "saving root account info.."
echo "your root account info: " >> "$CONFIG"
echo $rootpasswd >> "$CONFIG"

## close stream again
exec 0<&7 7<&-

## get some comment
echo -n "enter comment or ENTER for no comment [ENTER]: "
read comment

## write it into the file
echo $comment >> "$CONFIG"
echo "saving hosts information.."

## first prepare a host file not containing any comments
TEMP="/var/tmp/hosts.tmp"
cat /etc/hosts | grep -v "^#" > "$TEMP"

## open file again with fd 7
exec 7<&0

## connect it to $TEMP-file
exec < "$TEMP"

## read in ip, name and alias from the file
read ip1 name1 alias1
read ip2 name2 alias2

## print configuration to the resulting target file
echo "your local host configuration: " >> "$CONFIG"
echo "$ip1 $name1 $alias1" >> "$CONFIG"
echo "$ip2 $name2 $alias2" >> "$CONFIG"

## close file stream (fd = 7)
exec 0<&7 7<&-

## read comment
echo -n "enter comment or ENTER for no comment [ENTER]: "
read comment

## save the comment to the target file
echo $comment >> "$CONFIG"
rm "$TEMP"

echo "READY."
