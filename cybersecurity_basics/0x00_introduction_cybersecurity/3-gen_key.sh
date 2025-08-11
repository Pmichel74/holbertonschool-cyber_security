#!/bin/bash
# SSH key generator script
# Usage: ./3-gen_key.sh <key_filename>
# Generates a 4096-bit RSA SSH key pair without passphrase
ssh-keygen -t rsa -b 4096 -f "$1" -N ""
