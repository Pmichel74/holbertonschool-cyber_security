# Task 3 - 3D Secure IDOR Exploitation

## 🎯 Objectif Final
Exploiter une vulnérabilité IDOR dans le processus de vérification 3D Secure pour :
- Utiliser la carte bancaire d'une victime
- Rediriger la vérification OTP vers notre compte
- Valider le paiement avec NOTRE OTP
- Obtenir flag_3

## 📋 Phase 1 : Reconnaissance du flux normal

### Étape 1.1 : Test avec votre propre compte

**Dans Kali, avec Burp Suite actif** :

1. Aller sur http://web0x06.hbtn/upgrade
2. **Observer la page** :
   - Quels champs sont présents ?
   - Quelles informations sont demandées ?
   - Y a-t-il un montant prédéfini ?

3. **Récupérer VOS informations de carte** :
```bash
# Dans Kali
curl -s -H "Cookie: session=YOUR_SESSION" \
     http://web0x06.hbtn/api/customer/info/me | jq .

# Noter :
# - Vos card_id(s)
# - Votre account_id
# - Votre customer_id
```

4. **Effectuer un paiement test avec VOTRE carte** :
   - Remplir le formulaire avec VOS informations
   - Observer la redirection vers `/cards/3dsecure/`
   - **IMPORTANT** : Ne pas soumettre l'OTP tout de suite !

### Étape 1.2 : Analyse de la page 3D Secure

**Quand vous êtes sur `/cards/3dsecure/` :**

1. **Observer l'URL** :
```
http://web0x06.hbtn/cards/3dsecure/?param1=value1&param2=value2...
```
Noter TOUS les paramètres dans l'URL :
- Transaction ID ?
- Card ID ?
- Account ID ?
- Customer ID ?
- Session ID ?
- Amount ?

2. **Observer le formulaire OTP** :
   - Champ input pour l'OTP
   - Bouton submit
   - Champs cachés (hidden fields) ?

3. **Dans Burp, avant de soumettre** :
   - Intercept ON
   - Entrer l'OTP reçu
   - Cliquer Submit
   - **CAPTURER la requête dans Burp**

### Étape 1.3 : Analyse de la requête OTP

**Dans Burp Proxy → Intercept :**

```http
POST /confirmation HTTP/1.1
Host: web0x06.hbtn
Cookie: session=YOUR_SESSION
Content-Type: application/x-www-form-urlencoded

otp=123456&card_id=XXXX&account_id=YYYY&transaction_id=ZZZZ&...
```

**NOTER TOUS LES PARAMÈTRES** :
- otp : L'OTP saisi
- card_id : ?
- account_id : ?
- customer_id : ?
- transaction_id : ?
- amount : ?
- Autres paramètres ?

**Question clé** : Quel paramètre détermine QUI est débité ?

## 📋 Phase 2 : Récupération des informations de la victime

### Étape 2.1 : Choisir une victime

```bash
# Liste des contacts
curl -s -H "Cookie: session=YOUR_SESSION" \
     http://web0x06.hbtn/api/customer/contacts | jq .

# Choisir une victime, exemple : Linda Robinson
VICTIM_CUSTOMER_ID="..."
```

### Étape 2.2 : Récupérer les infos de carte de la victime

**Méthode 1 - Via customer info (si IDOR existe)** :
```bash
curl -s -H "Cookie: session=YOUR_SESSION" \
     http://web0x06.hbtn/api/customer/info/$VICTIM_CUSTOMER_ID | jq .
```

**Méthode 2 - Via account info** :
```bash
# Pour chaque account_id de la victime
curl -s -H "Cookie: session=YOUR_SESSION" \
     http://web0x06.hbtn/api/accounts/info/$VICTIM_ACCOUNT_ID | jq .

# Chercher le champ "cards_id"
```

**Informations à récupérer sur la victime** :
- customer_id
- account_id (compte à débiter)
- card_id (carte à utiliser)
- Routing & Number (si nécessaire)

## 📋 Phase 3 : Exploitation

### Stratégie d'attaque

**Scénario 1 : Manipulation de la requête de paiement initiale**

1. Aller sur /upgrade
2. Burp Intercept ON
3. Remplir le formulaire avec les informations de la VICTIME :
   - Card ID de la victime
   - Account ID de la victime
4. Soumettre
5. **INTERCEPTER et MODIFIER** :
   - Garder card_id de la victime (pour débiter sa carte)
   - Remplacer customer_id par le VÔTRE (pour recevoir l'OTP)

**Scénario 2 : Manipulation de la requête OTP**

1. Faire un paiement avec les infos de la VICTIME
2. Observer la redirection 3D Secure
3. **ANALYSER l'URL de la page 3dsecure** :
   - Si elle contient des IDs, les noter
4. **FORCER une nouvelle demande d'OTP pour VOUS** :
```bash
# Faire un nouveau paiement avec VOS infos
# Récupérer VOTRE OTP
```
5. **INTERCEPTER la soumission OTP** :
   - Soumettre VOTRE OTP
   - Dans Burp, MODIFIER les paramètres :
     - Garder VOTRE OTP
     - Remplacer card_id par celui de la VICTIME
     - Remplacer account_id par celui de la VICTIME
     - Garder transaction_id de la victime (si présent)

**Scénario 3 : Double session**

1. Session 1 (Burp) : Paiement avec carte de la VICTIME
   - Ne pas aller jusqu'au bout
   - Noter le transaction_id
2. Session 2 (navigateur normal) : Paiement avec VOTRE carte
   - Récupérer VOTRE OTP
3. Session 1 (Burp) : Soumettre VOTRE OTP sur la transaction de la VICTIME

## 📋 Phase 4 : Points d'attention

### Paramètres critiques à identifier

```
┌─────────────────────────────────────────┐
│  Requête POST /confirmation             │
├─────────────────────────────────────────┤
│  otp          → VOTRE OTP               │
│  card_id      → VICTIME (débité)        │
│  account_id   → VICTIME (débité)        │
│  customer_id  → VOUS (reçoit OTP)       │
│  session      → VOTRE session           │
└─────────────────────────────────────────┘
```

### Questions à résoudre

1. **Qui reçoit l'OTP ?** Déterminé par quoi ?
   - customer_id ?
   - card_id ?
   - session cookie ?
   - account_id ?

2. **Qui est débité ?** Déterminé par quoi ?
   - card_id dans la requête ?
   - account_id dans la requête ?
   - transaction_id référençant un paiement initial ?

3. **Comment lier les deux ?**
   - Peut-on avoir OTP pour nous MAIS débiter la victime ?

## 🔧 Outils nécessaires

### Configuration Burp

1. **Proxy → Intercept** : ON
2. **Match and Replace** (optionnel) :
   - Remplacer automatiquement certains paramètres

3. **Repeater** :
   - Envoyer la requête OTP au Repeater
   - Tester différentes combinaisons de paramètres

### Scripts utiles

```bash
# Récupérer toutes les cartes disponibles
#!/bin/bash
SESSION="YOUR_SESSION"

for contact in $(curl -s -H "Cookie: session=$SESSION" \
    http://web0x06.hbtn/api/customer/contacts | jq -r '.[].customer_id'); do
    
    echo "=== Customer: $contact ==="
    curl -s -H "Cookie: session=$SESSION" \
         "http://web0x06.hbtn/api/customer/info/$contact" | jq .
done
```

## 📝 Documentation à faire

Pour chaque test, noter :

```markdown
### Test #1
- Victime : Linda Robinson (customer_id: xxx)
- Carte victime : card_id: yyy
- Account victime : account_id: zzz
- Modification effectuée : [décrire]
- Résultat : [Succès/Échec]
- Erreur : [si échec]
```

## 🎯 Checklist de progression

- [ ] Paiement normal avec VOTRE carte effectué et compris
- [ ] Requête OTP capturée et analysée
- [ ] Tous les paramètres identifiés
- [ ] Informations de carte d'une victime récupérées
- [ ] Test 1 : Modification simple (remplacer 1 paramètre)
- [ ] Test 2 : Modification avancée (combiner paramètres)
- [ ] Flag_3 obtenu !

## 💡 Hypothèses à tester

1. **H1** : Le système valide l'OTP basé sur customer_id dans la requête
   - Test : Payer avec carte victime, modifier customer_id dans requête OTP

2. **H2** : Le système valide l'OTP basé sur le cookie de session
   - Test : Impossible à exploiter (session liée au compte)

3. **H3** : Le système débite basé sur card_id dans requête OTP
   - Test : Soumettre VOTRE OTP avec card_id de la victime

4. **H4** : Le système débite basé sur transaction_id
   - Test : Créer transaction avec carte victime, soumettre avec votre OTP

## 🚀 Prochaines étapes

1. **MAINTENANT** : Faire un paiement test avec VOTRE carte
2. Capturer la requête OTP dans Burp
3. M'envoyer la requête complète
4. On analysera ensemble les paramètres
5. On construira l'exploit

---

**Prêt à commencer ?** 
Lance Burp, va sur /upgrade et fais un test avec ta propre carte !
Copie-moi la requête POST /confirmation capturée ! 🔍
