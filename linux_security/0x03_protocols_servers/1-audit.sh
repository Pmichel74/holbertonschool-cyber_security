#!/bin/bash
grep -v "^$" | grep -v "^[[:space:]]*#" /etc/ssh/sshd_config
