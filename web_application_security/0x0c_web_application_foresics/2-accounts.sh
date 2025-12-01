tail -n 1000 auth.log | awk '
/Failed password for/ { fails[$9]++ }
/Accepted password for/ { if (fails[$9] >= 3 && !reported[$9]) { print $9; reported[$9]=1 } }
'
