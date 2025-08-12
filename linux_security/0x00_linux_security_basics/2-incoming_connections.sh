#!/bin/bash
# Script to allow incoming TCP connections through port 80

# Reset firewall rules and configure to allow only TCP port 80
sudo ufw --force reset >/dev/null 2>&1
sudo ufw default deny incoming >/dev/null 2>&1
sudo ufw default allow outgoing >/dev/null 2>&1
sudo ufw allow 80/tcp
sudo ufw --force enable >/dev/null 2>&1
