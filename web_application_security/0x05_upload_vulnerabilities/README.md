# 0x05. Upload Vulnerabilities 🚀

## 📖 Description

Ce projet explore les vulnérabilités liées au téléchargement de fichiers dans les applications web. Vous apprendrez à identifier et exploiter différents types de failles de sécurité dans les mécanismes d'upload.

**Objectifs du projet :**
- 🎯 Identifier les failles de sécurité dans les mécanismes d'upload
- 🔐 Contourner différentes protections (client-side, server-side, validation de contenu)
- 🏆 Récupérer des flags cachés en exploitant ces vulnérabilités
- 💡 Comprendre les bonnes pratiques de sécurisation

## 🌐 Informations sur l'environnement

- 🎯 **Machine cible**: Cyber - WebSec 0x05
- 🌍 **Domaine principal**: http://web0x05.hbtn
- 🏁 **Objectif**: Trouver et exploiter les vulnérabilités de téléchargement de fichiers pour récupérer des flags

## 📚 Ressources utiles

Avant de commencer votre aventure, prenez le temps de vous familiariser avec :

- ✅ Les mécanismes de validation côté client et serveur
- 📁 Les types MIME et les extensions de fichiers
- 🔢 Les magic numbers (signatures de fichiers)
- 🛠️ Les outils de test de sécurité web (Burp Suite, navigateur developer tools)
- 🎭 Les techniques de contournement de filtres
- 🎨 Les caractères spéciaux et leur interprétation par les serveurs web
- 📡 La manipulation de requêtes HTTP

## 🎮 Les Missions

### 🎯 Mission 0 : La Chasse au Sous-domaine Vulnérable
**📄 Fichier**: `0-target.txt`

**🎭 Objectif**: Trouver le sous-domaine qui cache une application web avec une fonctionnalité d'upload non sécurisée !

**📝 Votre mission**:
C'est parti pour l'aventure ! Vous devez explorer méthodiquement tous les sous-domaines pour dénicher celui qui contient une interface de téléchargement de fichiers vulnérable. C'est comme chercher un trésor caché ! 🗺️

**💡 Exemple de ce que vous devez trouver**:
```bash
$ cat 0-target.txt
up3l0d3r.web0x05.hbtn
```

**🔍 Conseils pour réussir**:
1. 🤖 Utilisez des outils d'énumération automatisés (subdomain scanners, web crawlers) pour gagner du temps
2. 👀 Inspectez manuellement chaque sous-domaine prometteur et testez un upload simple (un fichier .txt par exemple)
3. 📝 Gardez un carnet de notes détaillé de vos découvertes - un bon hacker est organisé !

---

### 🎯 Mission 1 : Le JavaScript ne Suffit Pas !
**📄 Fichier**: `1-flag.txt`

**🎭 Objectif**: Contourner les filtres côté client pour uploader un fichier interdit et récupérer votre premier flag ! ⛳️

**📝 Le Challenge**:
Maintenant que vous avez trouvé le sous-domaine vulnérable, il est temps de montrer vos talents ! L'application utilise du JavaScript pour filtrer les fichiers... mais vous savez que le JavaScript peut être contourné, n'est-ce pas ? 😏

**🔧 Informations techniques**:
- 🎯 **Endpoint cible**: http://[vuln-subdomain].web0x05.hbtn/task1
- 💻 **Commande PHP magique**: `<?php readfile('FLAG_1.txt') ?>`
- ⚠️ **Important**: Le FLAG n'apparaîtra que si vous uploadez un fichier PHP !

**💡 Astuces de pro**:
1. 🔍 Ouvrez les DevTools de votre navigateur (F12) et inspectez le code JavaScript - que cherche-t-il exactement ?
2. 🌐 Burp Suite est votre ami ! Interceptez la requête et modifiez le nom du fichier ou le type MIME
3. 🎨 Testez le drag & drop - parfois il contourne les validations !
4. 👂 Écoutez les messages d'erreur du serveur - ils parlent beaucoup !

---

### 🎯 Mission 2 : Les Caractères Spéciaux à la Rescousse !
**📄 Fichier**: `2-flag.txt`

**🎭 Objectif**: Utiliser des caractères spéciaux pour tromper la validation serveur ! 🎭

**📝 Le Défi**:
Bravo ! Vous avez passé le côté client ! 🎉 Mais attention, le serveur est plus malin et vérifie vraiment vos fichiers. Il va falloir ruser avec des caractères spéciaux dans le nom du fichier pour le piéger ! C'est l'art de la manipulation subtile... 🎨

**🔧 Informations techniques**:
- 🎯 **Endpoint cible**: http://[vuln-subdomain].web0x05.hbtn/task2
- 💻 **Commande PHP magique**: `<?php readfile('FLAG_2.txt') ?>`
- ⚠️ **Important**: Seul un fichier PHP vous donnera le flag !

**💡 Stratégies gagnantes**:
1. 🧪 Expérimentez ! Essayez des espaces, des points multiples, ou des null bytes (`%00`)
2. 🎯 Exemple : `payload.php.jpg` vs `payload.php%00.jpg` - lequel passera ?
3. 🔧 Burp Suite est encore votre meilleur allié pour crafting des requêtes
4. 👀 Surveillez attentivement les réponses du serveur - parfois le succès n'est pas évident !

---

### 🎯 Mission 3 : Le Mystère des Magic Numbers ! 🔮
**📄 Fichier**: `3-flag.txt`

**🎭 Objectif**: Maîtriser l'art de la manipulation des signatures de fichiers !

**📝 L'Épreuve Ultime**:
Vous voilà face au boss de niveau ! 🎮 Le serveur ne se contente plus de regarder le nom - il inspecte le CONTENU même du fichier via les magic numbers. Il faut créer un fichier hybride : innocent en apparence, mais malveillant dans l'âme ! 😈

**🔧 Informations techniques**:
- 🎯 **Endpoint cible**: http://[vuln-subdomain].web0x05.hbtn/task3
- 💻 **Commande PHP magique**: `<?php readfile('FLAG_3.txt') ?>`
- ⚠️ **Important**: Le PHP est la clé du succès !

**💡 Techniques de ninja**:
1. 📚 Étudiez les magic numbers : chaque format a sa signature unique (PNG, JPG, PDF, etc.)
2. 🔨 Utilisez un éditeur hexadécimal (HxD, hexedit) pour modifier les premiers octets de votre fichier
3. 🎭 Créez un Frankenstein : signature d'image + code PHP !
4. 🧪 Testez, testez, testez ! La patience est une vertu

---

### 🎯 Mission 4 : La Taille, Ça Compte ? 📏
**📄 Fichier**: `4-flag.txt`

**🎭 Objectif**: Contourner les restrictions de taille de fichier !

**📝 Le Challenge Final**:
Dernière épreuve ! Le serveur impose des limites strictes sur la taille des fichiers. Mais attendez... il y a aussi une backdoor cachée dans les headers HTTP ! 🕵️ Double challenge, double récompense !

**🔧 Informations techniques**:
- 🎯 **Endpoint cible**: http://[vuln-subdomain].web0x05.hbtn/task4
- 🎁 **Bonus caché**: Inspectez les en-têtes de réponse HTTP - une surprise vous attend !
- 💻 **Commande PHP magique**: `<?php readfile('FLAG_4.txt') ?>`
- ⚠️ **Important**: Toujours du PHP !

**💡 Tactiques avancées**:
1. 📊 Testez différentes tailles pour trouver la limite exacte
2. 🗜️ La compression est votre amie ! Explorez les formats qui compressent bien
3. 🔍 Cherchez des endpoints alternatifs (APIs, formulaires legacy)
4. 🎭 Burp Suite pour manipuler les headers `Content-Length`
5. 👀 N'oubliez pas de regarder les headers de réponse !

---

## 📂 Structure du projet

```
web_application_security/0x05_upload_vulnerabilities/
├── README.md                 # Ce fichier
├── DOCUMENTATION.md          # Documentation technique détaillée
├── 0-target.txt             # Sous-domaine vulnérable identifié
├── 1-flag.txt               # Flag de la tâche 1 (bypass client-side)
├── 2-flag.txt               # Flag de la tâche 2 (caractères spéciaux)
├── 3-flag.txt               # Flag de la tâche 3 (magic numbers)
└── 4-flag.txt               # Flag de la tâche 4 (taille de fichier)
```

## Outils recommandés

- **Burp Suite**: Pour intercepter et modifier les requêtes HTTP
- **Browser Developer Tools**: Pour analyser le code JavaScript côté client
- **HxD ou tout éditeur hexadécimal**: Pour manipuler les magic numbers
- **cURL ou Postman**: Pour tester les requêtes HTTP personnalisées
- **Sublist3r, ffuf, ou gobuster**: Pour l'énumération de sous-domaines

## Prérequis

- Connaissance de base en sécurité web
- Compréhension des protocoles HTTP/HTTPS
- Familiarité avec les outils de test de pénétration web
- Connaissance de base de PHP
- Compréhension des formats de fichiers et des magic numbers

## Avertissement

Ce projet est à des fins éducatives uniquement. Ne testez ces techniques que sur des systèmes pour lesquels vous avez une autorisation explicite. L'utilisation de ces techniques sur des systèmes sans autorisation est illégale.

## Repository

- **GitHub repository**: holbertonschool-cyber_security
- **Directory**: web_application_security/0x05_upload_vulnerabilities

## Auteur

Holberton School - Cyber Security Program

---

**Note**: Assurez-vous de documenter toutes vos découvertes et méthodologies tout au long du projet. La compréhension des techniques est aussi importante que l'obtention des flags 