#!/bin/bash
ip_hacker=$(awk '{print $1}' logs.txt | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
grep "$ip_hacker" logs.txt | awk -F'"' '{print $NF}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}'