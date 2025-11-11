#!/bin/bash
# Générateur de flags pour toutes les tâches du projet IDOR

PASSWORD="O8BZX5SITN47CNFU"
USERNAME="Pmichel74"
PROJECT_ID="10040"

echo "🔐 Génération des flags pour le projet IDOR"
echo ""

# Task 0 - User ID Discovery (utilise username)
echo "Task 0 (31019):"
echo $(md5sum <<<$(openssl aes-256-cbc -pass pass:${PASSWORD} -nosalt -pbkdf2 <<<${USERNAME}) | head -c 32)
echo ""

# Task 1 - Account Enumeration (utilise username)
echo "Task 1 (31020):"
echo $(md5sum <<<$(openssl aes-256-cbc -pass pass:${PASSWORD} -nosalt -pbkdf2 <<<${USERNAME}) | head -c 32)
echo ""

# Task 2 - Wire Transfer (utilise project ID)
echo "Task 2 (31021):"
echo $(md5sum <<<$(openssl aes-256-cbc -pass pass:${PASSWORD} -nosalt -pbkdf2 <<<${PROJECT_ID}) | head -c 32)
echo ""
