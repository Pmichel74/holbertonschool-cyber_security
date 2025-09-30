# 🛡️ **SQL & NoSQL Injection - Holberton School Cybersecurity**

## 📋 **Vue d'ensemble**

Ce projet contient **8 tâches progressives** d'apprentissage des injections SQL et NoSQL, conçues pour développer une expertise complète en sécurité des applications web. Chaque exercice cible des vulnérabilités spécifiques et des techniques d'exploitation réelles.

## 🎯 **Objectifs pédagogiques**

### **Compétences développées**
- **Découverte** et identification des points d'injection
- **Techniques d'extraction** de données sensibles
- **Injections aveugles** (time-based, boolean-based)
- **Attaques second-order** et template injection
- **Injections NoSQL** modernes (MongoDB)
- **Énumération avancée** et exploitation de données
- **Utilisation professionnelle** d'outils de sécurité

### **Méthodologie enseignée**
- Approche méthodique du testing de sécurité
- Utilisation de Burp Suite en contexte professionnel
- Analyse des réponses et debugging d'exploits
- Documentation technique et reporting

## 🛠️ **Prérequis techniques**

### **Environnement requis**
- **Linux** (Ubuntu/Kali recommandé)
- **Burp Suite Community** (ou Professional)
- **Firefox** avec configuration proxy
- **Python 3.x** pour les scripts d'automatisation
- **Accès réseau** vers l'infrastructure de test

### **Configuration réseau**
```bash
# Configuration du fichier hosts
sudo nano /etc/hosts
# Ajouter : X.X.X.X web0x01.hbtn
```

### **Configuration proxy**
- **Burp Suite :** `127.0.0.1:8080`
- **Firefox :** Configuration manuelle du proxy
- **Certificat SSL** Burp installé (si HTTPS)

## 📚 **Structure du projet**

### **Tâches disponibles**

| Tâche | Type | Difficulté | Objectif principal |
|-------|------|------------|-------------------|
| **0** | Discovery | ⭐ | Identifier les paramètres vulnérables |
| **1** | Union-based SQLi | ⭐⭐ | Extraire des informations de base de données |
| **2** | Data Exfiltration | ⭐⭐ | Voler des données sensibles |
| **3** | Time-based Blind | ⭐⭐⭐ | Exploitation aveugle avec délais |
| **4** | Second-Order + SSTI | ⭐⭐⭐⭐ | Injection différée et template |
| **5** | NoSQL Discovery | ⭐⭐ | Détecter des endpoints vulnérables NoSQL |
| **6** | NoSQL Bypass | ⭐⭐⭐ | Contournement d'authentification NoSQL |
| **7** | NoSQL Enumeration | ⭐⭐⭐⭐⭐ | Énumération et exploitation financière |

### **Progression recommandée**
1. **Tâches 0-2** : Bases fondamentales SQL
2. **Tâches 3-4** : Techniques avancées et aveugles
3. **Tâche 5** : Introduction à la découverte NoSQL
4. **Tâche 6** : Contournement d'authentification NoSQL
5. **Tâche 7** : Maîtrise NoSQL et exploitation complexe

## 🔧 **Utilisation**

### **Démarrage rapide**
```bash
# 1. Clone du repository
git clone [repository-url]
cd holbertonschool-cyber_security/web_application_security/0x03_sql_nosql_injection/

# 2. Configuration environnement
sudo nano /etc/hosts  # Ajouter l'IP du serveur

# 3. Lancement Burp Suite
burpsuite &

# 4. Test de connectivité
curl -x http://127.0.0.1:8080 http://web0x01.hbtn/a3/sql_injection/
```

### **Workflow type**
1. **Analyser** l'énoncé de la tâche
2. **Configurer** Burp Suite et proxy
3. **Explorer** l'application web cible
4. **Identifier** les points d'injection
5. **Développer** et tester les payloads
6. **Extraire** les données/flags demandés
7. **Documenter** les résultats

## 📖 **Ressources et documentation**

### **Documentation projet**
- `Manuel_Complet_SQL_Injection_Holberton.md` : Guide technique détaillé
- `*-flag.txt` : Fichiers de flags pour validation
- `*-vuln.txt` : Endpoints/paramètres vulnérables découverts
- Scripts Python : Automatisation des attaques

### **URLs principales**
- **SQL Injection :** `http://web0x01.hbtn/a3/sql_injection/`
- **NoSQL Injection :** `http://web0x01.hbtn/a3/nosql_injection/`
- **API Endpoints :** `/api/a3/sql_injection/` et `/api/a3/nosql_injection/`

### **Outils recommandés**
- **Burp Suite** : Proxy et testing manuel
- **SQLMap** : Automatisation SQL injection
- **NoSQLMap** : Automatisation NoSQL injection
- **Python Requests** : Scripts personnalisés

## ⚠️ **Avertissements de sécurité**

### **Usage éthique uniquement**
- Ces techniques sont destinées à l'**apprentissage** et au **testing autorisé**
- **Ne jamais utiliser** sur des systèmes non autorisés
- **Respecter** les lois locales et internationales
- **Usage exclusif** dans l'environnement de test Holberton

### **Sécurité des tests**
- **Isoler** l'environnement de test
- **Sauvegarder** les données avant tests destructifs
- **Documenter** toutes les actions entreprises
- **Nettoyer** après tests (sessions, cookies)

## 📊 **Évaluation et validation**

### **Critères de réussite**
- **Obtention des flags** pour chaque tâche
- **Documentation** de la méthodologie utilisée
- **Compréhension** des vulnérabilités exploitées
- **Explication** des impacts de sécurité

### **Livrables attendus**
- Fichiers de découverte (`0-vuln.txt`, `5-vuln.txt`)
- Fichiers de flags (`1-flag.txt`, `2-flag.txt`, `3-flag.txt`, `4-flag.txt`, `6-flag.txt`, `7-flag.txt`)
- Documentation technique des exploits
- Scripts d'automatisation (si applicable)
- Rapport d'analyse des vulnérabilités

## 🔗 **Support et ressources**

### **Documentation officielle**
- [OWASP SQL Injection](https://owasp.org/www-community/attacks/SQL_Injection)
- [OWASP NoSQL Injection](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/07-Input_Validation_Testing/05.6-Testing_for_NoSQL_Injection)
- [Burp Suite Documentation](https://portswigger.net/burp/documentation)

### **Apprentissage complémentaire**
- [PortSwigger Web Security Academy](https://portswigger.net/web-security)
- [SQL Injection Labs](https://www.vulnhub.com/)
- [NoSQL Injection Techniques](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/NoSQL%20Injection)

### **Communauté**
- **Forums Holberton** : Discussion avec pairs
- **Discord/Slack** : Support technique
- **Bug Bounty Communities** : Application pratique

---

## 📝 **Notes importantes**

### **Confidentialité**
- **Ne pas partager** les flags ou solutions complètes
- **Respecter** l'intégrité pédagogique du projet
- **Collaborer** sans copier les réponses

### **Évolution du projet**
- **Tâches mises à jour** régulièrement
- **Nouvelles techniques** ajoutées périodiquement
- **Feedback** encouragé pour amélioration

---

**Projet développé par Holberton School - Cursus Cybersécurité**
**Mise à jour :** Septembre 2025
**Version :** 1.1 - Structure complète 8 tâches (SQL + NoSQL)