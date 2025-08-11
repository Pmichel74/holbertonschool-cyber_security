#!/bin/bash
# Script that lists services, their current state, and their corresponding ports
# Shows PID and program names for listening TCP and UDP sockets
# Uses numerical addresses and requires privileged access

sudo netstat -lntup