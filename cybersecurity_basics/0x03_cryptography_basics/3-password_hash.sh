#!/bin/bash
echo -n "$1" | openssl sha512 | awk '{print $1}' > 3-password_hash.txt
