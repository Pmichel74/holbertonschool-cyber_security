#!/bin/bash
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT; iptables -A INPUT -p tcp --dport 22 -j ACCEPT