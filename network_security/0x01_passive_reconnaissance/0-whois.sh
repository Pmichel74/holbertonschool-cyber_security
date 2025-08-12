#!/bin/bash
whois $1 2>/dev/null | awk -F': ' '/^(Registrant|Admin|Tech) /{print $1"," $2}' > $1.csv