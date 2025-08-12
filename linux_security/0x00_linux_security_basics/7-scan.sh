#!/bin/bash
# Script that scans a subnetwork to discover live hosts using nmap
# Accepts a subnetwork as argument $1

sudo nmap $1
