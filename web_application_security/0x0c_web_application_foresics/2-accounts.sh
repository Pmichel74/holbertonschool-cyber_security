#!/bin/bash
tail -n 1000 auth.log | awk '
/Failed password for/ { fails[$9]++ }
/Accepted password for/ { if (fails[$9] >= 1) { print $9; exit } }
'

