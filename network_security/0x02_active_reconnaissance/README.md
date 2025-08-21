# 🕵️‍♂️ Active Reconnaissance - Network Security

<div align="center">

![Cybersecurity](https://img.shields.io/badge/Cybersecurity-Active%20Reconnaissance-red?style=for-the-badge&logo=security&logoColor=white)
![Network Security](https://img.shields.io/badge/Network-Security-blue?style=for-the-badge&logo=shield&logoColor=white)
![Holberton School](https://img.shields.io/badge/Holberton-School-purple?style=for-the-badge&logo=holbertonschool&logoColor=white)

</div>

---

## 📋 Table of Contents

- [🎯 Project Overview](#-project-overview)
- [🛠️ Tools & Techniques](#️-tools--techniques)
- [📁 Project Structure](#-project-structure)
- [🔍 Reconnaissance Tasks](#-reconnaissance-tasks)
- [⚡ Quick Start](#-quick-start)
- [📊 Results](#-results)
- [🛡️ Security Considerations](#️-security-considerations)
- [📚 Learning Objectives](#-learning-objectives)
- [👨‍💻 Author](#-author)

---

## 🎯 Project Overview

This project focuses on **Active Reconnaissance** techniques in network security. Active reconnaissance involves directly interacting with target systems to gather information, unlike passive reconnaissance which relies on publicly available information.

### 🔥 Key Features

- 🔍 **Port Scanning** - Identify open ports and services
- 🌐 **Web Server Enumeration** - Discover web technologies
- 💉 **SQL Injection Detection** - Find potential injection points
- 🗄️ **Database Discovery** - Identify database systems
- 📊 **Table Enumeration** - Map database structures
- 📂 **Directory Brute-forcing** - Find hidden directories
- 🚩 **Flag Hunting** - Capture security challenges

---

## 🛠️ Tools & Techniques

<div align="center">

| Tool | Usage | Description |
|------|-------|-------------|
| 🔧 **Nmap** | Port Scanning | Network discovery and security auditing |
| 🌐 **Gobuster** | Directory Brute-force | Hidden directory/file discovery |
| 💉 **SQLmap** | SQL Injection | Automated SQL injection testing |
| 🔍 **Nikto** | Web Vulnerability | Web server scanner |
| 📡 **Netcat** | Network Analysis | Network debugging and exploration |

</div>

---

## 📁 Project Structure

```
0x02_active_reconnaissance/
├── 📄 0-ports.txt          # Open ports discovered
├── 🌐 1-webserver.txt      # Web server information
├── 💉 2-injectable.txt     # SQL injection endpoints
├── 🗄️ 3-database.txt       # Database information
├── 📊 4-tables.txt         # Database tables found
├── 📂 5-hidden_dir.txt     # Hidden directories
├── 🚩 100-flag.txt         # Challenge flag 1
├── 🚩 101-flag.txt         # Challenge flag 2
├── 🚩 102-flag.txt         # Challenge flag 3
└── 📖 README.md            # This documentation
```

---

## 🔍 Reconnaissance Tasks

### 1. 🔧 Port Scanning
**Objective**: Identify open ports and running services

```bash
# Nmap basic scan
nmap -sS -sV target_ip

# Results stored in:
```
📄 **0-ports.txt**: `80`

---

### 2. 🌐 Web Server Enumeration
**Objective**: Identify web server technology and version

```bash
# HTTP header analysis
curl -I target_ip
nmap -sC -sV -p80 target_ip

# Results stored in:
```
🌐 **1-webserver.txt**: `nginx 1.18.0`

---

### 3. 💉 SQL Injection Testing
**Objective**: Find potential SQL injection vulnerabilities

```bash
# Manual testing
# Automated with SQLmap
sqlmap -u "http://target/endpoint?param=1"

# Results stored in:
```
💉 **2-injectable.txt**: `/product`

---

### 4. 🗄️ Database Discovery
**Objective**: Identify database management systems

```bash
# Database fingerprinting
sqlmap -u "target_url" --dbs

# Results stored in:
```
🗄️ **3-database.txt**: Database information

---

### 5. 📊 Table Enumeration
**Objective**: Map database table structures

```bash
# Table discovery
sqlmap -u "target_url" -D database_name --tables

# Results stored in:
```
📊 **4-tables.txt**: Database tables

---

### 6. 📂 Directory Brute-forcing
**Objective**: Discover hidden directories and files

```bash
# Gobuster directory scan
gobuster dir -u http://target_ip -w /usr/share/wordlists/dirb/common.txt

# Results stored in:
```
📂 **5-hidden_dir.txt**: Hidden directories

---

## ⚡ Quick Start

### Prerequisites
```bash
# Install required tools
sudo apt update
sudo apt install nmap gobuster sqlmap nikto curl
```

### 🚀 Running the Reconnaissance

1. **Initial Port Scan**
   ```bash
   nmap -sS -sV -O target_ip > scan_results.txt
   ```

2. **Web Application Testing**
   ```bash
   gobuster dir -u http://target_ip -w /usr/share/wordlists/dirb/common.txt
   ```

3. **Vulnerability Assessment**
   ```bash
   nikto -h http://target_ip
   ```

---

## 📊 Results

### 🎯 Discovered Information

| Category | Finding | Status |
|----------|---------|--------|
| 🔧 **Open Ports** | Port 80 (HTTP) | ✅ Active |
| 🌐 **Web Server** | nginx 1.18.0 | ✅ Identified |
| 💉 **Injection Point** | /product endpoint | ⚠️ Vulnerable |
| 🗄️ **Database** | [Content in file] | 🔍 Enumerated |
| 📊 **Tables** | [Content in file] | 🔍 Mapped |
| 📂 **Hidden Dirs** | [Content in file] | 🔍 Discovered |

### 🚩 Flags Captured
- 🚩 **Flag 100**: [Content in 100-flag.txt]
- 🚩 **Flag 101**: [Content in 101-flag.txt]  
- 🚩 **Flag 102**: [Content in 102-flag.txt]

---

## 🛡️ Security Considerations

### ⚠️ Ethical Guidelines

- 🎓 **Educational Purpose Only**: This project is for learning cybersecurity concepts
- 🏠 **Authorized Testing**: Only test systems you own or have explicit permission to test
- 📜 **Legal Compliance**: Ensure all activities comply with local laws and regulations
- 🤝 **Responsible Disclosure**: Report vulnerabilities through proper channels

### 🔒 Best Practices

- 💾 Always document your methodology
- 🕐 Respect rate limits and avoid DoS
- 🔐 Secure your reconnaissance data
- 📝 Maintain detailed logs

---

## 📚 Learning Objectives

By completing this project, you will understand:

- ✅ **Active vs Passive Reconnaissance** differences
- ✅ **Port scanning** techniques and interpretation
- ✅ **Web application** enumeration methods
- ✅ **SQL injection** identification and testing
- ✅ **Database** discovery and enumeration
- ✅ **Directory brute-forcing** strategies
- ✅ **Security assessment** methodology

---

## 🏆 Skills Developed

<div align="center">

| Skill Category | Level | Description |
|----------------|--------|-------------|
| 🔍 **Reconnaissance** | ⭐⭐⭐⭐ | Information gathering techniques |
| 🛠️ **Tool Usage** | ⭐⭐⭐⭐ | Command-line security tools |
| 💉 **Vulnerability Assessment** | ⭐⭐⭐ | Identifying security weaknesses |
| 📊 **Documentation** | ⭐⭐⭐⭐⭐ | Systematic result recording |

</div>

---

## 👨‍💻 Author

**Patrick Michel** 
- 🎓 Holberton School - Cybersecurity Specialization

- 🐱 GitHub: [@Pmichel74]

---

## 📄 License

This project is part of the Holberton School curriculum and is intended for educational purposes.

---

<div align="center">

**⭐ If this project helped you learn, please give it a star! ⭐**

![Made with ❤️ by Patrick](https://img.shields.io/badge/Made%20with-❤️-red?style=for-the-badge)
![Holberton School](https://img.shields.io/badge/Holberton-School-purple?style=for-the-badge)

</div>