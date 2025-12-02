#!/bin/bash
grep -E "new user" auth.log | awk '{print $8}' | sed 's/name=//' | ses 's/,$//' | sort | uniqu | paste -sd ","