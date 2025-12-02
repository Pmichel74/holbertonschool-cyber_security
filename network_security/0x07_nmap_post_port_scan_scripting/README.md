# 🔍 Nmap Post-Port Scan Scripting

🛡️ Advanced network reconnaissance toolkit using Nmap with NSE (Nmap Scripting Engine) scripts for comprehensive security assessment and vulnerability detection.

## 📋 Overview

🚀 This project demonstrates advanced Nmap scanning techniques combining service detection, vulnerability scanning, and extensive NSE script capabilities for thorough network reconnaissance and security auditing.

## 🎯 Core Concepts

### What is Nmap?
🔧 Nmap is an open-source tool for network discovery and security auditing that identifies hosts, services, and vulnerabilities on networks.

### NSE Scripts
📜 NSE (Nmap Scripting Engine) provides automated scripts for service detection, vulnerability discovery, and network enumeration beyond basic port scanning.

## 📁 Scripts Overview

### 0-nmap_default.sh 📊
**Purpose**: Runs Nmap's default script scanning on a target.

**Command**:
```bash
nmap -sC $1
```

**What it does**:
- Executes all default NSE scripts
- Provides service detection and basic enumeration
- Suitable for quick reconnaissance

**Usage**:
```bash
./0-nmap_default.sh 192.168.1.100
```

---

### 1-nmap_vulners.sh 🔓
**Purpose**: Performs vulnerability scanning on HTTP and HTTPS services using the Vulners database.

**Command**:
```bash
nmap -sV --script vulners -p 80,443 $1
```

**What it does**:
- Detects service versions with `-sV`
- Runs Vulners script to identify CVEs
- Focuses on web service ports (80, 443)
- Provides detailed vulnerability information

**Usage**:
```bash
./1-nmap_vulners.sh scanme.nmap.org
```

---

### 2-vuln_scan.sh 🚨
**Purpose**: Scans for specific CVE-2017-5638 vulnerability (Apache Struts RCE).

**Command**:
```bash
nmap -sV --script http-vuln-cve2017-5638 $1 -oN vuln_scan_results.txt
```

**What it does**:
- Detects specific known vulnerabilities
- Targets HTTP services
- Saves results to file for documentation
- Useful for targeted vulnerability assessment

**Usage**:
```bash
./2-vuln_scan.sh target.com
```

---

### 3-comprehensive_scan.sh 🔬
**Purpose**: Performs comprehensive OS, version, and script scanning.

**Command**:
```bash
nmap -sV -O -sC $1
```

**What it does**:
- `-sV`: Service version detection
- `-O`: OS detection
- `-sC`: Default script scanning
- Complete reconnaissance with all major detection types

**Usage**:
```bash
./3-comprehensive_scan.sh 192.168.1.1/24
```

---

### 4-vulnerability_scan.sh 🔥
**Purpose**: Multi-service vulnerability scanning with wildcard script patterns.

**Command**:
```bash
nmap -sV --script "http-vuln* mysql-vuln* ftp-vuln* smtp-vuln*" $1 -oN vulnerability_scan_results.txt
```

**What it does**:
- Scans multiple service types for vulnerabilities
- Uses wildcard patterns to run related scripts
- Provides comprehensive vulnerability coverage
- Saves detailed results for analysis

**Vulnerable Services Checked**:
- 🌐 HTTP/HTTPS
- 🗄️ MySQL
- 📤 FTP
- 📧 SMTP

**Usage**:
```bash
./4-vulnerability_scan.sh internal-server.local
```

---

### 5-service_enumeration.sh 👥
**Purpose**: Comprehensive service enumeration with advanced NSE scripts.

**Command**:
```bash
nmap -sV -A --script banner,ssl-enum-ciphers,default,smb-enum-domains $1 -oN service_enumeration_results.txt
```

**What it does**:
- `-A`: OS, version, scripts, traceroute
- `banner`: Retrieves service banners
- `ssl-enum-ciphers`: Lists SSL/TLS cipher capabilities
- `default`: Runs default scripts
- `smb-enum-domains`: Enumerates SMB domains

**Usage**:
```bash
./5-service_enumeration.sh domain-controller.company.local
```

## 🚀 Quick Start

### Prerequisites
```bash
# Install Nmap
sudo apt install nmap

# Make scripts executable
chmod +x *.sh
```

### Basic Usage

Run any script with a target:
```bash
./0-nmap_default.sh scanme.nmap.org
./1-nmap_vulners.sh 192.168.1.100
./4-vulnerability_scan.sh target.com
```

### Advanced Usage

Scan multiple hosts:
```bash
./5-service_enumeration.sh 192.168.1.0/24
```

Combine with other tools:
```bash
cat hosts.txt | while read host; do
    ./1-nmap_vulners.sh "$host"
done
```

## 📊 Nmap Flags Explained

| Flag | Purpose | Example |
|------|---------|---------|
| `-sC` | Run default NSE scripts | `nmap -sC target` |
| `-sV` | Detect service versions | `nmap -sV target` |
| `-O` | Detect OS | `nmap -O target` |
| `-A` | Aggressive (OS + version + scripts + traceroute) | `nmap -A target` |
| `--script` | Run specific NSE scripts | `nmap --script vuln target` |
| `-p` | Specify ports | `nmap -p 80,443 target` |
| `-oN` | Save output as normal text | `nmap -oN output.txt target` |

## 🎯 NSE Script Categories

### Service Detection
- `banner`: Grab service banners
- `default`: Default script collection
- `ssl-enum-ciphers`: SSL/TLS cipher enumeration

### Vulnerability Scanning
- `vuln`: Generic vulnerability detection
- `vulners`: CVE database matching
- `http-vuln-*`: HTTP-specific vulnerabilities
- `smb-enum-*`: SMB enumeration

### Enumeration
- `smb-enum-domains`: SMB domain discovery
- `smb-enum-users`: SMB user enumeration
- `ftp-anon`: FTP anonymous access check

## ⚠️ Security & Legal Considerations

### Best Practices
- 🔒 **Authorization**: Only scan networks you own or have explicit permission to test
- 📋 **Documentation**: Keep detailed logs of all scans performed
- ⏱️ **Timing**: Use appropriate timing options to avoid overwhelming targets
- 🎯 **Targeting**: Be specific with ports and services to minimize impact

### Common Issues
```bash
# Firewall blocking version detection
nmap -sV --version-intensity 9 target

# NSE scripts taking too long
nmap --script vuln --script-timeout 300 target

# Getting rate-limited
nmap -T2 -p 22,80,443 target
```

## 📈 Output Analysis

### Results Interpretation

**Service Banner Example**:
```
Apache httpd 2.4.41 (Ubuntu)
OpenSSH 8.2p1 (Ubuntu Linux)
```

**Vulnerability Finding**:
```
CVE-2021-31956 | CVSS 9.8 | Critical
```

**SSL Cipher Enumeration**:
```
Supported Ciphers: TLS_AES_256_GCM_SHA384, TLS_CHACHA20_POLY1305_SHA256
```

## 🛠️ Troubleshooting

### Common Problems

**Script not found**:
```bash
# Check available scripts
ls /usr/share/nmap/scripts | grep vuln
```

**Permission denied**:
```bash
# Make scripts executable
chmod +x *.sh
```

**Target unreachable**:
```bash
# Increase timeout and retries
nmap --max-retries 3 --connect-timeout 30 target
```

## 🎓 Learning Path

1. **Basics**: Start with `0-nmap_default.sh`
2. **Version Detection**: Try `3-comprehensive_scan.sh`
3. **Vulnerability Scanning**: Progress to `1-nmap_vulners.sh`
4. **Advanced**: Use `4-vulnerability_scan.sh` and `5-service_enumeration.sh`
5. **Mastery**: Combine scripts and create custom workflows

## 📚 Additional Resources

- [Nmap Official Documentation](https://nmap.org/docs.html)
- [NSE Script Documentation](https://nmap.org/nsedoc/)
- [Vulners Database](https://vulners.com/)
- [OWASP Security Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)

## 🎯 Use Cases

### Security Auditing
- Internal network assessment
- Vulnerability identification
- Service inventory

### Incident Response
- Compromised system investigation
- Network anomaly detection
- Security baseline comparison

### Compliance Testing
- PCI DSS network scanning
- HIPAA security assessments
- SOC 2 compliance validation

## 📝 Notes

- Always document your scanning activities
- Respect network policies and legal requirements
- Use appropriate timing and rate limiting
- Archive results for compliance and audit trails

---

**Last Updated**: December 2025  
**Difficulty Level**: Intermediate to Advanced  
**Prerequisites**: Bash scripting knowledge, Nmap familiarity