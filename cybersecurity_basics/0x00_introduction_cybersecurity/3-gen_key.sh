#!/bin/bash

# Check if a key name is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <key_name>"
    exit 1
fi

# Get the key name from the first argument
KEY_NAME="$1"

# Generate RSA SSH key pair with 4096-bit key size
ssh-keygen -t rsa -b 4096 -f "$KEY_NAME"