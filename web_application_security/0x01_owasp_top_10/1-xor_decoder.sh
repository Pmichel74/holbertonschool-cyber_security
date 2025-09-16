#!/bin/b# Decode the Base64 encoded string
decoded_data=$(echo -n "$input_data" | openssl enc -base64 -d)

# Initialize the variable to store the XOR operation result
output=""

# Loop through each character of the string
for ((i = 0; i < ${#decoded_data}; i++)); do
    # Get the character at the current position
    char="${decoded_data:$i:1}"
    # Convert the character to its ASCII code and perform XOR operation with 95
    xor_result=$(( $(printf "%d" "'$char") ^ 95 ))
    # Convert the XOR result to character and add it to the output
    output+=$(printf "\x$(printf '%02x' $xor_result)")
done

# Display the result
echo "$output"st argument passed to the script
input_data="$1"

# Remove the {xor} prefix from the string
input_data="${input_data#'{xor}'}"

# Decode the Base64 encoded string
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
