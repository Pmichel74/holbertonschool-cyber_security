# 🔐 0x02 - Mandatory Access Control (MAC)

## 🎯 Overview

Bienvenue dans le monde du **Mandatory Access Control (MAC)**! Ce projet explore **SELinux** 🛡️ et **AppArmor** 🎭, deux frameworks de sécurité Linux qui vont bien au-delà des permissions DAC traditionnelles.

**L'idée simple:** Même `root` ne peut pas tout faire! 👑➡️📴

Ce projet contient **8 scripts Bash pratiques** qui démontrent comment gérer les contrôles d'accès obligatoires.

---

## 📁 Structure du Projet

```
0x02_mandatory_access_control/
│
├── 0️⃣  0-analyse_mode.sh          # Vérifier le mode SELinux actuel
├── 1️⃣  1-security_match.sh        # Afficher le statut AppArmor
├── 2️⃣  2-list_http.sh             # Lister les ports HTTP gérés par SELinux
├── 3️⃣  3-add_port.sh              # Ajouter un nouveau port SELinux
├── 4️⃣  4-list_user.sh             # Lister les mappings utilisateurs SELinux
├── 5️⃣  5-add_selinux.sh           # Créer un nouveau mapping login SELinux
├── 6️⃣  6-list_booleans.sh         # Lister tous les booleans SELinux
├── 7️⃣  7-set_sendmail.sh          # Activer le boolean sendmail
└── 📖 README.md                    # Ce fichier
```

---

## 📚 Détail des Tâches

### Task 0️⃣: Fort Knox ou Far West? 🏰⚔️

**Fichier:** `0-analyse_mode.sh`

**Objectif:** Afficher le mode SELinux actuel

**Les 3 modes SELinux:**
- 🔒 **Enforcing** - Mode fort: Les violations sont **bloquées**
- ⚠️ **Permissive** - Mode test: Les violations sont **enregistrées** mais autorisées
- 🚫 **Disabled** - Mode chaos: SELinux est **désactivé**

**Le Script:**
```bash
#!/bin/bash
sestatus
```

**Résultat:**
```
SELinux status:                 disabled
```

✅ **Score:** 4/4 pts | 100%

---

### Task 1️⃣: AppArmor vs SELinux 🎭⚔️

**Fichier:** `1-security_match.sh`

**Objectif:** Afficher le statut des profils de sécurité AppArmor

**Ce que fait ce script:**
- ✓ Vérifie si AppArmor est chargé
- ✓ Compte les profils actifs
- ✓ Montre les processus protégés

**Le Script:**
```bash
#!/bin/bash
aa-status
```

**Exemple de sortie:**
```
apparmor module is loaded. ✓
30 profiles are loaded.
27 profiles are in enforce mode.    🔒
3 profiles are in complain mode.    ⚠️
1 processes are in enforce mode.    👁️
```

**Les modes AppArmor:**
| Mode | Description |
|------|-------------|
| 🔒 **Enforce** | Les violations sont bloquées |
| ⚠️ **Complain** | Les violations sont enregistrées |
| 💀 **Kill** | Les violations terminent le processus |

✅ **Score:** 4/4 pts | 100%

---

### Task 2️⃣: Le Trésor des Ports HTTP 🗝️🔌

**Fichier:** `2-list_http.sh`

**Objectif:** Lister les ports gérés par SELinux (filtrés HTTP)

**Le Script:**
```bash
#!/bin/bash
semanage port -l | grep http
```

**Exemple de sortie:**
```
http_cache_port_t              tcp      3128, 8080, 8118, 10001-10010
http_cache_port_t              udp      3130
http_port_t                    tcp      80, 443, 488, 8008, 8009, 8443, 8448 ✓
pegasus_http_port_t            tcp      5988
pegasus_https_port_t           tcp      5989
```

**Types de ports HTTP:**
- 🌐 `http_port_t` - Ports HTTP/HTTPS standards
- 💾 `http_cache_port_t` - Ports pour proxy de cache
- 🔗 `pegasus_*_port_t` - Ports WBEM

✅ **Score:** 10/10 pts | 100%

---

### Task 3️⃣: Ajouter de la Magie au Port 81 ✨🎩

**Fichier:** `3-add_port.sh`

**Objectif:** Ajouter le port TCP 81 à `http_port_t`

**Pourquoi?** Pour permettre à Apache de tourner sur le port 81 tout en restant protégé par SELinux.

**Le Script:**
```bash
#!/bin/bash
semanage port -a -t http_port_t -p tcp 81
```

**Décodage de la commande:**
```
semanage port    # Gérer les ports SELinux
  -a              # Ajouter (Add)
  -t http_port_t  # Type: HTTP port
  -p tcp          # Protocole: TCP
  81              # Le port à ajouter
```

**Avant ➡️ Après:**
```
Avant:  80, 443, 488, 8008, 8009, 8443, 8448
Après:  81, 80, 443, 488, 8008, 8009, 8443, 8448 ✓
```

**Points clés:**
- 💾 Les changements sont **persistants** (survivent aux redémarrages)
- 🔗 Associe un port à un type SELinux
- 🌍 Essentiel pour les services non-standard

✅ **Score:** 6/6 pts | 100%

---

### Task 4️⃣: Les Gardiens du Cirque de Sécurité 🎪👑

**Fichier:** `4-list_user.sh`

**Objectif:** Lister les mappings d'utilisateurs SELinux

**Le Script:**
```bash
#!/bin/bash
semanage user -l
```

**Exemple de sortie:**
```
SELinux User    Prefix  MLS/MCS Level  MLS/MCS Range              Roles

root            sysadm  s0             s0-s0:c0.c1023            staff_r sysadm_r system_r
staff_u         staff   s0             s0-s0:c0.c1023            staff_r sysadm_r
sysadm_u        sysadm  s0             s0-s0:c0.c1023            sysadm_r
system_u        user    s0             s0-s0:c0.c1023            system_r
unconfined_u    unconfi s0             s0-s0:c0.c1023            system_r unconfined_r
user_u          user    s0             s0                        user_r
xdm             user    s0             s0                        xdm_r
```

**Les Utilisateurs SELinux Expliqués:**

| 👤 Utilisateur | 📝 Rôle | 🛡️ Niveau |
|---|---|---|
| **root** | Admin système | Maximum |
| **staff_u** | Personnel IT | Élevé |
| **sysadm_u** | Administrateur | Élevé |
| **system_u** | Processus système | Interne |
| **unconfined_u** | Non-confiné | Minimum |
| **user_u** | Utilisateur confiné | Bas |
| **xdm** | Écran de connexion | Spécial |

✅ **Score:** 8/8 pts | 100%

---

### Task 5️⃣: Le VIP Pass de la Fête Sécurisée 🎫🎉

**Fichier:** `5-add_selinux.sh`

**Objectif:** Créer un nouveau mapping login SELinux

**Le Script:**
```bash
#!/bin/bash
semanage login -a -s user_u $1
```

**Comment l'utiliser:**
```bash
sudo ./5-add_selinux.sh maroua
```

**Avant ➡️ Après:**
```
AVANT:
Login Name      SELinux User    MLS/MCS Range         Service
__default__     unconfined_u    s0-s0:c0.c1023        *
root            unconfined_u    s0-s0:c0.c1023        *
sddm            xdm             s0-s0                 *

APRÈS (après ./5-add_selinux.sh maroua):
Login Name      SELinux User    MLS/MCS Range         Service
__default__     unconfined_u    s0-s0:c0.c1023        *
maroua          user_u          s0                    * ✓ NOUVEAU!
root            unconfined_u    s0-s0:c0.c1023        *
sddm            xdm             s0-s0                 *
```

**Qu'est-ce que ça fait?**
- 🎫 Donne un "pass" à l'utilisateur `maroua`
- 🔐 Le confine à `user_u` (pas d'admin!)
- 📊 Limite ses niveaux de sécurité

✅ **Score:** 4/4 pts | 100%

---

### Task 6️⃣: Les Boutons Magiques de SELinux 🎛️✨

**Fichier:** `6-list_booleans.sh`

**Objectif:** Lister tous les booleans SELinux

**Le Script:**
```bash
#!/bin/bash
semanage boolean -l
```

**Exemple de sortie:**
```
SELinux boolean                State  Default  Description

aide_mmap_files                (off  ,  off)   Contrôle si AIDE peut mapper les fichiers
allow_execheap                 (off  ,  off)   Autoriser les exécutables à utiliser le heap
httpd_can_sendmail             (off  ,  off)   Apache peut envoyer des emails
xguest_mount_media             (off  ,  off)   L'utilisateur guest peut monter les médias
```

**Les Booleans Expliqués:**

| 🎛️ Boolean | 🎯 Fonction | 📌 Défaut |
|---|---|---|
| **httpd_can_sendmail** | Apache peut envoyer des emails | ❌ off |
| **httpd_enable_homedirs** | Apache peut lire les home dirs | ❌ off |
| **allow_execheap** | Exécutables peuvent utiliser le heap | ❌ off |
| **allow_execstack** | Exécutables peuvent utiliser la stack | ❌ off |

**C'est quoi un boolean?**
- 🔘 Un simple on/off pour contrôler le comportement
- 💾 Les changements sont persistants
- ⚖️ Trade-off entre fonctionnalité et sécurité

✅ **Score:** 10/10 pts | 100%

---

### Task 7️⃣: Apache Envoie des Emails! 📧🚀

**Fichier:** `7-set_sendmail.sh`

**Objectif:** Activer `httpd_can_sendmail` de façon permanente

**Le Script:**
```bash
#!/bin/bash
setsebool -P httpd_can_sendmail on
```

**Explication:**
```
setsebool      # Définir un boolean
  -P           # Persistant (🔧 survit au redémarrage)
  httpd_can_sendmail  # Le boolean à modifier
  on           # Activer
```

**Vérification:**
```bash
sudo semanage boolean -lC
# Output:
httpd_can_sendmail    (on, on)   ✓ Actif et persistent!
```

**Temporaire vs Persistant:**
```bash
# ⏱️ Temporaire (jusqu'au redémarrage)
sudo setsebool httpd_can_sendmail on

# 💾 Permanent (survit au redémarrage)
sudo setsebool -P httpd_can_sendmail on
```

**Pourquoi c'est important?**
- 📧 Apache peut maintenant envoyer des emails
- 🔒 Mais seulement ce qui est autorisé
- ⚖️ Principe du moindre privilège

✅ **Score:** 10/10 pts | 100%

---

## 🎓 Concepts Clés

### MAC vs DAC: La Différence 🔄

| Aspect | 🔓 DAC | 🔒 MAC |
|--------|--------|--------|
| **Contrôle** | L'utilisateur contrôle | L'admin contrôle |
| **Flexibilité** | Changeable par l'user | Impossible de changer |
| **Pouvoir root** | Root peut tout | Root est limité aussi! |
| **Outils** | chmod, chown | SELinux, AppArmor |
| **Précision** | rwx (3 niveaux) | Très fine (contextes) |

### 🎯 SELinux Security Context

```
user:role:type:level
 │     │    │    │
 │     │    │    └─ 📊 Niveau MLS/MCS (s0-s3:c0.c1023)
 │     │    └────── 🏷️ Type/Domaine (httpd_t, user_t)
 │     └─────────── 👤 Rôle RBAC (staff_r, user_r)
 └──────────────── 👨 Identité SELinux (user_u, root)
```

### 🛠️ Outils SELinux

```
📋 semanage       → Gestion persistante
🎯 chcon          → Changements temporaires
🔄 restorecon     → Restaurer contextes
🔘 setsebool      → Modifier les booleans
👁️ getenforce     → Vérifier le mode
```

---

## 🚀 Comment Utiliser

### ⚡ Lancer les Scripts

```bash
# 0️⃣ Vérifier le mode SELinux
sudo ./0-analyse_mode.sh

# 1️⃣ AppArmor status
sudo ./1-security_match.sh

# 2️⃣ Lister les ports HTTP
sudo ./2-list_http.sh

# 3️⃣ Ajouter le port 81
sudo ./3-add_port.sh

# 4️⃣ Lister les users SELinux
sudo ./4-list_user.sh

# 5️⃣ Ajouter une login mapping
sudo ./5-add_selinux.sh username

# 6️⃣ Lister les booleans
sudo ./6-list_booleans.sh

# 7️⃣ Activer sendmail
sudo ./7-set_sendmail.sh
```

### 📖 Commandes semanage Courantes

```bash
# 🔌 Gestion des Ports
sudo semanage port -l                          # Lister tous
sudo semanage port -a -t TYPE -p tcp 8080      # Ajouter
sudo semanage port -d -t TYPE -p tcp 8080      # Supprimer

# 📁 Contextes de Fichiers
sudo semanage fcontext -l                      # Lister
sudo semanage fcontext -a -t TYPE "/path"      # Ajouter
sudo restorecon -Rv /path                      # Appliquer

# 👥 Mappings Utilisateurs
sudo semanage login -l                         # Lister
sudo semanage login -a -s user_u username      # Ajouter
sudo semanage login -d username                # Supprimer

# 🔘 Booleans
sudo semanage boolean -l                       # Lister tous
sudo setsebool BOOL_NAME on                    # Temporaire
sudo setsebool -P BOOL_NAME on                 # Permanent
```

---

## ⚠️ Points Importants

| ⚠️ Attention | 📝 Détails |
|---|---|
| 🔑 **Sudo requis** | Toutes les commandes MAC demandent root |
| 💾 **Persistance** | Utiliser `semanage` et `-P` pour permanent |
| 🔒 **Impact système** | Les erreurs peuvent verrouiller le système |
| 🧪 **Permissive mode** | `sudo setenforce 0` pour tester sans risque |
| 📋 **Audit logs** | Vérifier `/var/log/audit/audit.log` |

---

## 📊 Résultats du Projet

```
✅ Task 0: 4/4 pts   (100%)
✅ Task 1: 4/4 pts   (100%)
✅ Task 2: 10/10 pts (100%)
✅ Task 3: 6/6 pts   (100%)
✅ Task 4: 8/8 pts   (100%)
✅ Task 5: 4/4 pts   (100%)
✅ Task 6: 10/10 pts (100%)
✅ Task 7: 10/10 pts (100%)
─────────────────────────────
📈 TOTAL: 40/40 pts (100%)
```

---

## 📚 Ressources Utiles

- 🔗 [Red Hat SELinux Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/)
- 🔗 [Ubuntu AppArmor Docs](https://ubuntu.com/server/docs/security-apparmor)
- 🔗 [SELinux Project](https://github.com/SELinuxProject)
- 🔗 [AppArmor Wiki](https://gitlab.com/apparmor/apparmor/-/wikis/home)

---

## 📝 Infos du Projet

| Info | Détail |
|------|--------|
| 📦 **Repository** | holbertonschool-cyber_security |
| 📂 **Directory** | linux_security/0x02_mandatory_access_control |
| 📌 **Type** | Mandatory (Toutes les tâches obligatoires) |
| 🎯 **Score** | 40/40 pts (100%) ✅ |
| 👤 **Créateur** | Holberton School - Cyber Security |
| 📅 **Date** | October 21, 2025 |

---

<div align="center">

## 🎉 Félicitations!

Vous avez maîtrisé les bases du **Mandatory Access Control** sur Linux!

Vous savez maintenant comment:
- ✅ Vérifier et configurer SELinux
- ✅ Gérer les ports et contextes
- ✅ Créer des mappings utilisateurs
- ✅ Contrôler les booleans de politique

**Keep learning, stay secure!** 🔐

---

*Créé pour Holberton School - Cyber Security Project*
*All tasks completed successfully ✓*

</div>
