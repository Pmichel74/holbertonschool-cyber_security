tail -n 1000 auth.log | awk '
/Failed password for/ { fails[$9]++ }
/Accepted password for/ { if (fails[$12] >= 3 && !reported[$9]) { print $12; reported[$12]=1 } }
'
