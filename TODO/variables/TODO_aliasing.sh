#!/bin/bash

## aliasing - TODO

echo "1. we set up an alias: dh = 'df -h'"
echo $(alias dh='df -h')
echo
echo "2. we'll test the alias:"
echo "$(dh)"
echo
echo "3. no we'll unalias again"
echo "$(unalias dh)"
echo
echo "4. we'll test the alias:"
echo "$(dh)"
echo
echo "READY."