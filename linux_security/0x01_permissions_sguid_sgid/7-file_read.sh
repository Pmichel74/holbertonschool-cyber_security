#!/bin/bash
find $1 -type f -exec -perm -2000 \; 2>/dev/null
