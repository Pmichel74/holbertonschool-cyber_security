#!/bin/bash
# Script to allow incoming network connections with the TCP protocol through port 80

sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw allow 80/tcp
sudo ufw --force enable
