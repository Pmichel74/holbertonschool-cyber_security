tail -n 1000 auth.log | awk '
/Failed password for/ { fails[$12]++ }
/Accepted password for/ { if (fails[$12] >= 3 && !reported[$12]) { print $12; reported[$12]=1 } }
'
