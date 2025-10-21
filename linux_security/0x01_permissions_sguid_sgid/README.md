# 🔐 0x01. Permissions, SUID & SGID

<div align="center">

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Security](https://img.shields.io/badge/Security-FF0000?style=for-the-badge&logo=security&logoColor=white)

**Maîtrisez les permissions Linux et les bits spéciaux SUID/SGID** 🛡️

</div>

---

## 📚 Description

Bienvenue dans ce projet passionnant sur la **sécurité Linux** ! 🚀

Ce projet explore en profondeur les mécanismes de permissions sous Linux, avec un focus particulier sur les **bits spéciaux SUID et SGID**. Ces concepts sont essentiels pour comprendre comment sécuriser (ou compromettre 😈) un système Linux.

### 🎯 Ce que vous allez apprendre :

- 👥 Gestion avancée des utilisateurs et groupes
- 📂 Permissions de fichiers (read, write, execute)
- ⭐ Bits spéciaux : SUID, SGID et Sticky bit
- 🔑 Configuration sudo sans mot de passe
- 🔍 Recherche de vulnérabilités de permissions
- 🛠️ Manipulation avancée avec `find` et `chmod`

---

## 📋 Table des matières

- [Task 0: Créer un utilisateur](#task-0--créer-un-utilisateur)
- [Task 1: Créer un groupe](#task-1--créer-un-groupe)
- [Task 2: Sudo sans mot de passe](#task-2--sudo-sans-mot-de-passe)
- [Task 3: Chasse aux SUID](#task-3--chasse-aux-suid)
- [Task 4: Lister les fichiers SUID](#task-4--lister-les-fichiers-suid)
- [Task 5: Lister les fichiers SGID](#task-5--lister-les-fichiers-sgid)
- [Task 6: Fichiers modifiés avec SUID/SGID](#task-6--fichiers-modifiés-avec-suidsgid)
- [Task 7: Lecture seule pour others](#task-7--lecture-seule-pour-others)
- [Task 8: Changer le propriétaire](#task-8--changer-le-propriétaire)
- [Task 9: Permissions complètes pour fichiers vides](#task-9--permissions-complètes-pour-fichiers-vides)
- [Récapitulatif des permissions](#récapitulatif-des-permissions-linux)

---

## 🔧 Task 0 : Créer un utilisateur

> **Who can add a new user in Linux!**

### 📁 Fichier: `0-add_user.sh`

Script qui crée un nouvel utilisateur et définit son mot de passe.

#### 💻 Code:
```bash
#!/bin/bash
useradd -m $1
echo "$1:$2" | chpasswd
```

#### 📝 Arguments:
- `$1` : Nom d'utilisateur
- `$2` : Mot de passe

#### 🔍 Explication:
| Commande | Description |
|----------|-------------|
| `useradd -m $1` | Crée un utilisateur avec un répertoire home (`-m`) |
| `echo "$1:$2" \| chpasswd` | Définit le mot de passe via pipe |

#### 🚀 Utilisation:
```bash
sudo ./0-add_user.sh holberton H@ck$@f3Gu@rD!
```

#### ✅ Vérification:
```bash
tail -1 /etc/passwd
# holberton:x:1005:1005::/home/holberton:/bin/sh
```

---

## 👥 Task 1 : Créer un groupe

> **Can we trust Groups?**

### 📁 Fichier: `1-add_group.sh`

Script qui crée un nouveau groupe, change le groupe propriétaire d'un fichier et définit les permissions.

#### 💻 Code:
```bash
#!/bin/bash
addgroup $1
chown :$1 $2
chmod g+rx $2
```

#### 📝 Arguments:
- `$1` : Nom du groupe
- `$2` : Fichier cible

#### 🔍 Explication:
| Commande | Description |
|----------|-------------|
| `addgroup $1` | Crée un nouveau groupe |
| `chown :$1 $2` | Change le groupe propriétaire (`:` = groupe seulement) |
| `chmod g+rx $2` | Ajoute read + execute pour le groupe |

#### 🚀 Utilisation:
```bash
sudo ./1-add_group.sh security example.txt
```

#### 📊 Résultat:
```
-rw-rwxr-- 1 maroua security 0 Nov 8 12:03 example.txt
```

---

## 🔓 Task 2 : Sudo sans mot de passe

> **Let's Add some fun!**

### 📁 Fichier: `2-sudo_nopass.sh`

Script qui permet à un utilisateur d'exécuter sudo sans mot de passe.

#### 💻 Code:
```bash
#!/bin/bash
echo "$1 ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
```

#### 📝 Arguments:
- `$1` : Nom d'utilisateur

#### ⚠️ **Attention:**
> En production, utilisez toujours `visudo` pour éditer `/etc/sudoers` en toute sécurité !

#### 🚀 Utilisation:
```bash
sudo ./2-sudo_nopass.sh maroua
```

#### ✅ Résultat:
L'utilisateur peut maintenant exécuter n'importe quelle commande sudo sans entrer de mot de passe ! 🎉

---

## 🔍 Task 3 : Chasse aux SUID

> **SUID hunting, Known Exploits!**

### 📁 Fichier: `3-find_files.sh`

Script qui recherche les vulnérabilités SUID dans un répertoire.

#### 💻 Code:
```bash
#!/bin/bash
find $1 -perm -4000 -exec ls -l {} \; 2> /dev/null
```

#### 📝 Arguments:
- `$1` : Répertoire cible

#### 🔍 Explication:
- `-perm -4000` : Recherche le bit SUID (4000 en octal)
- `-exec ls -l {} \;` : Affiche les détails de chaque fichier
- `2> /dev/null` : Masque les erreurs

#### 💡 Qu'est-ce que SUID ?
> Le bit **SUID** (Set User ID) permet à un fichier d'être exécuté avec les privilèges du **propriétaire** du fichier. C'est une cible privilégiée pour les attaquants ! 🎯

#### 🚀 Utilisation:
```bash
sudo ./3-find_files.sh /usr/bin
```

---

## 🎯 Task 4 : Lister les fichiers SUID

> **Handle the SUID bit like a hot potato!**

### 📁 Fichier: `4-find_suid.sh`

Script qui liste tous les fichiers avec SUID dans un répertoire.

#### 💻 Code:
```bash
#!/bin/bash
find $1 -perm -4000 -type f -ls 2> /dev/null
```

#### 📝 Arguments:
- `$1` : Répertoire

#### 🔍 Explication:
- `-type f` : Seulement les fichiers (pas les répertoires)
- `-ls` : Affiche les détails complets

#### 🚀 Utilisation:
```bash
sudo ./4-find_suid.sh Security
```

---

## 👫 Task 5 : Lister les fichiers SGID

> **Group hug your files with Setgid!**

### 📁 Fichier: `5-find_sgid.sh`

Script qui liste tous les fichiers avec SGID dans un répertoire.

#### 💻 Code:
```bash
#!/bin/bash
find $1 -perm -2000 -type f -ls 2> /dev/null
```

#### 📝 Arguments:
- `$1` : Répertoire

#### 💡 Qu'est-ce que SGID ?
> Le bit **SGID** (Set Group ID) fonctionne comme SUID mais pour les **groupes**. Sur un répertoire, il force les nouveaux fichiers à hériter du groupe du répertoire ! 🤝

#### 🚀 Utilisation:
```bash
sudo ./5-find_sgid.sh Security
```

---

## ⏰ Task 6 : Fichiers modifiés avec SUID/SGID

> **Finding files with setuid or setgid!**

### 📁 Fichier: `6-check_files.sh`

Script qui trouve les fichiers modifiés dans les dernières 24h avec SUID ou SGID.

#### 💻 Code:
```bash
#!/bin/bash
find $1 \(-type f -perm /2000 -o -perm /4000 \) -mtime -1 exec ls -l {} \; 2> /dev/null
```

#### 📝 Arguments:
- `$1` : Répertoire

#### 🔍 Explication:
- `\( ... \)` : Groupe les conditions
- `-perm /2000 -o -perm /4000` : SGID **OU** SUID
- `-mtime -1` : Modifié dans les dernières 24 heures
- `-o` : Opérateur OR

#### 🚀 Utilisation:
```bash
sudo ./6-check_files.sh Security
```

---

## 📖 Task 7 : Lecture seule pour others

> **Others can read the files, but no writing privileges allowed!**

### 📁 Fichier: `7-file_read.sh`

Script qui met tous les fichiers en lecture seule pour "others".

#### 💻 Code:
```bash
#!/bin/bash
find $1 -type f -exec -chmod o=r {} \; 2>/dev/null
```

#### 📝 Arguments:
- `$1` : Répertoire

#### 🔍 Explication:
- `chmod o=r` : Définit "others" à **lecture seule** (r--)
- Le `=` **remplace** toutes les permissions existantes

#### 📊 Transformation:
```diff
- -rwxrwxr-x  (others = r-x)
+ -rwxrwxr--  (others = r--)
```

#### 🚀 Utilisation:
```bash
sudo ./7-file_read.sh Security/
```

---

## 🔄 Task 8 : Changer le propriétaire

> **Changing file owners, one friendship at a time!**

### 📁 Fichier: `8-change_user.sh`

Script qui change le propriétaire de user2 à user3.

#### 💻 Code:
```bash
#!/bin/bash
find "$1" -type f -user user2 -exec chown user3 {} \;
```

#### 📝 Arguments:
- `$1` : Répertoire

#### 🔍 Explication:
- `-user user2` : Filtre seulement les fichiers de user2
- `chown user3` : Change le propriétaire à user3
- `"$1"` : Guillemets pour protéger contre les espaces

#### 📊 Transformation:
```diff
- -rwxrwxr-- 1 user2 maroua  33 Dec 19 11:00 file.sh
+ -rwxrwxr-- 1 user3 maroua  33 Dec 19 11:00 file.sh
```

#### 🚀 Utilisation:
```bash
sudo ./8-change_user.sh Security/
```

---

## 🎉 Task 9 : Permissions complètes pour fichiers vides

> **Empty files got a promotion!**

### 📁 Fichier: `9-empty_file.sh`

Script qui donne toutes les permissions aux fichiers vides.

#### 💻 Code:
```bash
#!/bin/bash
find $1 -type f -empty -exec chmod 777 {} \;
```

#### 📝 Arguments:
- `$1` : Répertoire

#### 🔍 Explication:
- `-empty` : Trouve les fichiers vides (taille 0)
- `chmod 777` : Permissions complètes (rwxrwxrwx)
  - **7** = 4(read) + 2(write) + 1(execute)

#### 📊 Transformation:
```diff
- -rw-r--r-- 1 maroua maroua 0 Jan 3 14:16 flag.txt
+ -rwxrwxrwx 1 maroua maroua 0 Jan 3 14:16 flag.txt
```

#### 🚀 Utilisation:
```bash
sudo ./9-empty_file.sh Security/
```

---

## 📚 Récapitulatif des Permissions Linux

### 🎨 Format des permissions

```
-rwxrwxrwx
│││││││││└─ 🌍 other: execute
││││││││└── 🌍 other: write
│││││││└─── 🌍 other: read
││││││└──── 👥 group: execute
│││││└───── 👥 group: write
││││└────── 👥 group: read
│││└─────── 👤 owner: execute
││└──────── 👤 owner: write
│└───────── 👤 owner: read
└────────── 📄 type (- = fichier, d = répertoire)
```

### 🔢 Valeurs octales

| Octal | Binaire | Permissions | Signification |
|-------|---------|-------------|---------------|
| **0** | 000 | `---` | Aucune permission |
| **1** | 001 | `--x` | Execute seulement |
| **2** | 010 | `-w-` | Write seulement |
| **3** | 011 | `-wx` | Write + Execute |
| **4** | 100 | `r--` | Read seulement |
| **5** | 101 | `r-x` | Read + Execute |
| **6** | 110 | `rw-` | Read + Write |
| **7** | 111 | `rwx` | Toutes les permissions |

### ⭐ Bits spéciaux

| Bit | Valeur | Nom | Effet |
|-----|--------|-----|-------|
| 🔴 | 4000 | **SUID** | Exécute avec les privilèges du propriétaire |
| 🔵 | 2000 | **SGID** | Exécute avec les privilèges du groupe |
| 🟡 | 1000 | **Sticky** | Seul le propriétaire peut supprimer (répertoires) |

### 🛠️ Commandes essentielles

| Commande | Usage | Exemple |
|----------|-------|---------|
| `chmod` | Change les permissions | `chmod 755 script.sh` |
| `chown` | Change le propriétaire | `chown user:group file.txt` |
| `chgrp` | Change le groupe | `chgrp developers project/` |
| `find` | Recherche de fichiers | `find / -perm -4000` |
| `useradd` | Crée un utilisateur | `useradd -m john` |
| `addgroup` | Crée un groupe | `addgroup developers` |

### 💡 Exemples pratiques

#### Rendre un script exécutable :
```bash
chmod +x script.sh
# ou
chmod 755 script.sh
```

#### Protéger un fichier sensible :
```bash
chmod 600 secret.txt  # Seul le propriétaire peut lire/écrire
```

#### Créer un répertoire partagé :
```bash
mkdir shared
chmod 770 shared      # Owner et Group: rwx, Others: ---
chgrp developers shared
```

#### Trouver tous les fichiers SUID du système :
```bash
find / -perm -4000 -type f 2>/dev/null
```

---

## 🎓 Points clés à retenir

<div align="center">

| Concept | 🔑 Point important |
|---------|-------------------|
| **SUID** | Permet d'exécuter un programme avec les droits du propriétaire |
| **SGID** | Permet d'exécuter un programme avec les droits du groupe |
| **Sticky Bit** | Protège les fichiers dans un répertoire partagé |
| **chmod** | Modifie les permissions (symbolique ou octal) |
| **chown** | Change propriétaire et/ou groupe |
| **find** | Outil puissant pour rechercher et agir sur des fichiers |

</div>

---

## 🏆 Auteur

<div align="center">

**Pmichel74** 🚀

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Pmichel74)

📦 **Repository:** holbertonschool-cyber_security  
📂 **Project:** linux_security/0x01_permissions_sguid_sgid

</div>

---

## 📖 Ressources

- 📘 [Linux File Permissions - Linux.com](https://www.linux.com/training-tutorials/understanding-linux-file-permissions/)
- 🔐 [SUID, SGID and Sticky Bit - Red Hat](https://www.redhat.com/sysadmin/suid-sgid-sticky-bit)
- 🔍 [Find Command in Linux - GeeksforGeeks](https://www.geeksforgeeks.org/find-command-in-linux-with-examples/)
- 📚 [Linux Privilege Escalation - HackTricks](https://book.hacktricks.xyz/linux-hardening/privilege-escalation)
- 🛡️ [Linux Security - ArchWiki](https://wiki.archlinux.org/title/Security)

---

<div align="center">

**✨ Bon courage avec vos explorations en cybersécurité ! ✨**

🔒 *"With great permissions comes great responsibility"* 🔒

</div>
Ce projet explore les concepts avancés de gestion des permissions Linux, incluant les bits SUID (Set User ID) et SGID (Set Group ID). Ces mécanismes permettent d'exécuter des fichiers avec les privilèges du propriétaire ou du groupe, ce qui est essentiel pour la sécurité système.

## Concepts abordés
- Gestion des utilisateurs et groupes Linux
- Permissions de fichiers (read, write, execute)
- Bits spéciaux SUID et SGID
- Configuration sudo
- Recherche de vulnérabilités de permissions
- Manipulation avancée avec `find` et `chmod`

---

## Tasks

### 0. Who can add a new user in Linux!
**Fichier:** `0-add_user.sh`

Script bash qui crée un nouvel utilisateur et définit son mot de passe.

**Arguments:**
- `$1`: nom d'utilisateur
- `$2`: mot de passe

**Solution:**
```bash
#!/bin/bash
useradd -m $1
echo "$1:$2" | chpasswd
```

**Explication:**
- `useradd -m $1`: Crée un utilisateur avec un répertoire home (-m)
- `echo "$1:$2" | chpasswd`: Définit le mot de passe via pipe vers chpasswd

**Utilisation:**
```bash
sudo ./0-add_user.sh holberton H@ck$@f3Gu@rD!
```

---

### 1. Can we trust Groups?
**Fichier:** `1-add_group.sh`

Script qui crée un nouveau groupe, change le groupe propriétaire d'un fichier et définit les permissions.

**Arguments:**
- `$1`: nom du groupe
- `$2`: fichier cible

**Solution:**
```bash
#!/bin/bash
addgroup $1
chown :$1 $2
chmod g+rx $2
```

**Explication:**
- `addgroup $1`: Crée un nouveau groupe
- `chown :$1 $2`: Change le groupe propriétaire du fichier (le : indique qu'on change seulement le groupe)
- `chmod g+rx $2`: Ajoute les permissions lecture et exécution pour le groupe

**Utilisation:**
```bash
sudo ./1-add_group.sh security example.txt
```

---

### 2. Let's Add some fun!
**Fichier:** `2-sudo_nopass.sh`

Script qui permet à un utilisateur d'exécuter sudo sans entrer de mot de passe.

**Arguments:**
- `$1`: nom d'utilisateur

**Solution:**
```bash
#!/bin/bash
echo "$1 ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
```

**Explication:**
- Ajoute une ligne au fichier `/etc/sudoers`
- `NOPASSWD: ALL` permet d'exécuter toutes les commandes sans mot de passe
- ⚠️ **Attention:** En production, utiliser `visudo` pour éditer ce fichier en toute sécurité

**Utilisation:**
```bash
sudo ./2-sudo_nopass.sh maroua
```

---

### 3. SUID hunting, Known Exploits!
**Fichier:** `3-find_files.sh`

Script qui recherche les vulnérabilités SUID dans un répertoire spécifié.

**Arguments:**
- `$1`: répertoire cible

**Solution:**
```bash
#!/bin/bash
find $1 -perm -4000 -exec ls -l {} \; 2> /dev/null
```

**Explication:**
- `find $1 -perm -4000`: Recherche les fichiers avec le bit SUID activé (4000)
- `-exec ls -l {} \;`: Affiche les détails de chaque fichier trouvé
- `2> /dev/null`: Redirige les erreurs vers /dev/null

**Utilisation:**
```bash
sudo ./3-find_files.sh /usr/bin
```

**Qu'est-ce que SUID?**
Le bit SUID (Set User ID) permet à un fichier d'être exécuté avec les privilèges du propriétaire du fichier plutôt que de l'utilisateur qui l'exécute. C'est pourquoi c'est une cible pour les attaquants.

---

### 4. Handle the SUID bit like a hot potato fun, but use it wisely!
**Fichier:** `4-find_suid.sh`

Script qui liste tous les fichiers avec SUID activé dans un répertoire donné.

**Arguments:**
- `$1`: répertoire

**Solution:**
```bash
#!/bin/bash
find $1 -perm -4000 -type f -ls 2> /dev/null
```

**Explication:**
- `-perm -4000`: Recherche le bit SUID (4 en octal)
- `-type f`: Seulement les fichiers (pas les répertoires)
- `-ls`: Affiche les détails complets

**Utilisation:**
```bash
sudo ./4-find_suid.sh Security
```

---

### 5. Group hug your files with Setgid!
**Fichier:** `5-find_sgid.sh`

Script qui liste tous les fichiers avec SGID activé dans un répertoire donné.

**Arguments:**
- `$1`: répertoire

**Solution:**
```bash
#!/bin/bash
find $1 -perm -2000 -type f -ls 2> /dev/null
```

**Explication:**
- `-perm -2000`: Recherche le bit SGID (2 en octal)
- Le bit SGID permet aux fichiers d'être exécutés avec les privilèges du groupe propriétaire

**Utilisation:**
```bash
sudo ./5-find_sgid.sh Security
```

**Qu'est-ce que SGID?**
Le bit SGID (Set Group ID) fonctionne comme SUID mais pour les groupes. Sur un répertoire, il force les nouveaux fichiers à hériter du groupe du répertoire.

---

### 6. Finding files with setuid or setgid!
**Fichier:** `6-check_files.sh`

Script qui trouve tous les fichiers modifiés dans les dernières 24 heures avec SUID ou SGID activé.

**Arguments:**
- `$1`: répertoire

**Solution:**
```bash
#!/bin/bash
find $1 \(-type f -perm /2000 -o -perm /4000 \) -mtime -1 exec ls -l {} \; 2> /dev/null
```

**Explication:**
- `\( ... \)`: Groupe les conditions
- `-perm /2000 -o -perm /4000`: Recherche SGID OU SUID (/ signifie "au moins un bit")
- `-mtime -1`: Modifié dans les dernières 24 heures (-1 jour)
- `-o`: Opérateur OR (ou)

**Utilisation:**
```bash
sudo ./6-check_files.sh Security
```

---

### 7. Others can read the files, but no writing privileges allowed!
**Fichier:** `7-file_read.sh`

Script qui change les permissions de tous les fichiers dans un répertoire en lecture seule pour "others" sans modifier les permissions owner/group.

**Arguments:**
- `$1`: répertoire

**Solution:**
```bash
#!/bin/bash
find $1 -type f -exec -chmod o=r {} \; 2>/dev/null
```

**Explication:**
- `chmod o=r`: Définit les permissions "others" à lecture seule (r--)
- Le `=` remplace toutes les permissions existantes pour "others"
- Retire automatiquement write (w) et execute (x) pour "others"

**Utilisation:**
```bash
sudo ./7-file_read.sh Security/
```

**Exemple:**
- Avant: `-rwxrwxr-x` (others = r-x)
- Après: `-rwxrwxr--` (others = r--)

---

### 8. Changing file owners, one friendship at a time!
**Fichier:** `8-change_user.sh`

Script qui change le propriétaire des fichiers d'un répertoire de user2 à user3.

**Arguments:**
- `$1`: répertoire

**Solution:**
```bash
#!/bin/bash
find "$1" -type f -user user2 -exec chown user3 {} \;
```

**Explication:**
- `-user user2`: Filtre seulement les fichiers appartenant à user2
- `chown user3`: Change le propriétaire à user3
- Les guillemets autour de `"$1"` protègent contre les espaces dans les noms

**Utilisation:**
```bash
sudo ./8-change_user.sh Security/
```

---

### 9. Empty files got a promotion – now they're living large with full permissions!
**Fichier:** `9-empty_file.sh`

Script qui trouve tous les fichiers vides dans un répertoire et leur donne les permissions complètes.

**Arguments:**
- `$1`: répertoire

**Solution:**
```bash
#!/bin/bash
find $1 -type f -empty -exec chmod 777 {} \;
```

**Explication:**
- `-empty`: Trouve les fichiers vides (taille 0)
- `chmod 777`: Donne toutes les permissions (rwxrwxrwx)
  - 7 = 4(read) + 2(write) + 1(execute)
  - Premier 7 = owner, deuxième 7 = group, troisième 7 = others

**Utilisation:**
```bash
sudo ./9-empty_file.sh Security/
```

**Exemple:**
- Avant: `-rw-r--r--` (644)
- Après: `-rwxrwxrwx` (777)

---

## Permissions Linux - Récapitulatif

### Format des permissions
```
-rwxrwxrwx
│││││││││└─ other: execute
││││││││└── other: write
│││││││└─── other: read
││││││└──── group: execute
│││││└───── group: write
││││└────── group: read
│││└─────── owner: execute
││└──────── owner: write
│└───────── owner: read
└────────── type de fichier (- = fichier, d = répertoire)
```

### Valeurs octales
- `4` = read (r)
- `2` = write (w)
- `1` = execute (x)
- `0` = aucune permission (-)

### Bits spéciaux
- **SUID (4000)**: Exécute avec les privilèges du propriétaire
- **SGID (2000)**: Exécute avec les privilèges du groupe
- **Sticky bit (1000)**: Seul le propriétaire peut supprimer (pour répertoires)

### Commandes importantes
- `chmod`: Change les permissions
- `chown`: Change le propriétaire
- `chgrp`: Change le groupe
- `find`: Recherche de fichiers
- `useradd/adduser`: Crée un utilisateur
- `addgroup/groupadd`: Crée un groupe

---

## Auteur
**Pmichel74**
- Repository: holbertonschool-cyber_security
- Project: linux_security/0x01_permissions_sguid_sgid

---

## Ressources
- [Linux File Permissions](https://www.linux.com/training-tutorials/understanding-linux-file-permissions/)
- [SUID, SGID and Sticky Bit](https://www.redhat.com/sysadmin/suid-sgid-sticky-bit)
- [Find Command in Linux](https://www.geeksforgeeks.org/find-command-in-linux-with-examples/) 