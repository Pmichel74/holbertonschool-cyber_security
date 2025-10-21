#!/bin/bash
groupadd $1
chown :$1 $2
chmod 2750
