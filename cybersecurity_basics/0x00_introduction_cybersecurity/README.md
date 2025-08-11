# 🛡️ 0x00. Introduction to Cybersecurity

<div align="center">

![Cybersecurity](https://img.shields.io/badge/Cybersecurity-Introduction-red?style=for-the-badge&logo=security&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Scripts-green?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04-orange?style=for-the-badge&logo=ubuntu&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

</div>

## 📖 Description
Ce projet fait partie du curriculum de cybersécurité de **Holberton School**. Il couvre les concepts fondamentaux de sécurité informatique à travers des scripts bash pratiques qui démontrent diverses techniques de sécurité essentielles.

## 🎯 Objectifs d'apprentissage
À la fin de ce projet, vous devriez être capable d'expliquer :
- 🔍 Comment identifier la version du système d'exploitation
- 🔐 Les techniques de génération de mots de passe sécurisés
- ✅ La validation d'intégrité de fichiers avec SHA256
- 🔑 La génération et gestion de clés SSH
- ⚙️ L'identification des processus système critiques

## 🖥️ Environnement
- **OS** : Ubuntu 20.04 LTS 🐧
- **Shell** : Bash 💻
- **Style** : Scripts conformes aux standards Holberton ✨

## 📂 Liste des fichiers

### 🆔 0-release.sh
> **🎯 Mission** : Script qui affiche la distribution Linux utilisée  
> **🚀 Usage** : `./0-release.sh`  
> **📤 Sortie** : Nom de la distribution (ex: Ubuntu)

### 🔑 1-gen_password.sh
> **🎯 Mission** : Générateur de mots de passe aléatoires sécurisés  
> **🚀 Usage** : `./1-gen_password.sh [longueur]`  
> **⚙️ Paramètres** :
> - `longueur` (optionnel) : Nombre de caractères du mot de passe (défaut: 20)
> 
> **🔒 Caractéristiques** :
> - ✅ Utilise uniquement des caractères alphanumériques
> - 🎲 Source d'entropie : `/dev/urandom`
> - 🛡️ Pas de caractères spéciaux pour éviter les problèmes d'échappement

### 📊 2-sha256_validator.sh
> **🎯 Mission** : Validateur d'intégrité de fichiers utilisant SHA256  
> **🚀 Usage** : `./2-sha256_validator.sh <fichier> <hash_attendu>`  
> **⚙️ Paramètres** :
> - `fichier` : Chemin vers le fichier à vérifier
> - `hash_attendu` : Hash SHA256 attendu en hexadécimal
> 
> **📤 Sortie** : 
> - ✅ `<fichier>: OK` si le hash correspond
> - ❌ `<fichier>: FAILED` si le hash ne correspond pas

### 🔐 3-gen_key.sh
> **🎯 Mission** : Générateur de paires de clés SSH RSA  
> **🚀 Usage** : `./3-gen_key.sh <nom_clé>`  
> **⚙️ Paramètres** :
> - `nom_clé` : Nom de base pour les fichiers de clés
> 
> **🔒 Caractéristiques** :
> - 🔢 Génère une clé RSA de 4096 bits
> - 🚫 Pas de phrase de passe (pour l'automatisation)
> - 📁 Crée deux fichiers : `<nom_clé>` (privée) et `<nom_clé>.pub` (publique)

### 👁️ 4-root_process.sh
> **🎯 Mission** : Identifie les processus tournant avec des privilèges spécifiques  
> **🚀 Usage** : `./4-root_process.sh <utilisateur>`  
> **⚙️ Paramètres** :
> - `utilisateur` : Nom d'utilisateur dont on veut lister les processus
> 
> **🧠 Fonctionnalité** : Exclut les processus kernel (PID 0, PPID 0)

## 📁 Fichiers auxiliaires

### 🔐 new_key / new_key.pub
> **📝 Description** : Exemple de paire de clés SSH générée par le script `3-gen_key.sh`

### 🧪 test_file
> **📝 Description** : Fichier de test vide utilisé pour les démonstrations de validation SHA256

---

## 🚀 Installation et utilisation

### 1️⃣ **Cloner le repository** :
```bash
git clone https://github.com/Pmichel74/holbertonschool-cyber_security.git
cd holbertonschool-cyber_security/cybersecurity_basics/0x00_introduction_cybersecurity
```

### 2️⃣ **Rendre les scripts exécutables** :
```bash
chmod +x *.sh
```

### 3️⃣ **Exemples d'utilisation** :

<details>
<summary>🔍 <strong>Identifier la distribution</strong></summary>

```bash
./0-release.sh
# Sortie : Ubuntu
```
</details>

<details>
<summary>🔐 <strong>Générer un mot de passe de 32 caractères</strong></summary>

```bash
./1-gen_password.sh 32
# Sortie : 8kF9mN2pQ7xR5tY1wE3nI6oU4sA0hG2z
```
</details>

<details>
<summary>✅ <strong>Valider un fichier avec son hash SHA256</strong></summary>

```bash
./2-sha256_validator.sh test_file e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
# Sortie : test_file: OK
```
</details>

<details>
<summary>🔑 <strong>Générer une nouvelle paire de clés SSH</strong></summary>

```bash
./3-gen_key.sh ma_nouvelle_cle
# Crée : ma_nouvelle_cle (privée) + ma_nouvelle_cle.pub (publique)
```
</details>

<details>
<summary>👁️ <strong>Lister les processus de l'utilisateur root</strong></summary>

```bash
./4-root_process.sh root
# Affiche tous les processus de root (sauf kernel)
```
</details>

---

## 🧠 Concepts de sécurité abordés

<table>
<tr>
<td align="center">
<h3>🔍 Identification du système</h3>
<p>• Reconnaissance de l'environnement<br>
• Fingerprinting passif<br>
• Collecte d'informations système</p>
</td>
<td align="center">
<h3>🔐 Génération de mots de passe</h3>
<p>• Entropie cryptographique<br>
• Sources de randomness sécurisées<br>
• Bonnes pratiques de génération</p>
</td>
</tr>
<tr>
<td align="center">
<h3>✅ Intégrité des données</h3>
<p>• Fonctions de hachage cryptographiques<br>
• Validation d'intégrité<br>
• Détection de tampering</p>
</td>
<td align="center">
<h3>🔑 Cryptographie asymétrique</h3>
<p>• Paires de clés publique/privée<br>
• Authentification SSH<br>
• Gestion des clés</p>
</td>
</tr>
<tr>
<td align="center" colspan="2">
<h3>⚙️ Analyse des processus</h3>
<p>• Monitoring système • Identification des services critiques • Analyse de sécurité</p>
</td>
</tr>
</table>

---

## ⚠️ Sécurité et bonnes pratiques

<div align="center">

| ⚠️ **Avertissements de sécurité** |
|---|
| 🚫 Les clés SSH générées sans phrase de passe sont moins sécurisées |
| 🔒 Protégez toujours vos clés privées (permissions 600) |
| 🙅‍♂️ Ne partagez jamais vos clés privées |
| 💪 Utilisez des mots de passe forts en production |
| ✅ Validez toujours l'intégrité des fichiers critiques |

</div>

---

## 👨‍💻 Auteur

<div align="center">

**Patrick Michel** 🚀  
[![GitHub](https://img.shields.io/badge/GitHub-Pmichel74-black?style=for-the-badge&logo=github)](https://github.com/Pmichel74)

</div>

---

## 🏫 Projet

<div align="center">

**Holberton School** - Cybersecurity Specialization  
**🛡️ 0x00. Introduction to Cybersecurity**

[![Made with ❤️](https://img.shields.io/badge/Made%20with-❤️-red?style=for-the-badge)](https://github.com/Pmichel74)
[![Holberton](https://img.shields.io/badge/Holberton-School-blue?style=for-the-badge&logo=holberton&logoColor=white)](https://www.holbertonschool.com/)

</div>