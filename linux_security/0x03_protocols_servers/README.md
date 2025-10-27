# 🔐 Linux Security - Protocols & Servers

## 📋 Project Overview

This project focuses on **Linux security best practices** for protocols and server configurations. Through a series of practical shell scripts, you'll learn how to audit, harden, and secure various network services and protocols commonly used in Linux environments.

---

## 🎯 Learning Objectives

By completing this project, you will understand:

- ✅ How to audit and configure **iptables firewall** rules
- ✅ SSH server configuration hardening
- ✅ File system security and permission management
- ✅ System security auditing with **Lynis**
- ✅ Network File System (NFS) security
- ✅ SNMP and SMTP server configuration checks
- ✅ SSL/TLS cipher security testing
- ✅ DoS attack simulation for testing purposes
- ✅ Firewall rule management and network security

---

## 📁 Project Files

| File | Description |
|------|-------------|
| `0-iptables.sh` | Display detailed iptables firewall rules with line numbers |
| `1-audit.sh` | Audit SSH server configuration (non-comment, non-empty lines) |
| `2-harden.sh` | Harden file system by removing world-writable permissions |
| `3-identify.sh` | Run comprehensive system security audit using Lynis |
| `4-nfs.sh` | Check NFS server exports for a given host |
| `5-snmp.sh` | Display SNMP server configuration (excluding comments) |
| `6-smtp.sh` | Check SMTP server STARTTLS configuration |
| `7-dos.sh` | Simulate basic DoS attack using hping3 (testing purposes only) |
| `8-cipher.sh` | Test SSL/TLS ciphers and identify weak encryption |
| `9-firewall.sh` | Configure basic iptables firewall (allow SSH only) |

---

## 🚀 Usage

### Prerequisites

Make sure you have the required tools installed:

```bash
# Install necessary packages
sudo apt-get update
sudo apt-get install iptables lynis nfs-common snmp postfix nmap hping3
```

### Running the Scripts

All scripts should be executed with appropriate permissions:

```bash
# Make scripts executable
chmod +x *.sh

# Example: Check iptables rules
sudo ./0-iptables.sh

# Example: Audit SSH configuration
sudo ./1-audit.sh

# Example: Check NFS exports
sudo ./4-nfs.sh 192.168.1.100

# Example: Test SSL ciphers
sudo ./8-cipher.sh example.com

# Example: Setup firewall
sudo ./9-firewall.sh
```

---

## 🔧 Detailed Script Descriptions

### 🛡️ 0-iptables.sh
Lists all iptables rules with detailed information including packet counts, byte counts, and rule numbers.

**Usage:**
```bash
sudo ./0-iptables.sh
```

---

### 🔍 1-audit.sh
Extracts active SSH configuration by filtering out comments and blank lines from `/etc/ssh/sshd_config`.

**Usage:**
```bash
sudo ./1-audit.sh
```

---

### 🔒 2-harden.sh
Finds and removes world-writable permissions on directories throughout the system (except special filesystems).

**Usage:**
```bash
sudo ./2-harden.sh
```

---

### 🔎 3-identify.sh
Runs Lynis security auditing tool to perform a comprehensive system security assessment.

**Usage:**
```bash
sudo ./3-identify.sh
```

---

### 📂 4-nfs.sh
Shows NFS exports available from a specified server.

**Usage:**
```bash
sudo ./4-nfs.sh <IP_ADDRESS>
```

**Example:**
```bash
sudo ./4-nfs.sh 192.168.1.100
```

---

### 📊 5-snmp.sh
Displays SNMP daemon configuration excluding comment lines.

**Usage:**
```bash
sudo ./5-snmp.sh
```

---

### 📧 6-smtp.sh
Checks if STARTTLS is configured in Postfix SMTP server configuration.

**Usage:**
```bash
sudo ./6-smtp.sh
```

**Output:**
- If configured: `smtpd_tls_security_level = may` (or other value)
- If not configured: `STARTTLS not configured`

---

### 💥 7-dos.sh
Simulates a basic DoS attack using hping3 for **testing purposes only** in controlled environments.

**⚠️ WARNING:** Only use this on systems you own or have explicit permission to test!

**Usage:**
```bash
sudo ./7-dos.sh <TARGET_IP>
```

**Example:**
```bash
sudo ./7-dos.sh 192.168.1.100
```

---

### 🔐 8-cipher.sh
Tests SSL/TLS server ciphers using nmap's `ssl-enum-ciphers` script to identify weak encryption.

**Usage:**
```bash
sudo ./8-cipher.sh <TARGET_IP>
```

**Example:**
```bash
sudo ./8-cipher.sh 192.168.1.100
```

---

### 🔥 9-firewall.sh
Sets up basic iptables firewall rules that:
- ✅ Allow established/related connections
- ✅ Allow SSH (port 22)
- ❌ Block all other incoming traffic

**Usage:**
```bash
sudo ./9-firewall.sh
```

**Note:** File must contain exactly 3 lines when checked with `wc -l`.

---

## ⚠️ Important Security Notes

1. **Testing Environment:** Always test these scripts in a controlled environment first
2. **Backup:** Make backups before applying security changes
3. **SSH Access:** Be careful with firewall rules to avoid locking yourself out
4. **DoS Script:** The DoS script is for authorized testing only - unauthorized use is illegal
5. **Root Privileges:** Most scripts require `sudo` or root access

---

## 📚 Resources

- [iptables Tutorial](https://www.netfilter.org/documentation/)
- [SSH Hardening Guide](https://www.ssh.com/academy/ssh/sshd_config)
- [Lynis Documentation](https://cisofy.com/lynis/)
- [NFS Security Best Practices](https://linux.die.net/man/5/exports)
- [SNMP Configuration](https://net-snmp.sourceforge.io/)
- [SSL/TLS Best Practices](https://wiki.mozilla.org/Security/Server_Side_TLS)

---

## 👨‍💻 Author

**Holberton School - Cybersecurity Track**

---

## 📜 License

This project is part of the Holberton School curriculum.

---

## 🤝 Contributing

This is an educational project. Feel free to learn from it and adapt it for your own learning purposes!

---

**Happy Securing! 🛡️**