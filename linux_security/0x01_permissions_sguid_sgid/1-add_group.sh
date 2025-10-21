#!/bin/bash
groupadd $1
chown root:$1 $2
chmod 2750
