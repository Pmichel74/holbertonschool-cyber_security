# 🐧 0x00. Linux Security Basics

<div align="center">

![Linux Security](https://img.shields.io/badge/Linux-Security-red?style=for-the-badge&logo=linux&logoColor=white)
![Network](https://img.shields.io/badge/Network-Monitoring-blue?style=for-the-badge&logo=wireshark&logoColor=white)
![Firewall](https://img.shields.io/badge/Firewall-UFW/iptables-orange?style=for-the-badge&logo=firewall&logoColor=white)
![Audit](https://img.shields.io/badge/System-Audit-green?style=for-the-badge&logo=security&logoColor=white)

</div>

## 📖 Description
This project is part of the **Holberton School** cybersecurity curriculum, specializing in Linux security. It covers essential system security concepts, network monitoring, firewall configuration, and security auditing through practical bash scripts.

## 🎯 Learning Objectives
By the end of this project, you should master:
- 📊 Login session and system log analysis
- 🌐 Active network connection monitoring
- 🔥 Firewall configuration and management (UFW/iptables)
- 🔍 System security auditing with Lynis
- 📡 Network traffic capture and analysis
- 🗺️ Network discovery and vulnerability scanning

## 🖥️ Environment
- **OS** : Ubuntu 20.04 LTS 🐧
- **Shell** : Bash 💻
- **Tools** : UFW, iptables, netstat, ss, tcpdump, nmap, lynis 🛠️
- **Privileges** : sudo required 🔐

---

## 📂 Scripts List

### 📋 0-login.sh
> **🎯 Mission** : Display the last 5 login sessions with dates and times  
> **🚀 Usage** : `./0-login.sh`  
> **🔧 Command** : `sudo last -F -5`  
> **📤 Output** : Detailed user connection history

### 🌐 1-active-connections.sh
> **🎯 Mission** : Display all active network connections with process information  
> **🚀 Usage** : `./1-active-connections.sh`  
> **🔧 Command** : `sudo ss -tanp`  
> **📊 Features** :
> - ✅ TCP sockets (-t)
> - 🔢 Numerical addresses (-n)
> - 🏷️ Associated processes (-p)
> - 📡 Listening ports and established connections

### 🚪 2-incoming_connections.sh
> **🎯 Mission** : Configure UFW firewall to allow TCP connections on port 80  
> **🚀 Usage** : `./2-incoming_connections.sh`  
> **⚙️ Actions** :
> - 🔄 Complete firewall reset
> - 🚫 Default deny incoming connections
> - ✅ Allow port 80/TCP
> - 🔥 Firewall activation

### 📋 3-firewall_rules.sh
> **🎯 Mission** : List all rules from iptables security table  
> **🚀 Usage** : `./3-firewall_rules.sh`  
> **🔧 Command** : `sudo iptables -t security -L -v`  
> **📊 Output** : Detailed rules with packet statistics

### 🔌 4-network_services.sh
> **🎯 Mission** : List all network services, their states and listening ports  
> **🚀 Usage** : `./4-network_services.sh`  
> **🔧 Command** : `sudo netstat -lntup`  
> **📊 Information** :
> - 👂 Listening services (-l)
> - 🔢 Numerical addresses (-n)
> - 🌐 TCP and UDP (-tu)
> - 🆔 Process PID (-p)

### 🔍 5-audit_system.sh
> **🎯 Mission** : Launch complete system security audit with Lynis  
> **🚀 Usage** : `./5-audit_system.sh`  
> **🔧 Command** : `sudo lynis audit system`  
> **📊 Analysis** :
> - 🛡️ Security configuration
> - 🔓 Potential vulnerabilities
> - 📝 Improvement recommendations

### 📡 6-capture_analyze.sh
> **🎯 Mission** : Capture and analyze network traffic in real-time  
> **🚀 Usage** : `./6-capture_analyze.sh`  
> **🔧 Command** : `sudo tcpdump -c 5 -i any`  
> **⚙️ Parameters** :
> - 📦 Capture 5 packets (-c 5)
> - 🌐 All interfaces (-i any)

### 🗺️ 7-scan.sh
> **🎯 Mission** : Scan a subnet to discover active hosts  
> **🚀 Usage** : `./7-scan.sh <subnet>`  
> **🔧 Command** : `sudo nmap <subnet>`  
> **📊 Example** : `./7-scan.sh 192.168.1.0/24`

---

## 🚀 Installation and Usage

### 1️⃣ **Prerequisites - Tool Installation** :
```bash
sudo apt update
sudo apt install ufw iptables-persistent net-tools tcpdump nmap lynis
```

### 2️⃣ **Clone the repository** :
```bash
git clone https://github.com/Pmichel74/holbertonschool-cyber_security.git
cd holbertonschool-cyber_security/linux_security/0x00_linux_security_basics
```

### 3️⃣ **Make scripts executable** :
```bash
chmod +x *.sh
```

### 4️⃣ **Usage examples** :

<details>
<summary>📋 <strong>Analyze recent logins</strong></summary>

```bash
./0-login.sh
# Output: List of last 5 sessions with full timestamps
```
</details>

<details>
<summary>🌐 <strong>Monitor active connections</strong></summary>

```bash
./1-active-connections.sh
# Shows: Listening ports, established connections + process PIDs
```
</details>

<details>
<summary>🚪 <strong>Configure firewall for HTTP</strong></summary>

```bash
./2-incoming_connections.sh
# Actions: Reset UFW + Allow port 80 + Activation
```
</details>

<details>
<summary>📋 <strong>Check iptables rules</strong></summary>

```bash
./3-firewall_rules.sh
# Shows: All security table rules
```
</details>

<details>
<summary>🔌 <strong>List network services</strong></summary>

```bash
./4-network_services.sh
# Output: Services + States + Ports + PID
```
</details>

<details>
<summary>🔍 <strong>Complete security audit</strong></summary>

```bash
./5-audit_system.sh
# Launches: Lynis scan with detailed report
```
</details>

<details>
<summary>📡 <strong>Capture network traffic</strong></summary>

```bash
./6-capture_analyze.sh
# Captures: 5 packets on all interfaces
```
</details>

<details>
<summary>🗺️ <strong>Scan local network</strong></summary>

```bash
./7-scan.sh 192.168.1.0/24
# Discovers: All active hosts in subnet
```
</details>

---

## 🧠 Security Concepts Covered

<table>
<tr>
<td align="center">
<h3>📊 Access Monitoring</h3>
<p>• Login log analysis<br>
• User session tracking<br>
• Suspicious activity detection</p>
</td>
<td align="center">
<h3>🌐 Network Monitoring</h3>
<p>• Active connection surveillance<br>
• Exposed service identification<br>
• Network traffic analysis</p>
</td>
</tr>
<tr>
<td align="center">
<h3>🔥 Perimeter Security</h3>
<p>• UFW firewall configuration<br>
• iptables rules management<br>
• Network flow control</p>
</td>
<td align="center">
<h3>🔍 Audit and Assessment</h3>
<p>• Vulnerability scanning<br>
• Security posture evaluation<br>
• Hardening recommendations</p>
</td>
</tr>
<tr>
<td align="center" colspan="2">
<h3>🗺️ Network Reconnaissance</h3>
<p>• Host discovery • Network mapping • Topology analysis</p>
</td>
</tr>
</table>

---

## ⚠️ Security and Best Practices

<div align="center">

| 🚨 **Critical Warnings** |
|---|
| 🛡️ **Always** test firewall rules in test environment |
| 🔐 These scripts require **sudo privileges** |
| 📝 **Document** all configuration changes |
| 🚫 **Never** scan networks without authorization |
| 📊 **Monitor** logs regularly to detect anomalies |
| 🔒 **Backup** configurations before modifications |

</div>

---

## 🛠️ Tools Used

<div align="center">

| Tool | Usage | Description |
|-------|-------|-------------|
| 📋 **last** | Login logs | User session history |
| 🌐 **ss/netstat** | Network connections | Socket and service monitoring |
| 🔥 **UFW** | Simple firewall | Simplified interface for iptables |
| 📊 **iptables** | Advanced firewall | Kernel-level packet filtering |
| 🔍 **Lynis** | Security audit | System vulnerability scanner |
| 📡 **tcpdump** | Network capture | Real-time traffic analysis |
| 🗺️ **nmap** | Network discovery | Port and service scanner |

</div>

---

## 👨‍💻 Author

<div align="center">

**Patrick Michel** 🚀  
[![GitHub](https://img.shields.io/badge/GitHub-Pmichel74-black?style=for-the-badge&logo=github)](https://github.com/Pmichel74)

</div>

---

## 🏫 Project

<div align="center">

**Holberton School** - Cybersecurity Specialization  
**🐧 0x00. Linux Security Basics**

[![Made with ❤️](https://img.shields.io/badge/Made%20with-❤️-red?style=for-the-badge)](https://github.com/Pmichel74)
[![Linux](https://img.shields.io/badge/Linux-Security-blue?style=for-the-badge&logo=linux&logoColor=white)](https://www.holbertonschool.com/)

</div>