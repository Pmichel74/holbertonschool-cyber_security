#!/bin/bash
echo -n "$1" | openssl rand -hex 16 | openssl sha512 | awk '{print $1}' > 3_hash.txt
