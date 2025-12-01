tail -n 1000 auth.log | awk '
/Failed password for/ {
    user = $(NF-5)
    ip = $(NF-3)
    key = user "@" ip
    fails[key]++
}
/Accepted password for/ {
    user = $(NF-5)
    ip = $(NF-3)
    key = user "@" ip
    if (fails[key] >= 3) {
        print "suspect acitivity : " key " (au moins 3 échecs suivis d\'un succès)"
    }
}
'