#!/bin/bash
whois "$1" | awk '/^(Registrant|Admin|Tech)/ { sub(": ", ",", $0); print }' > "$1.csv"