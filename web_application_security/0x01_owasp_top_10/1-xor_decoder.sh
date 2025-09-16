#!/bin/bash
echo ${1#*\}} | base64 -d 2>/dev/null | od -An -t u1 | awk '{for(i=1;i<=NF;i++)printf "%c", xor($i,95)}'
