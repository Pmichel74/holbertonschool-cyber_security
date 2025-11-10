#!/bin/bash
sudo nmap -sM -p http, https, ftp, ssh -vv $1
