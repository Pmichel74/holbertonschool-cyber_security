#!/bin/bash

# Script to display active network connections
# Shows listening ports and established connections with process information

#  ss command to show socket statistics
# -t: TCP sockets
# -n: numerical addresses
# -p: process using the socket

ss -tanp
