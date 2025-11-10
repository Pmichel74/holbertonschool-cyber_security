#!/bin/bash
sudo nmap -scanflags all -p $2 -oN custom_scan.txt $1 &> /dev/null
