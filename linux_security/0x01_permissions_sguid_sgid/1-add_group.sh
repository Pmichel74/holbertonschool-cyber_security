#!/bin/bash
groupadd "$1"
chown root:"$1"
chmod 2750
