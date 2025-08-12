#!/bin/bash
# Script that captures and analyzes network packets going through the system
# -c 5: captures only 5 packets
# -i any: captures on all interfaces

sudo tcpdump -c 5 -i any
