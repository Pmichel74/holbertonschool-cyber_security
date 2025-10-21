# Mandatory Access Control (MAC) - Guide de Reference

## Table des Matieres

1. [Qu'est-ce que le MAC sous Linux ?](#1-quest-ce-que-le-mac-sous-linux)
2. [Comment SELinux applique le MAC](#2-comment-selinux-applique-le-mac)
3. [Differences entre SELinux et AppArmor](#3-differences-entre-selinux-et-apparmor)
4. [Le Role des Politiques dans MAC](#4-le-role-des-politiques-dans-mac)
5. [Les Labels dans SELinux](#5-les-labels-dans-selinux)
6. [Type Enforcement, RBAC et MLS](#6-type-enforcement-rbac-et-mls)
7. [Verifier le Statut de SELinux](#7-verifier-le-statut-de-selinux)
8. [Commandes de Gestion SELinux](#8-commandes-de-gestion-selinux)
9. [Definir les Contextes de Fichiers](#9-definir-les-contextes-de-fichiers)
10. [Les Profils AppArmor](#10-les-profils-apparmor)
11. [Recharger les Profils AppArmor](#11-recharger-les-profils-apparmor)
12. [Le Principe du Moindre Privilege](#12-le-principe-du-moindre-privilege)
13. [Depannage SELinux](#13-depannage-selinux)
14. [Importance des Logs d'Audit](#14-importance-des-logs-daudit)
15. [Les Capacites Linux](#15-les-capacites-linux)
16. [Utiliser semanage](#16-utiliser-semanage)

---

## 1. Qu'est-ce que le MAC sous Linux ?

### Definition

Le **MAC (Mandatory Access Control)** est un modele de securite ou l'acces aux ressources est controle par une **politique centralisee** que les utilisateurs ne peuvent pas modifier.

### Difference avec DAC

| DAC (Discretionary) | MAC (Mandatory) |
|---------------------|-----------------|
| Le proprietaire controle les permissions | La politique systeme controle l'acces |
| `chmod`, `chown` par l'utilisateur | Politique administrative centralisee |
| Root peut tout faire | Meme root est restreint |
| Permissions : rwx | Labels de securite + politiques |

### Implementations principales

- **SELinux** : Base sur les labels (Red Hat, Fedora, CentOS)
- **AppArmor** : Base sur les chemins (Ubuntu, SUSE)

### Avantages du MAC

- Protege contre les erreurs humaines
- Confine les processus compromis
- Defense en profondeur
- Application du principe du moindre privilege

**Exemple concret :**
```bash
# Avec DAC : root peut tout faire
sudo cat /etc/shadow   # Succes

# Avec MAC (SELinux) : meme root est restreint
# Si le processus n'a pas le bon contexte SELinux → REFUSE
```

---

## 2. Comment SELinux applique le MAC

### Mecanisme de Fonctionnement

SELinux applique le MAC via **3 elements cles** :

#### 1. Etiquetage (Labeling)
Chaque objet (fichier, processus, port) recoit un **contexte de securite**

```bash
ls -Z /var/www/html/index.html
-rw-r--r--. apache apache system_u:object_r:httpd_sys_content_t:s0 index.html
                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                           Contexte SELinux
```

#### 2. Politique de Securite
Base de regles qui definissent les interactions autorisees

```
Regle : allow httpd_t httpd_sys_content_t:file { read };
        ^^^^^  ^^^^^^  ^^^^^^^^^^^^^^^^^^  ^^^^   ^^^^
        Sujet  Type    Type objet          Classe Permission
```

#### 3. Application par le Noyau
Le noyau Linux verifie chaque operation contre la politique **AVANT** de verifier DAC

### Flux de Decision

```
Processus Apache (httpd_t) veut lire index.html (httpd_sys_content_t)
        ↓
1. SELinux verifie : Existe-t-il une regle "allow httpd_t httpd_sys_content_t:file read" ?
        ↓
2. Si OUI → Passer au controle DAC (rwx)
   Si NON → REFUSER immediatement (log dans audit.log)
```

### Modes de SELinux

| Mode | Description | Usage |
|------|-------------|-------|
| **Enforcing** | Politique appliquee, violations bloquees | Production |
| **Permissive** | Violations journalisees mais autorisees | Debug |
| **Disabled** | SELinux desactive | Non recommande |

---

## 3. Differences entre SELinux et AppArmor

### Tableau Comparatif

| Caracteristique | SELinux | AppArmor |
|----------------|---------|----------|
| **Mecanisme** | Labels (attributs etendus) | Chemins de fichiers |
| **Complexite** | Elevee | Faible a moyenne |
| **Granularite** | Tres fine (processus, sockets, IPC) | Moyenne (fichiers, capacites) |
| **Distributions** | RHEL, Fedora, CentOS | Ubuntu, SUSE |
| **Configuration** | Contextes (user:role:type:level) | Profils textuels |
| **Fichiers de config** | `/etc/selinux/` | `/etc/apparmor.d/` |
| **MLS/MCS** | Oui (isolation multi-niveaux) | Non |
| **Courbe d'apprentissage** | Abrupte | Douce |
| **Mode apprentissage** | Permissive | Complain |

### Exemple SELinux

```bash
# Contexte d'un fichier
ls -Z /var/www/html/index.html
system_u:object_r:httpd_sys_content_t:s0

# Politique
allow httpd_t httpd_sys_content_t:file read;
```

### Exemple AppArmor

```bash
# Profil dans /etc/apparmor.d/usr.bin.firefox
/usr/bin/firefox {
  /etc/firefox/** r,
  /home/*/.mozilla/** rw,
  deny /home/*/.ssh/** rw,
}
```

### Quand utiliser quoi ?

**SELinux :**
- Environnements haute securite
- Besoins de conformite stricte (FIPS, STIG)
- Isolation VMs/conteneurs (MLS/MCS)

**AppArmor :**
- Deploiement rapide
- Petites equipes
- Serveurs web standards

---

## 4. Le Role des Politiques dans MAC

### Definition

Une **politique** est un ensemble de regles qui definissent **qui peut acceder a quoi et comment**.

### Types de Politiques SELinux

#### 1. Targeted (par defaut)
- Confine uniquement les services reseau critiques
- Processus cibles : Apache, MySQL, SSH, etc.
- Autres processus : domaine `unconfined_t`

#### 2. MLS (Multi-Level Security)
- Hierarchie de niveaux : Public < Secret < Top Secret
- Regle : Pas de lecture "au-dessus", pas d'ecriture "en-dessous"

#### 3. MCS (Multi-Category Security)
- Compartimentage horizontal
- Usage : Isolation de VMs et conteneurs

### Contenu d'une Politique

```bash
# Regle Type Enforcement
allow httpd_t httpd_sys_content_t:file { read getattr open };

# Transition de domaine
type_transition init_t httpd_exec_t:process httpd_t;

# Booleen (interrupteur on/off)
bool httpd_enable_homedirs false;
```

### Pourquoi des Politiques ?

1. **Standardisation** : Regles uniformes pour tout le systeme
2. **Separation** : Isolation des services les uns des autres
3. **Audit** : Tracabilite de tous les acces
4. **Conformite** : Respect des normes de securite

---

## 5. Les Labels dans SELinux

### Format d'un Label (Contexte)

```
user:role:type:level
```

**Exemple :**
```
system_u:object_r:httpd_sys_content_t:s0
   ↓        ↓           ↓              ↓
User     Role        Type           Level
```

### Composants du Label

| Composant | Description | Exemples |
|-----------|-------------|----------|
| **User** | Identite SELinux | `system_u`, `user_u`, `root` |
| **Role** | Role RBAC | `object_r`, `system_r`, `user_r` |
| **Type** | Type de domaine/fichier (TE) | `httpd_t`, `httpd_sys_content_t` |
| **Level** | Niveau MLS/MCS | `s0`, `s0:c0.c1023` |

### Stockage des Labels

**Fichiers :**
```bash
# Attributs etendus du systeme de fichiers
getfattr -n security.selinux /var/www/html/index.html
```

**Processus :**
```bash
# Geres par le noyau
ps auxZ | grep httpd
system_u:system_r:httpd_t:s0    apache   1234  httpd
```

**Ports :**
```bash
# Base de donnees SELinux
semanage port -l | grep http
http_port_t      tcp      80, 443, 8080
```

### Visualiser les Labels

```bash
# Fichiers
ls -Z /var/www/html/
-rw-r--r--. apache apache system_u:object_r:httpd_sys_content_t:s0 index.html

# Processus
ps auxZ | grep apache

# Utilisateur actuel
id -Z
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```

### Exemples de Labels Courants

| Fichier/Processus | Type (Label) |
|-------------------|--------------|
| Binaire Apache | `httpd_exec_t` |
| Processus Apache | `httpd_t` |
| Contenu web | `httpd_sys_content_t` |
| Config Apache | `httpd_config_t` |
| Logs Apache | `httpd_log_t` |
| `/etc/shadow` | `shadow_t` |
| Processus utilisateur | `unconfined_t` |

---

## 6. Type Enforcement, RBAC et MLS

### 1. Type Enforcement (TE)

**Definition :** Mecanisme principal de SELinux qui controle l'acces base sur les **types**.

**Principe :**
- Chaque sujet (processus) a un type de **domaine**
- Chaque objet (fichier) a un type de **categorie**
- Les regles definissent les interactions autorisees

**Exemple :**
```bash
# Processus Apache
Type domaine : httpd_t

# Fichier web
Type categorie : httpd_sys_content_t

# Regle de politique
allow httpd_t httpd_sys_content_t:file { read open getattr };
```

**Protection :**
```bash
# Apache (httpd_t) tente de lire /etc/shadow (shadow_t)
# Pas de regle "allow httpd_t shadow_t:file read"
# → REFUSE (meme si root !)
```

### 2. RBAC (Role-Based Access Control)

**Definition :** Controle d'acces base sur les **roles** plutot que les utilisateurs.

**Structure :**
```
Utilisateur SELinux → Role → Types (domaines)
```

**Exemple :**
```bash
# Utilisateur SELinux
user_u → role user_r → peut executer user_t

# Utilisateur systeme
system_u → role system_r → peut executer httpd_t, mysqld_t
```

**Avantages :**
- Simplification de la gestion
- Separation des privileges
- Moindre privilege par role

### 3. MLS (Multi-Level Security)

**Definition :** Modele de securite **hierarchique** avec niveaux de classification.

**Niveaux :**
```
s0 (Public)
s1 (Confidentiel)
s2 (Secret)
s3 (Top Secret)
```

**Regles Bell-LaPadula :**
- **No Read Up** : Un sujet ne peut pas lire au-dessus de son niveau
- **No Write Down** : Un sujet ne peut pas ecrire en-dessous de son niveau

**Exemple :**
```bash
# Processus niveau s1 (Confidentiel)
Peut lire : s0 (Public), s1 (Confidentiel)
Ne peut pas lire : s2 (Secret), s3 (Top Secret)

Peut ecrire : s1 (Confidentiel), s2 (Secret), s3 (Top Secret)
Ne peut pas ecrire : s0 (Public)
```

### MCS (Multi-Category Security)

**Definition :** Compartimentage **horizontal** (pas de hierarchie).

**Usage principal :** Isolation de VMs et conteneurs

**Exemple sVirt (virtualisation) :**
```bash
# VM 1
Processus : svirt_t:s0:c100,c200
Disque : svirt_image_t:s0:c100,c200

# VM 2
Processus : svirt_t:s0:c300,c400
Disque : svirt_image_t:s0:c300,c400

# VM 1 ne peut PAS acceder au disque de VM 2 (categories differentes)
```

---

## 7. Verifier le Statut de SELinux

### Commande principale : sestatus

```bash
sestatus
```

**Sortie :**
```
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      33
```

### Autres commandes de verification

```bash
# Mode actuel
getenforce
# Output: Enforcing

# Fichier de configuration
cat /etc/selinux/config
SELINUX=enforcing
SELINUXTYPE=targeted

# Modules LSM actifs
cat /sys/kernel/security/lsm
capability,yama,selinux

# Version de la politique
sestatus | grep "policy version"
```

### Verification rapide

```bash
# SELinux est-il active ?
if [ $(getenforce) != "Disabled" ]; then
    echo "SELinux is active"
else
    echo "SELinux is disabled"
fi
```

---

## 8. Commandes de Gestion SELinux

### Commandes Essentielles

| Commande | Description | Exemple |
|----------|-------------|---------|
| `getenforce` | Affiche le mode actuel | `getenforce` |
| `setenforce` | Change le mode (temporaire) | `setenforce 0` (Permissive) |
| `sestatus` | Etat complet de SELinux | `sestatus` |
| `ls -Z` | Affiche les contextes de fichiers | `ls -Z /var/www/html/` |
| `ps auxZ` | Affiche les contextes de processus | `ps auxZ | grep httpd` |
| `id -Z` | Contexte de l'utilisateur actuel | `id -Z` |
| `chcon` | Modifie le contexte (temporaire) | `chcon -t httpd_sys_content_t file.html` |
| `restorecon` | Restaure le contexte par defaut | `restorecon -Rv /var/www/html/` |
| `semanage` | Gestion de la politique (persistant) | `semanage fcontext -a -t httpd_sys_content_t "/web(/.*)?"` |
| `getsebool` | Affiche les booleens | `getsebool -a | grep httpd` |
| `setsebool` | Modifie les booleens | `setsebool -P httpd_enable_homedirs on` |
| `audit2allow` | Genere des regles depuis les logs | `audit2allow -a` |
| `semodule` | Gestion des modules de politique | `semodule -l` |

### Exemples Pratiques

**Changer le mode :**
```bash
# Passer en mode Permissive (temporaire)
sudo setenforce 0

# Passer en mode Enforcing (temporaire)
sudo setenforce 1

# Permanent (necessite redemarrage)
sudo vi /etc/selinux/config
SELINUX=enforcing
```

**Gerer les booleens :**
```bash
# Lister tous
getsebool -a

# Filtrer
getsebool -a | grep httpd

# Activer (temporaire)
setsebool httpd_enable_homedirs on

# Activer (permanent)
setsebool -P httpd_enable_homedirs on
```

**Gerer les modules :**
```bash
# Lister les modules
semodule -l

# Installer un module
semodule -i mon-module.pp

# Supprimer un module
semodule -r mon-module
```

---

## 9. Definir les Contextes de Fichiers

### Methode 1 : chcon (Temporaire)

**Usage :** Modification rapide, **non persistante**

```bash
# Changer le type
sudo chcon -t httpd_sys_content_t /var/www/html/index.html

# Changer tout le contexte
sudo chcon -u system_u -r object_r -t httpd_sys_content_t index.html

# Recursif
sudo chcon -R -t httpd_sys_content_t /var/www/html/

# Copier le contexte d'un autre fichier
sudo chcon --reference=/var/www/html/existing.html new.html
```

**Limitation :** Le contexte est perdu apres `restorecon` ou re-etiquetage du systeme.

### Methode 2 : semanage + restorecon (Persistant)

**Usage :** Modification **persistante** et recommandee

**Etapes :**

```bash
# 1. Definir la regle de contexte par defaut
sudo semanage fcontext -a -t httpd_sys_content_t "/custom-web(/.*)?"

# 2. Appliquer la regle aux fichiers existants
sudo restorecon -Rv /custom-web/

# 3. Verifier
ls -Z /custom-web/
```

**Verifier les regles definies :**
```bash
sudo semanage fcontext -l | grep custom-web
/custom-web(/.*)?     all files     system_u:object_r:httpd_sys_content_t:s0
```

### Methode 3 : restorecon (Restauration)

**Usage :** Restaurer les contextes par defaut selon la politique

```bash
# Restaurer un fichier
sudo restorecon /var/www/html/index.html

# Recursif avec affichage
sudo restorecon -Rv /var/www/html/
Relabeled /var/www/html/index.html from unconfined_u:object_r:user_home_t:s0 to system_u:object_r:httpd_sys_content_t:s0

# -R : recursif
# -v : verbose
# -F : forcer le re-etiquetage
```

### Exemple Complet

**Scenario :** Creer un nouveau repertoire web `/srv/myweb`

```bash
# 1. Creer le repertoire
sudo mkdir -p /srv/myweb/html

# 2. Copier des fichiers
sudo cp /var/www/html/index.html /srv/myweb/html/

# 3. Verifier le contexte (probablement incorrect)
ls -Z /srv/myweb/html/index.html
unconfined_u:object_r:admin_home_t:s0 index.html

# 4. Definir le contexte par defaut (persistant)
sudo semanage fcontext -a -t httpd_sys_content_t "/srv/myweb(/.*)?"

# 5. Appliquer
sudo restorecon -Rv /srv/myweb/

# 6. Verifier
ls -Z /srv/myweb/html/index.html
system_u:object_r:httpd_sys_content_t:s0 index.html
```

---

## 10. Les Profils AppArmor

### Definition

Un **profil AppArmor** est un fichier texte qui definit les permissions d'une application specifique.

### Localisation

```bash
/etc/apparmor.d/
```

### Convention de Nommage

Chemin de l'executable avec `/` remplaces par `.`

**Exemples :**
- `/bin/ping` → `/etc/apparmor.d/bin.ping`
- `/usr/bin/firefox` → `/etc/apparmor.d/usr.bin.firefox`

### Structure d'un Profil

```apparmor
#include <tunables/global>

# Profil pour /usr/bin/nginx
/usr/bin/nginx {
  #include <abstractions/base>
  #include <abstractions/nameservice>

  # Regles de fichiers
  /etc/nginx/** r,                    # Lecture config
  /var/log/nginx/** w,                # Ecriture logs
  /var/www/** r,                      # Lecture contenu web
  /run/nginx.pid w,                   # PID file

  # Capacites
  capability net_bind_service,       # Lier port < 1024
  capability setuid,                 # Changer UID
  capability setgid,                 # Changer GID

  # Execution d'autres programmes
  /usr/bin/helper Px,                # Transition vers profil helper
}
```

### Types de Permissions

| Permission | Signification |
|-----------|---------------|
| `r` | Read (lecture) |
| `w` | Write (ecriture) |
| `x` | Execute (execution) |
| `m` | Memory map (mappage memoire) |
| `k` | Lock (verrouillage) |
| `l` | Link (lien) |
| `ix` | Execute + herite profil parent |
| `Px` | Execute + transition profil specifique |
| `Ux` | Execute non confine |

### Wildcards (Globbing)

```apparmor
# * : N'importe quels caracteres sauf /
/tmp/*.log rw,

# ** : N'importe quels caracteres incluant / (recursif)
/var/log/myapp/** rw,

# ? : Exactement 1 caractere
/tmp/file?.txt r,

# [abc] : Un caractere parmi a, b ou c
/tmp/file[123].txt r,

# Variables
owner @{HOME}/.mozilla/** rw,
```

### Modes de Profil

| Mode | Description |
|------|-------------|
| **Enforce** | Violations bloquees et journalisees |
| **Complain** | Violations autorisees mais journalisees |
| **Disabled** | Profil non charge |

### Commandes de Gestion

```bash
# Voir l'etat de tous les profils
sudo aa-status

# Mettre en mode enforce
sudo aa-enforce /usr/bin/nginx

# Mettre en mode complain
sudo aa-complain /usr/bin/nginx

# Desactiver un profil
sudo aa-disable /usr/bin/nginx
```

### Creer un Profil (Interactif)

```bash
# 1. Generer un profil en mode apprentissage
sudo aa-genprof /usr/bin/myapp

# 2. Dans un autre terminal, utiliser l'application
myapp --test

# 3. Revenir au terminal aa-genprof
# L'outil propose des regles basees sur l'activite detectee

# 4. Approuver/modifier les regles

# 5. Sauvegarder
```

---

## 11. Recharger les Profils AppArmor

### Recharger un Profil Specifique

```bash
# Methode 1 : apparmor_parser
sudo apparmor_parser -r /etc/apparmor.d/usr.bin.firefox

# Avec verbose
sudo apparmor_parser -rv /etc/apparmor.d/usr.bin.firefox

# -r : replace (recharger)
# -v : verbose
```

### Recharger Tous les Profils

```bash
# Methode 1 : systemctl reload
sudo systemctl reload apparmor

# Methode 2 : service
sudo service apparmor reload
```

### Redemarrer AppArmor Completement

```bash
sudo systemctl restart apparmor
```

### Valider un Profil sans le Charger

```bash
# Verifier la syntaxe
sudo apparmor_parser -QT /etc/apparmor.d/usr.bin.myapp

# -Q : skip kernel load
# -T : skip cache
```

### Workflow Typique de Modification

```bash
# 1. Editer le profil
sudo nano /etc/apparmor.d/usr.bin.nginx

# 2. Valider la syntaxe
sudo apparmor_parser -QT /etc/apparmor.d/usr.bin.nginx

# 3. Recharger le profil
sudo apparmor_parser -r /etc/apparmor.d/usr.bin.nginx

# 4. Verifier
sudo aa-status | grep nginx
```

### Mettre a Jour depuis les Logs

```bash
# Analyser les violations et proposer des mises a jour
sudo aa-logprof

# L'outil affiche les violations et propose d'ajouter les regles
# Options :
# (A)llow : Ajouter la regle
# (D)eny : Interdire explicitement
# (I)gnore : Ne rien faire
# (G)lob : Utiliser un wildcard
```

---

## 12. Le Principe du Moindre Privilege

### Definition

> Chaque processus doit avoir **uniquement** les permissions minimales strictement necessaires pour accomplir sa tache, **rien de plus**.

### Application dans MAC

**Sans MAC (DAC seul) :**
```bash
# Apache demarre en root, puis drop privileges
# Mais vulnerabilites avant le drop
# Acces aux fichiers bases sur rwx uniquement
```

**Avec MAC (SELinux/AppArmor) :**
```bash
# Apache confine des le depart
# Peut UNIQUEMENT acceder aux ressources explicitement autorisees
# Meme root ne peut pas contourner
```

### Exemple SELinux

```bash
# Processus Apache (httpd_t)
CAN:
  - Lire /var/www/html/ (httpd_sys_content_t)
  - Ecrire /var/log/httpd/ (httpd_log_t)
  - Se connecter aux ports 80, 443 (http_port_t)

CANNOT:
  - Lire /etc/shadow (shadow_t)
  - Ecrire /home/user/ (user_home_t)
  - Se connecter au port 22 (ssh_port_t)
  - Executer /bin/bash (shell_exec_t)
```

### Exemple AppArmor

```apparmor
/usr/bin/firefox {
  # Peut lire config
  /etc/firefox/** r,

  # Peut ecrire dans profil utilisateur
  owner @{HOME}/.mozilla/** rw,

  # NE PEUT PAS acceder a :
  deny @{HOME}/.ssh/** rw,
  deny @{HOME}/.gnupg/** rw,
  deny /etc/passwd w,
  deny /etc/shadow rw,
}
```

### Avantages

1. **Limitation des degats**
   - Un processus compromis ne peut acceder qu'a ses ressources autorisees

2. **Isolation**
   - Un service web pirate ne peut pas lire les fichiers d'un autre service

3. **Protection contre l'escalade**
   - Meme avec root, impossible de sortir du confinement MAC

4. **Conformite**
   - Satisfait les exigences de securite (PCI-DSS, HIPAA)

### Mise en Pratique

**Etape 1 : Identifier le strict necessaire**
```bash
# Qu'est-ce que l'application DOIT faire ?
- Lire sa configuration
- Ecrire ses logs
- Acceder a son port reseau
```

**Etape 2 : Creer une politique restrictive**
```bash
# SELinux : Definir les types et regles minimales
# AppArmor : Creer un profil avec permissions minimales
```

**Etape 3 : Tester et ajuster**
```bash
# Mode permissive/complain pour detecter les besoins reels
# Ajouter uniquement ce qui est necessaire
```

---

## 13. Depannage SELinux

### Methodologie en 5 Etapes

#### Etape 1 : Confirmer que SELinux est la Cause

```bash
# Verifier le mode
sudo getenforce
# Output: Enforcing

# Passer temporairement en Permissive
sudo setenforce 0

# Tester l'application
# Si ca fonctionne → Probleme SELinux confirme

# Remettre en Enforcing
sudo setenforce 1
```

#### Etape 2 : Analyser les Logs

```bash
# Logs d'audit
sudo tail -f /var/log/audit/audit.log | grep denied

# Recherche recente
sudo ausearch -m avc -ts recent

# Filtrer par processus
sudo ausearch -m avc -c httpd
```

**Format d'un message AVC :**
```
type=AVC msg=audit(1234567890.123:456): avc: denied { read } for pid=1234 comm="httpd" name="index.html" scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file
```

**Decodage :**
- `denied { read }` : Action refusee
- `comm="httpd"` : Processus Apache
- `scontext=...httpd_t` : Contexte source (processus)
- `tcontext=...user_home_t` : Contexte cible (fichier)

#### Etape 3 : Utiliser sealert

```bash
# Installer setroubleshoot
sudo dnf install setroubleshoot setroubleshoot-server

# Analyser les logs
sudo sealert -a /var/log/audit/audit.log
```

**Sortie sealert (exemple) :**
```
SELinux is preventing httpd from read access on the file index.html.

*****  Plugin catchall suggests:

If you want to allow httpd to have read access on the index.html file,
you need to change the file context:
# semanage fcontext -a -t httpd_sys_content_t '/path/to/index.html'
# restorecon -v '/path/to/index.html'
```

#### Etape 4 : Appliquer la Solution

**Option A : Corriger le Contexte**
```bash
sudo restorecon -Rv /var/www/html/
```

**Option B : Activer un Booleen**
```bash
# Lister les booleens suggeres
getsebool -a | grep httpd

# Activer
sudo setsebool -P httpd_enable_homedirs on
```

**Option C : Creer une Politique Personnalisee**
```bash
# Generer le module
sudo grep httpd /var/log/audit/audit.log | audit2allow -M my-httpd

# Installer
sudo semodule -i my-httpd.pp
```

#### Etape 5 : Verifier et Tester

```bash
# Verifier que le probleme est resolu
# Verifier les logs
sudo ausearch -m avc -ts recent

# Tester l'application
```

### Outils de Depannage

| Outil | Usage |
|-------|-------|
| `ausearch` | Rechercher dans audit.log |
| `sealert` | Analyser et suggerer des solutions |
| `audit2allow` | Generer des regles de politique |
| `audit2why` | Expliquer pourquoi un acces est refuse |

### Exemple Complet

**Probleme :** Apache ne peut pas lire `/srv/web/index.html`

```bash
# 1. Verifier le contexte
ls -Z /srv/web/index.html
unconfined_u:object_r:default_t:s0 index.html  # MAUVAIS contexte

# 2. Verifier les logs
sudo ausearch -m avc -c httpd | tail -5

# 3. Corriger le contexte
sudo semanage fcontext -a -t httpd_sys_content_t "/srv/web(/.*)?"
sudo restorecon -Rv /srv/web/

# 4. Verifier
ls -Z /srv/web/index.html
system_u:object_r:httpd_sys_content_t:s0 index.html  # BON contexte
```

---

## 14. Importance des Logs d'Audit

### Role des Logs d'Audit dans MAC

#### 1. Detection des Violations

**Enregistrement complet :**
- Qui (processus/utilisateur)
- Quoi (ressource ciblee)
- Quand (timestamp)
- Pourquoi refuse (contextes source/cible)

**Exemple de log :**
```
type=AVC msg=audit(1610000000.123:456): avc: denied { write } for pid=1234 comm="nginx" name="upload.txt" dev="sda1" ino=67890 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:user_home_t:s0 tclass=file permissive=0
```

#### 2. Forensics (Analyse Post-Incident)

**Reconstruction d'une attaque :**
```bash
# Timeline complete des acces refuses
sudo ausearch -m avc -ts 01/15/2025 00:00:00 -te 01/15/2025 23:59:59

# Activites suspectes
sudo ausearch -m avc | grep "denied" | grep "/etc/shadow"
```

#### 3. Tuning de la Politique

**Identifier les besoins reels :**
```bash
# Application en mode permissive
sudo setenforce 0

# Observer pendant 24h
sudo ausearch -m avc -ts recent > violations.log

# Creer une politique adaptee
sudo audit2allow -i violations.log -M app-policy
```

#### 4. Conformite et Audit

**Preuves pour audits :**
- PCI-DSS : Logs d'acces aux donnees de cartes
- HIPAA : Logs d'acces aux donnees medicales
- SOC 2 : Controles d'acces effectifs

### Localisation des Logs

```bash
# Logs SELinux
/var/log/audit/audit.log

# Logs AppArmor
/var/log/syslog           # Ubuntu/Debian
/var/log/audit/audit.log  # Si auditd installe
```

### Commandes de Consultation

```bash
# Derniers refus SELinux
sudo ausearch -m avc -ts recent

# Filtrer par processus
sudo ausearch -m avc -c httpd

# Filtrer par fichier
sudo ausearch -m avc | grep "/etc/shadow"

# Stats
sudo ausearch -m avc --start today | wc -l
```

### Bonnes Pratiques

1. **Rotation des logs**
```bash
sudo logrotate /etc/logrotate.d/audit
```

2. **Centralisation**
```bash
# Envoyer vers un serveur syslog central
sudo auditctl -w /etc/selinux/ -p wa -k selinux_changes
```

3. **Alertes temps reel**
```bash
# Surveiller les violations
sudo tail -f /var/log/audit/audit.log | grep -i denied
```

4. **Archivage**
```bash
# Conserver 90 jours minimum pour conformite
```

---

## 15. Les Capacites Linux

### Concept

Les **capacites** (capabilities) divisent les privileges root en **unites granulaires**.

**Probleme traditionnel :**
```
Processus standard : Aucun privilege
Processus root     : TOUS les privileges
```

**Solution avec capabilities :**
```
Accorder uniquement les privileges specifiques necessaires
```

### Liste des Capacites Principales

| Capacite | Description | Exemple |
|----------|-------------|---------|
| `CAP_NET_BIND_SERVICE` | Lier un port < 1024 | Nginx sur port 80 |
| `CAP_NET_RAW` | Sockets RAW | ping, traceroute |
| `CAP_SETUID` | Changer UID | su, sudo |
| `CAP_SETGID` | Changer GID | su, sudo |
| `CAP_DAC_OVERRIDE` | Ignorer permissions DAC | Backup |
| `CAP_DAC_READ_SEARCH` | Lire tous fichiers | Indexation |
| `CAP_CHOWN` | Changer proprietaire | chown |
| `CAP_SYS_ADMIN` | Operations admin | mount |
| `CAP_SYS_TIME` | Modifier horloge | ntpd |
| `CAP_NET_ADMIN` | Config reseau | iptables |

### Visualiser les Capacites

**D'un fichier :**
```bash
# Installer
sudo apt install libcap2-bin  # Debian/Ubuntu
sudo dnf install libcap        # RHEL/Fedora

# Lister
getcap /usr/bin/ping
/usr/bin/ping = cap_net_raw+ep
```

**D'un processus :**
```bash
# Via /proc
cat /proc/$PID/status | grep Cap

# Decoder
capsh --decode=0000000000003c00

# Avec getpcaps
getpcaps $PID
```

### Definir des Capacites

```bash
# Ajouter une capacite
sudo setcap cap_net_bind_service=+ep /usr/bin/myserver

# Plusieurs capacites
sudo setcap cap_net_bind_service,cap_net_raw=+ep /usr/bin/myapp

# Supprimer toutes les capacites
sudo setcap -r /usr/bin/myapp
```

**Flags :**
- `e` : Effective (active)
- `p` : Permitted (autorisee)
- `i` : Inheritable (transmise aux enfants)

### Exemple Pratique : Nginx sans Root

**Probleme :** Nginx doit lier le port 80 (< 1024) sans root complet

**Solution traditionnelle (mauvaise) :**
```bash
# Demarrer en root, puis drop privileges
sudo nginx
```

**Solution avec capabilities :**
```bash
# 1. Donner la capacite
sudo setcap cap_net_bind_service=+ep /usr/sbin/nginx

# 2. Demarrer en tant qu'utilisateur normal
nginx

# 3. Verifier
ps aux | grep nginx
www-data  1234  nginx  # Pas root !
```

### Integration avec AppArmor

```apparmor
/usr/bin/nginx {
  capability net_bind_service,  # Port 80
  capability setuid,             # Changer UID
  capability setgid,             # Changer GID

  # Fichiers
  /etc/nginx/** r,
  /var/www/** r,
}
```

---

## 16. Utiliser semanage

### Qu'est-ce que semanage ?

`semanage` est l'outil de gestion de la **configuration persistante** de SELinux.

**Difference avec chcon :**
- `chcon` : Modifications temporaires (perdues apres restorecon)
- `semanage` : Modifications persistantes (survit aux re-etiquetages)

### Installation

```bash
# RHEL/Fedora/CentOS
sudo dnf install policycoreutils-python-utils

# Debian/Ubuntu
sudo apt install policycoreutils-python-utils
```

### Gestion des Contextes de Fichiers

#### Lister les Regles

```bash
# Toutes les regles
sudo semanage fcontext -l

# Filtrer
sudo semanage fcontext -l | grep httpd

# Regles personnalisees uniquement
sudo semanage fcontext -l -C
```

#### Ajouter une Regle

```bash
# Syntaxe
sudo semanage fcontext -a -t TYPE "PATTERN"

# Exemple
sudo semanage fcontext -a -t httpd_sys_content_t "/srv/web(/.*)?"

# Appliquer
sudo restorecon -Rv /srv/web/
```

#### Modifier une Regle

```bash
sudo semanage fcontext -m -t NEW_TYPE "PATTERN"
```

#### Supprimer une Regle

```bash
sudo semanage fcontext -d "/srv/web(/.*)?"
```

### Gestion des Ports

#### Lister les Ports

```bash
# Tous
sudo semanage port -l

# Filtrer
sudo semanage port -l | grep http
http_port_t      tcp      80, 443, 488, 8008, 8009, 8443
```

#### Ajouter un Port

```bash
# Apache sur port 8080
sudo semanage port -a -t http_port_t -p tcp 8080
```

#### Supprimer un Port

```bash
sudo semanage port -d -t http_port_t -p tcp 8080
```

#### Modifier un Port

```bash
sudo semanage port -m -t http_port_t -p tcp 8080
```

### Gestion des Booleens

```bash
# Lister
sudo semanage boolean -l

# Avec description
sudo semanage boolean -l | grep httpd_enable_homedirs
httpd_enable_homedirs (off , off)  Allow httpd to read home directories
```

### Gestion des Utilisateurs SELinux

#### Lister les Utilisateurs

```bash
sudo semanage user -l
```

#### Mapper un Utilisateur Linux

```bash
# Mapper alice a user_u
sudo semanage login -a -s user_u alice

# Lister les mappings
sudo semanage login -l
```

### Gestion des Interfaces Reseau

```bash
# Lister
sudo semanage interface -l

# Ajouter
sudo semanage interface -a -t netif_t -r s0 eth0
```

### Exemples Pratiques

#### Scenario 1 : Nouveau Repertoire Web

```bash
# 1. Definir le contexte par defaut
sudo semanage fcontext -a -t httpd_sys_content_t "/custom-web(/.*)?"

# 2. Appliquer
sudo restorecon -Rv /custom-web/

# 3. Verifier
sudo semanage fcontext -l | grep custom-web
ls -Z /custom-web/
```

#### Scenario 2 : Serveur sur Port Non Standard

```bash
# Apache sur port 8888
sudo semanage port -a -t http_port_t -p tcp 8888

# Verifier
sudo semanage port -l | grep 8888
http_port_t      tcp      80, 443, 8888
```

#### Scenario 3 : Confiner un Utilisateur

```bash
# Mapper bob a user_u (utilisateur confine)
sudo semanage login -a -s user_u bob

# bob ne pourra executer que les domaines autorises pour user_u
```

### Options Importantes

| Option | Description |
|--------|-------------|
| `-a` | Add (ajouter) |
| `-d` | Delete (supprimer) |
| `-m` | Modify (modifier) |
| `-l` | List (lister) |
| `-C` | Customized only (personnalises uniquement) |
| `-t` | Type |
| `-s` | SELinux user |
| `-p` | Protocol |
| `-r` | Range (niveau MLS) |

---

## Ressources Supplementaires

### Documentation Officielle

**SELinux :**
- [Red Hat SELinux Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/)
- [SELinux Project](https://github.com/SELinuxProject)
- [Fedora SELinux FAQ](https://docs.fedoraproject.org/en-US/quick-docs/getting-started-with-selinux/)

**AppArmor :**
- [Ubuntu AppArmor Docs](https://ubuntu.com/server/docs/security-apparmor)
- [AppArmor Wiki](https://gitlab.com/apparmor/apparmor/-/wikis/home)

### Livres

- "SELinux System Administration" - Sven Vermeulen
- "The SELinux Notebook" - Richard Haines

### Outils

**SELinux :**
- `setools` : Analyse de politiques
- `selinux-policy-doc` : Documentation
- `setroubleshoot` : Depannage

**AppArmor :**
- `apparmor-utils` : Outils admin
- `apparmor-profiles` : Profils additionnels

---

**Document cree pour Holberton School - Cyber Security**
**Projet : 0x02. Mandatory Access Control**
