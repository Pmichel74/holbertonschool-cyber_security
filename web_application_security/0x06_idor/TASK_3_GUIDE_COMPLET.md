# TASK 3 - EXPLOIT 3D SECURE IDOR - GUIDE COMPLET

## 🎯 OBJECTIF
Payer avec la carte d'une VICTIME mais valider avec VOTRE OTP

## 📋 PRÉREQUIS

### Vos informations (Yosri Musk)
- Card ID: `38b9f13486714899a12c03cfd63f5ffe`
- Numéro: `5000619000068283`
- CVV: `192`
- Expiration: `10/2027`

### Informations victime
Exécutez pour obtenir :
```bash
curl -s "http://web0x06.hbtn/api/contacts/list" -H "Cookie: session=3DARRjHZfDrTNJfoW5sF7pZStPjkPJhj8ZYYNlV6CHk.dbxiiWaqsUj96o9YBQuhd5syHbo"
```

## 🚀 EXPLOITATION ÉTAPE PAR ÉTAPE

### PHASE 1 : Obtenir VOTRE OTP

1. **Ouvrir le navigateur (sans Burp)** ou un onglet privé
2. Aller sur `http://web0x06.hbtn/upgrade`
3. Remplir avec **VOS** informations :
   - Numéro: `5000619000068283`
   - CVV: `192`
   - Expiration: `10/2027`
4. Soumettre
5. Sur la page `/cards/3dsecure/`, **NOTER VOTRE OTP affiché**
6. **NE PAS VALIDER** - laissez cette page ouverte

### PHASE 2 : Initier le paiement avec carte VICTIME

1. **Ouvrir Burp Suite** et activer l'interception
2. **Nouveau navigateur/onglet avec proxy Burp**
3. Aller sur `http://web0x06.hbtn/upgrade`
4. Remplir avec les informations **VICTIME** (à obtenir via API)
5. Soumettre → Burp intercepte le POST
6. **Forward** la requête
7. Vous êtes redirigé vers `/cards/3dsecure/?transaction_id=XXX`
8. **NOTER L'OTP DE LA VICTIME** affiché sur la page

### PHASE 3 : L'EXPLOIT - Manipulation de l'OTP

1. Sur la page 3D Secure de la VICTIME, entrer **VOTRE OTP** (pas celui de la victime)
2. Cliquer sur Valider
3. **Burp intercepte la requête POST vers `/cards/3dsecure/`**
4. La requête ressemble à :
```
POST /cards/3dsecure/ HTTP/1.1
Host: web0x06.hbtn
...
card_id=VICTIM_CARD_ID&otp=YOUR_OTP&transaction_id=XXX
```

5. **MODIFIER `card_id`** :
   - Remplacer `card_id=VICTIM_CARD_ID` 
   - Par `card_id=38b9f13486714899a12c03cfd63f5ffe` (VOTRE card_id)

6. **Forward** la requête modifiée

7. Vous êtes redirigé vers `/confirmation` avec le **FLAG_3** ! 🎉

## 🔍 EXPLICATION DE L'EXPLOIT

**Vulnérabilité IDOR** : Le système vérifie :
- ✅ Que l'OTP est correct pour UN card_id
- ❌ Mais ne vérifie PAS que le card_id correspond à celui qui a initié la transaction

**Résultat** :
- La transaction est débitée du compte VICTIME
- Mais la validation OTP est faite avec VOTRE carte
- Le système accepte car l'OTP est techniquement valide

## 🎯 POINTS CLÉS

1. **L'OTP n'est visible QUE sur la page web**, pas dans l'API (masqué par `*****`)
2. **Vous DEVEZ utiliser Burp Suite** pour intercepter et modifier la requête
3. **Le paramètre clé est `card_id`** dans la soumission OTP
4. **Timing** : Gardez les deux sessions ouvertes en parallèle

## 🏁 RÉSULTAT ATTENDU

Page `/confirmation` affichant :
```
Payment successful!
flag_3: XXXXXXXXXXXXXXXXX
```

Sauvegarder le flag dans `3-flag.txt`
