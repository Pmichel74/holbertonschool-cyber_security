#!/bin/bash
# Script to allow incoming TCP connections through port 80

sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw allow 80/tcp
sudo ufw --force enable
