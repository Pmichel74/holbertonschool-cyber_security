#!/bin/bash
grep -E "com2sec.*public|rocommunity.*public" /etc/snmp/snmpd.conf
iptables -A INPUT -j DROP