#!/bin/bash
grep -v "^$|^[[:space:]]*#" /etc/ssh/sshd_config
