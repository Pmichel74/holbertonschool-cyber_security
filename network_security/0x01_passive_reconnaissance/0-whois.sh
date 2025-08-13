#!/bin/bash
whois $1 2>/dev/null | awk -F': ' '/^(Registrant|Admin|Tech) /{gsub(/ /,"$",$1); print $1"," $2}' > $1.csv