#!/bin/bash

# Récupère le premier argument passé au script
input_data="$1"

# Supprime le préfixe {xor} de la chaîne
input_data="${input_data#'{xor}'}"

# Decode la chaîne encodée en Base64
decoded_data=$(echo -n "$input_data" | openssl enc -base64 -d)

# Initialise la variable pour stocker le résultat de l'opération XOR
output=""

# Parcourt chaque caractère de la chaîne
for ((i = 0; i < ${#decoded_data}; i++)); do
    # Récupère le caractère à la position actuelle
    char="${decoded_data:$i:1}"
    # Convertit le caractère en son code ASCII et effectue l'opération XOR avec 95
    xor_result=$(( $(printf "%d" "'$char") ^ 95 ))
    # Convertit le résultat XOR en caractère et l'ajoute à la sortie
    output+=$(printf "\x$(printf '%02x' $xor_result)")
done

# Affiche le résultat
echo "$output"