# 🕵️ Passive Reconnaissance - Network Security

![Security](https://img.shields.io/badge/Security-Network-blue?style=for-the-badge&logo=security&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Script-green?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Compatible-yellow?style=for-the-badge&logo=linux&logoColor=white)

## 📋 Description

Ce projet fait partie du cursus **Holberton School Cyber Security** et se concentre sur les techniques de **reconnaissance passive**. La reconnaissance passive consiste à collecter des informations sur une cible sans interagir directement avec elle, en utilisant des sources publiques et des outils tiers.

## 🎯 Objectifs d'apprentissage

À la fin de ce projet, vous devriez être capable d'expliquer :
- 🔍 Les concepts de base de la reconnaissance passive
- 📊 Comment utiliser les outils OSINT (Open Source Intelligence)
- 🌐 Les différents types d'enregistrements DNS
- 🛡️ L'importance de la collecte d'informations dans la cybersécurité

## 📂 Structure du projet

```
0x01_passive_reconnaissance/
├── 📄 0-whois.sh          # Extraction d'informations WHOIS
├── 📄 1-a_record.sh       # Recherche d'enregistrements A
├── 📄 2-mx_record.sh      # Recherche d'enregistrements MX
├── 📄 3-txt_record.sh     # Recherche d'enregistrements TXT
├── 📄 4-dig_all.sh        # Analyse DNS complète
├── 📄 5-subfinder.sh      # Découverte de sous-domaines
├── 📁 100-flag.txt        # Challenge Flag 1
├── 📁 101-flag.txt        # Challenge Flag 2
├── 📁 102-flag.txt        # Challenge Flag 3
└── 📊 Fichiers de résultats (.csv, .txt, .md)
```

## 🛠️ Outils et Scripts

### 🔎 0-whois.sh
```bash
#!/bin/bash
whois $1|awk -F': ' '/^(Registrant|Admin|Tech) /{print $1"," $2}'>$1.csv
```
**Utilisation :** `./0-whois.sh example.com`
- Extrait les informations WHOIS d'un domaine
- Filtre les contacts Registrant, Admin et Tech
- Sauvegarde au format CSV

### 🌐 1-a_record.sh
```bash
#!/bin/bash
nslookup -type=a $1 8.8.8.8
```
**Utilisation :** `./1-a_record.sh example.com`
- Recherche les enregistrements A (adresses IPv4)
- Utilise le serveur DNS public de Google (8.8.8.8)

### 📧 2-mx_record.sh
```bash
#!/bin/bash
nslookup -type=mx $1 8.8.8.8
```
**Utilisation :** `./2-mx_record.sh example.com`
- Recherche les enregistrements MX (serveurs de messagerie)
- Révèle l'infrastructure email du domaine

### 📝 3-txt_record.sh
```bash
#!/bin/bash
nslookup -type=txt $1 8.8.8.8
```
**Utilisation :** `./3-txt_record.sh example.com`
- Recherche les enregistrements TXT
- Peut révéler des configurations SPF, DKIM, etc.

### 🔍 5-subfinder.sh
```bash
#!/bin/bash
subfinder -silent -d $1 -o $1.txt -nW -oI
```
**Utilisation :** `./5-subfinder.sh example.com`
- Découvre les sous-domaines automatiquement
- Utilise l'outil Subfinder pour l'énumération

## 🚀 Installation et Configuration

### Prérequis
```bash
# Installer les outils nécessaires
sudo apt update
sudo apt install dnsutils whois

# Installer Subfinder
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
```

### Permissions d'exécution
```bash
chmod +x *.sh
```

## 📋 Utilisation

### Exemple complet d'analyse
```bash
# Analyse complète d'un domaine
./0-whois.sh holbertonschool.com
./1-a_record.sh holbertonschool.com
./2-mx_record.sh holbertonschool.com
./3-txt_record.sh holbertonschool.com
./5-subfinder.sh holbertonschool.com
```

### Résultats attendus
- 📊 Fichiers CSV avec informations WHOIS
- 📄 Fichiers texte avec sous-domaines découverts
- 🖥️ Sortie console avec enregistrements DNS

## 🛡️ Considérations éthiques

> ⚠️ **Important** : Ces outils sont destinés à des fins éducatives et de sécurité défensive uniquement.

- ✅ **Autorisé** : Tests sur vos propres domaines
- ✅ **Autorisé** : Recherche académique et apprentissage
- ✅ **Autorisé** : Tests d'autorisation dans un cadre professionnel
- ❌ **Interdit** : Reconnaissance non autorisée
- ❌ **Interdit** : Utilisation malveillante

## 📊 Exemples de sortie

### WHOIS Information
```csv
Registrant Name, John Doe
Admin Email, admin@example.com
Tech Phone, +1.1234567890
```

### Enregistrements DNS
```
example.com.		300	IN	A	192.0.2.1
example.com.		300	IN	MX	10 mail.example.com.
```

## 🔗 Ressources utiles

- 📖 [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- 🛠️ [Subfinder Documentation](https://github.com/projectdiscovery/subfinder)
- 📚 [DNS Record Types](https://www.cloudflare.com/learning/dns/dns-records/)
- 🔍 [OSINT Framework](https://osintframework.com/)

## 👥 Auteur

**Holberton School Cyber Security Program**
- 📧 Contact : École de cybersécurité
- 🎓 Projet pédagogique - Sécurité réseau

## 📄 License

Ce projet est destiné à des fins éducatives dans le cadre du programme Holberton School.

---

<div align="center">

**🔐 "La connaissance est la meilleure défense" 🔐**

![Made with ❤️](https://img.shields.io/badge/Made%20with-❤️-red?style=for-the-badge)
![Holberton](https://img.shields.io/badge/Holberton-School-orange?style=for-the-badge)

</div>