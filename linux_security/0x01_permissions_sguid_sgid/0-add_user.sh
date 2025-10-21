#!/bin/bash
adduser $1
echo "$1:$2" | chpasswd
