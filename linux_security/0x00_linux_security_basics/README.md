# 🐧 0x00. Linux Security Basics

<div align="center">

![Linux Security](https://img.shields.io/badge/Linux-Security-red?style=for-the-badge&logo=linux&logoColor=white)
![Network](https://img.shields.io/badge/Network-Monitoring-blue?style=for-the-badge&logo=wireshark&logoColor=white)
![Firewall](https://img.shields.io/badge/Firewall-UFW/iptables-orange?style=for-the-badge&logo=firewall&logoColor=white)
![Audit](https://img.shields.io/badge/System-Audit-green?style=for-the-badge&logo=security&logoColor=white)

</div>

## 📖 Description
Ce projet fait partie du curriculum de cybersécurité de **Holberton School**, spécialisé dans la sécurité Linux. Il couvre les concepts essentiels de sécurité système, surveillance réseau, configuration de pare-feu, et audit de sécurité à travers des scripts bash pratiques.

## 🎯 Objectifs d'apprentissage
À la fin de ce projet, vous devriez maîtriser :
- 📊 L'analyse des sessions de connexion et logs système
- 🌐 La surveillance des connexions réseau actives
- 🔥 La configuration et gestion des pare-feu (UFW/iptables)
- 🔍 L'audit de sécurité système avec Lynis
- 📡 La capture et analyse du trafic réseau
- 🗺️ La découverte réseau et scan de vulnérabilités

## 🖥️ Environnement
- **OS** : Ubuntu 20.04 LTS 🐧
- **Shell** : Bash 💻
- **Outils** : UFW, iptables, netstat, ss, tcpdump, nmap, lynis 🛠️
- **Privilèges** : sudo requis 🔐

---

## 📂 Liste des scripts

### 📋 0-login.sh
> **🎯 Mission** : Affiche les 5 dernières sessions de connexion avec dates et heures  
> **🚀 Usage** : `./0-login.sh`  
> **🔧 Commande** : `sudo last -F -5`  
> **📤 Sortie** : Historique détaillé des connexions utilisateurs

### 🌐 1-active-connections.sh
> **🎯 Mission** : Affiche toutes les connexions réseau actives avec informations des processus  
> **🚀 Usage** : `./1-active-connections.sh`  
> **🔧 Commande** : `sudo ss -tanp`  
> **📊 Fonctionnalités** :
> - ✅ Sockets TCP (-t)
> - 🔢 Adresses numériques (-n)
> - 🏷️ Processus associés (-p)
> - 📡 Ports d'écoute et connexions établies

### 🚪 2-incoming_connections.sh
> **🎯 Mission** : Configure le pare-feu UFW pour autoriser les connexions TCP sur le port 80  
> **🚀 Usage** : `./2-incoming_connections.sh`  
> **⚙️ Actions** :
> - 🔄 Reset complet du pare-feu
> - 🚫 Blocage par défaut des connexions entrantes
> - ✅ Autorisation du port 80/TCP
> - 🔥 Activation du pare-feu

### 📋 3-firewall_rules.sh
> **🎯 Mission** : Liste toutes les règles de la table security d'iptables  
> **🚀 Usage** : `./3-firewall_rules.sh`  
> **🔧 Commande** : `sudo iptables -t security -L -v`  
> **📊 Sortie** : Règles détaillées avec statistiques de paquets

### 🔌 4-network_services.sh
> **🎯 Mission** : Liste tous les services réseau, leurs états et ports d'écoute  
> **🚀 Usage** : `./4-network_services.sh`  
> **🔧 Commande** : `sudo netstat -lntup`  
> **📊 Informations** :
> - 👂 Services en écoute (-l)
> - 🔢 Adresses numériques (-n)
> - 🌐 TCP et UDP (-tu)
> - 🆔 PID des processus (-p)

### 🔍 5-audit_system.sh
> **🎯 Mission** : Lance un audit complet de sécurité système avec Lynis  
> **🚀 Usage** : `./5-audit_system.sh`  
> **🔧 Commande** : `sudo lynis audit system`  
> **📊 Analyse** :
> - 🛡️ Configuration de sécurité
> - 🔓 Vulnérabilités potentielles
> - 📝 Recommandations d'amélioration

### 📡 6-capture_analyze.sh
> **🎯 Mission** : Capture et analyse le trafic réseau en temps réel  
> **🚀 Usage** : `./6-capture_analyze.sh`  
> **🔧 Commande** : `sudo tcpdump -c 5 -i any`  
> **⚙️ Paramètres** :
> - 📦 Capture 5 paquets (-c 5)
> - 🌐 Toutes les interfaces (-i any)

### 🗺️ 7-scan.sh
> **🎯 Mission** : Scan d'un sous-réseau pour découvrir les hôtes actifs  
> **🚀 Usage** : `./7-scan.sh <sous-réseau>`  
> **🔧 Commande** : `sudo nmap <sous-réseau>`  
> **📊 Exemple** : `./7-scan.sh 192.168.1.0/24`

---

## 🚀 Installation et utilisation

### 1️⃣ **Prérequis - Installation des outils** :
```bash
sudo apt update
sudo apt install ufw iptables-persistent net-tools tcpdump nmap lynis
```

### 2️⃣ **Cloner le repository** :
```bash
git clone https://github.com/Pmichel74/holbertonschool-cyber_security.git
cd holbertonschool-cyber_security/linux_security/0x00_linux_security_basics
```

### 3️⃣ **Rendre les scripts exécutables** :
```bash
chmod +x *.sh
```

### 4️⃣ **Exemples d'utilisation** :

<details>
<summary>📋 <strong>Analyser les dernières connexions</strong></summary>

```bash
./0-login.sh
# Sortie : Liste des 5 dernières sessions avec timestamps complets
```
</details>

<details>
<summary>🌐 <strong>Surveiller les connexions actives</strong></summary>

```bash
./1-active-connections.sh
# Affiche : Ports d'écoute, connexions établies + PID des processus
```
</details>

<details>
<summary>🚪 <strong>Configurer le pare-feu pour HTTP</strong></summary>

```bash
./2-incoming_connections.sh
# Actions : Reset UFW + Autorisation port 80 + Activation
```
</details>

<details>
<summary>📋 <strong>Vérifier les règles iptables</strong></summary>

```bash
./3-firewall_rules.sh
# Affiche : Toutes les règles de la table security
```
</details>

<details>
<summary>🔌 <strong>Lister les services réseau</strong></summary>

```bash
./4-network_services.sh
# Sortie : Services + États + Ports + PID
```
</details>

<details>
<summary>🔍 <strong>Audit de sécurité complet</strong></summary>

```bash
./5-audit_system.sh
# Lance : Scan Lynis avec rapport détaillé
```
</details>

<details>
<summary>📡 <strong>Capturer le trafic réseau</strong></summary>

```bash
./6-capture_analyze.sh
# Capture : 5 paquets sur toutes les interfaces
```
</details>

<details>
<summary>🗺️ <strong>Scanner un réseau local</strong></summary>

```bash
./7-scan.sh 192.168.1.0/24
# Découvre : Tous les hôtes actifs du sous-réseau
```
</details>

---

## 🧠 Concepts de sécurité abordés

<table>
<tr>
<td align="center">
<h3>📊 Surveillance des accès</h3>
<p>• Analyse des logs de connexion<br>
• Tracking des sessions utilisateurs<br>
• Détection d'activités suspectes</p>
</td>
<td align="center">
<h3>🌐 Monitoring réseau</h3>
<p>• Surveillance des connexions actives<br>
• Identification des services exposés<br>
• Analyse du trafic réseau</p>
</td>
</tr>
<tr>
<td align="center">
<h3>🔥 Sécurité périmétrique</h3>
<p>• Configuration de pare-feu UFW<br>
• Gestion des règles iptables<br>
• Contrôle des flux réseau</p>
</td>
<td align="center">
<h3>🔍 Audit et évaluation</h3>
<p>• Scan de vulnérabilités<br>
• Évaluation de la posture sécuritaire<br>
• Recommandations d'hardening</p>
</td>
</tr>
<tr>
<td align="center" colspan="2">
<h3>🗺️ Reconnaissance réseau</h3>
<p>• Découverte d'hôtes • Cartographie réseau • Analyse de la topologie</p>
</td>
</tr>
</table>

---

## ⚠️ Sécurité et bonnes pratiques

<div align="center">

| 🚨 **Avertissements critiques** |
|---|
| 🛡️ **Toujours** tester les règles de pare-feu en environnement de test |
| 🔐 Ces scripts nécessitent des **privilèges sudo** |
| 📝 **Documenter** toutes les modifications de configuration |
| 🚫 **Ne jamais** scanner des réseaux sans autorisation |
| 📊 **Monitorer** régulièrement les logs pour détecter les anomalies |
| 🔒 **Sauvegarder** les configurations avant modifications |

</div>

---

## 🛠️ Outils utilisés

<div align="center">

| Outil | Usage | Description |
|-------|-------|-------------|
| 📋 **last** | Logs de connexion | Historique des sessions utilisateurs |
| 🌐 **ss/netstat** | Connexions réseau | Surveillance des sockets et services |
| 🔥 **UFW** | Pare-feu simple | Interface simplifiée pour iptables |
| 📊 **iptables** | Pare-feu avancé | Filtrage de paquets au niveau noyau |
| 🔍 **Lynis** | Audit sécurité | Scanner de vulnérabilités système |
| 📡 **tcpdump** | Capture réseau | Analyse du trafic en temps réel |
| 🗺️ **nmap** | Découverte réseau | Scanner de ports et services |

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
**🐧 0x00. Linux Security Basics**

[![Made with ❤️](https://img.shields.io/badge/Made%20with-❤️-red?style=for-the-badge)](https://github.com/Pmichel74)
[![Linux](https://img.shields.io/badge/Linux-Security-blue?style=for-the-badge&logo=linux&logoColor=white)](https://www.holbertonschool.com/)

</div>