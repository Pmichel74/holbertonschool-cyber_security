#!/bin/bash
sudo nmap -sF -f -p80-85 -T2 $1
