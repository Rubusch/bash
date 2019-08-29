#!/bin/bash
##
## run emacs as daemon to keep workspaces persistent and only connect via
## emacsclient to the permanently running daemon
##
##
## INSTALLATION
##
## # aptitude install emacsclient
##
## edit .bash_aliases
##   alias emacs='~/.emacsstarter.sh'
##
## and move this script to '~/.emacsstarter.sh'
##
## enable bash_aliases in .bashrc
##
##
## HOW IT WORKS
##
## the first run will start the server
## $ emacs --daemon
##
## further calls for "emacs" will start clients on shell
## $ emacsclient -t
##
## to stop the server
## M-x server-shutdown
##
[[ -z `pidof emacs` ]] && emacs --daemon
emacsclient -t $@
