#!/bin/bash
# Script that lists all the rules in the security table of the firewall
# Uses verbose mode

sudo iptables -t security -L -v
