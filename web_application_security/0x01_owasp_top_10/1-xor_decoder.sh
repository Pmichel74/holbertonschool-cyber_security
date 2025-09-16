#!/bin/bash

# Récupère le premier argument passé au script
password="$1"

# Supprime le préfixe {xor} de la chaîne
password="${password#'{xor}'}"

# Decode la chaîne encodée en Base64
decoded_password=$(echo -n "$password" | openssl enc -base64 -d)

# Initialise la variable pour stocker le résultat de l'opération XOR
output=""

# Parcourt chaque caractère de la chaîne
for ((i = 0; i < ${#decoded_password}; i++)); do
    # Récupère le caractère à la position actuelle
    char="${decoded_password:$i:1}"
    # Convertit le caractère en son code ASCII et effectue l'opération XOR avec 95
    xor_result=$(( $(printf "%d" "'$char") ^ 95 ))
    # Ajoute le résultat à la variable de sortie
    output+=$(printf "\\$(printf '%03o' $xor_result)")
done

# Affiche le résultat
echo "$output"
