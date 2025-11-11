# IDOR Challenge - Task 0 - Documentation

## 🎯 Objectif
Découvrir les User IDs dans l'application CyberBank en explorant les fonctionnalités et en identifiant les vulnérabilités IDOR.

---

## 🔍 Méthodologie Utilisée

### 1. **Reconnaissance Initiale**
- **URL cible :** `http://web0x06.hbtn/dashboard`
- **Outils :** Browser DevTools (F12), Network Tab avec "Persist log" activé
- **Connexion :** Login avec les credentials fournis

### 2. **Découverte des Endpoints**

#### Endpoint 1 : Informations de l'utilisateur connecté
```
GET http://web0x06.hbtn/api/customer/info/me
```

**Réponse JSON :**
```json
{
  "status": "success",
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
  "expenses": 17557.6,
  "created_at": 1762778531,
  "updated_at": 1762778531
}
```

**Analyse :**
- Format d'ID : UUID (32 caractères hexadécimaux)
- ID utilisateur : `8cb0fac7d4174ab9b983777098e6b61a`
- IDs de comptes associés découverts
- Données sensibles exposées (balance, revenus, dépenses)

#### Endpoint 2 : Liste des contacts/utilisateurs
```
GET http://web0x06.hbtn/api/customer/contacts
```

**Découverte critique :**
- Cet endpoint expose la liste de tous les utilisateurs de l'application
- Chaque entrée contient l'ID unique (UUID) des autres utilisateurs
- Permet l'énumération complète des user IDs du système

---

## 🔓 Exploitation IDOR

### Vulnérabilité Identifiée

**Endpoint vulnérable :**
```
GET http://web0x06.hbtn/api/customer/info/{user_id}
```

**Description :**
L'endpoint permet de remplacer le paramètre dynamique `{user_id}` (ou la valeur `me`) par n'importe quel UUID d'utilisateur obtenu depuis `/api/customer/contacts`.

**Exploitation :**
```bash
# Mon profil (légitime)
GET /api/customer/info/me
GET /api/customer/info/8cb0fac7d4174ab9b983777098e6b61a

# Accès non autorisé aux données d'autres utilisateurs
GET /api/customer/info/[AUTRE_USER_ID]
```

**Impact :**
- ✅ Accès aux informations personnelles (nom, prénom, username)
- ✅ Accès aux données financières (balance, revenus, dépenses)
- ✅ Accès aux IDs de comptes bancaires
- ✅ Énumération complète de tous les utilisateurs

---

## 🚩 Flag Découvert

### Processus de découverte
1. Obtention de la liste des user IDs via `/api/customer/contacts`
2. Exploitation IDOR sur `/api/customer/info/{user_id}` avec un ID différent
3. Le flag se trouve dans la réponse JSON d'un des utilisateurs

### Flag
```
7897296ce2ffd455fdd3694df95b253d
```

**Emplacement :** Le flag était probablement dans un champ JSON (ex: `"flag"`, `"secret"`, ou caché dans les données) lors de l'accès non autorisé aux informations d'un autre utilisateur.

---

## 📋 Structure des User IDs

**Format :** UUID v4 (32 caractères hexadécimaux sans tirets)
```
Exemple : 8cb0fac7d4174ab9b983777098e6b61a
```

**Caractéristiques :**
- Non séquentiels (impossibles à deviner par incrémentation)
- Nécessite une énumération via une fuite d'information (endpoint `/contacts`)
- Format standard : `[a-f0-9]{32}`

---

## 🛡️ Recommandations de Sécurité

### Vulnérabilités identifiées :
1. **IDOR (Insecure Direct Object Reference)**
   - Absence de contrôle d'autorisation sur l'endpoint `/api/customer/info/{user_id}`
   - Un utilisateur peut accéder aux données d'un autre utilisateur

2. **Information Disclosure**
   - L'endpoint `/api/customer/contacts` expose tous les user IDs
   - Facilite l'énumération des utilisateurs

### Corrections recommandées :
```python
# ❌ Code vulnérable
@app.route('/api/customer/info/<user_id>')
def get_user_info(user_id):
    return database.get_user(user_id)

# ✅ Code sécurisé
@app.route('/api/customer/info/<user_id>')
@login_required
def get_user_info(user_id):
    current_user_id = session.get('user_id')
    
    # Vérification d'autorisation
    if user_id != current_user_id and user_id != 'me':
        return {'error': 'Unauthorized'}, 403
    
    if user_id == 'me':
        user_id = current_user_id
    
    return database.get_user(user_id)
```

**Mesures de protection :**
- Implémenter un contrôle d'accès basé sur les rôles (RBAC)
- Vérifier que l'utilisateur connecté a le droit d'accéder à la ressource demandée
- Limiter l'exposition des IDs utilisateurs dans les endpoints publics
- Logger les tentatives d'accès non autorisé
- Utiliser des références indirectes (mapping internal ID → public reference)

---

## 🔧 Outils Utilisés

- **Browser DevTools (F12)**
  - Network Tab (avec Persist log activé)
  - Analyse des requêtes XHR/Fetch
  - Inspection des réponses JSON

- **Burp Suite** (optionnel)
  - Proxy HTTP pour interception
  - Repeater pour tests manuels
  - Intruder pour énumération automatique

---

## 📝 Timeline de l'Exploitation

1. ✅ Login sur `http://web0x06.hbtn/dashboard`
2. ✅ Découverte de `/api/customer/info/me` → Mon user ID
3. ✅ Découverte de `/api/customer/contacts` → Liste de tous les users
4. ✅ Test IDOR sur `/api/customer/info/{autre_user_id}`
5. ✅ Accès réussi aux données d'un autre utilisateur
6. ✅ Récupération du flag dans la réponse JSON

---

## 🎓 Leçons Apprises

### Principes IDOR :
- Les vulnérabilités IDOR exploitent l'absence de contrôle d'autorisation
- La structure des IDs (séquentiels vs UUID) n'empêche pas l'IDOR
- L'énumération est facilitée par les fuites d'information

### Techniques de découverte :
- Explorer toutes les fonctionnalités de l'application
- Analyser systématiquement toutes les requêtes API
- Chercher les endpoints exposant des listes ou des références
- Tester la manipulation des paramètres d'ID

---

**Challenge complété avec succès ! 🎉**

Flag: `7897296ce2ffd455fdd3694df95b253d`
