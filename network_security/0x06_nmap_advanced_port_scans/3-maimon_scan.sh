#!/bin/bash
sudo nmap -sM -p21,22,23,80,443 -vv $1
