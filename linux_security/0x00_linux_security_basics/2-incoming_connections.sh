#!/bin/bash
sudo ufw --force reset >/dev/null 2>&1; sudo ufw default deny incoming >/dev/null 2>&1; sudo ufw default allow outgoing >/dev/null 2>&1; sudo ufw allow 80/tcp; sudo ufw --force enable >/dev/null 2>&1
