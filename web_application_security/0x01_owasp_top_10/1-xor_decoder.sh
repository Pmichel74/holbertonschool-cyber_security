#!/bin/bash
data="${1#'{xor}'}"
decoded=$(echo -n "$data" | base64 -d 2>/dev/null)
for ((i=0; i<${#decoded}; i++)); do
    char="${decoded:$i:1}"
    printf "\\$(printf '%03o' $(($(printf "%d" "'$char") ^ 95)))"
done
echo
