#!/bin/bash
find $1 -perm -2000 -o -4000 -mtime -1 -type f exec -ls -l {} \; 2> /dev/null