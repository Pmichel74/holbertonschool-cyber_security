# 🔍 Web Application Forensics Toolkit

🛡️ This toolkit provides a comprehensive set of bash scripts for performing forensic analysis on web application security incidents. The scripts analyze system logs to identify compromised accounts, suspicious connections, firewall activity, and system changes.

## 📋 Overview

🔧 The toolkit consists of 6 specialized forensic scripts that examine different aspects of system security:

- **0-service.sh** 📊: Analyzes the most active services in authentication logs
- **1-operating.sh** 🖥️: Checks for specific Ubuntu kernel versions in system logs
- **2-accounts.sh** 👤: Detects potentially compromised user accounts
- **3-ips.sh** 🌐: Counts unique IP addresses that successfully connected to root
- **4-firewall.sh** 🔥: Monitors iptables firewall rule changes
- **5-users.sh** 👥: Lists newly created user accounts

## ⚙️ Prerequisites

- 🐧 Linux system with bash shell
- 📄 Access to system log files (`auth.log` and `dmesg`)
- 🔑 Execute permissions on the scripts

## 📁 Files

- `auth.log` 📝: System authentication log file
- `dmesg` 📋: Kernel ring buffer log file
- `INCIDENT_REPORT.md` 📊: Comprehensive incident analysis and mitigation plan

## 🚀 Usage

### Running Individual Scripts

🔧 Make sure all scripts have execute permissions:

```bash
chmod +x *.sh
```

📝 Run each script individually:

```bash
# Analyze most active services
./0-service.sh

# Check operating system version
./1-operating.sh

# Detect compromised accounts
./2-accounts.sh

# Count root login IPs
./3-ips.sh

# Check firewall rules
./4-firewall.sh

# List new users
./5-users.sh
```

### Batch Execution

⚡ Run all scripts at once:

```bash
for script in {0..5}-*.sh; do
    echo "=== Running $script ==="
    ./$script
    echo ""
done
```

## 🔍 Script Details

### 0-service.sh 📊
**Purpose**: Identifies the most frequently accessed services in the authentication log.

**Output**: Ranked list of services with access counts.

**Example**:
```
  34806 pam_unix(sshd:auth):
  29010 pam_unix(cron:session):
  20339 Failed
```

### 1-operating.sh 🖥️
**Purpose**: Detects if the system is running a specific vulnerable Ubuntu kernel version.

**Output**: Kernel version information from dmesg logs.

**Example**:
```
[    0.000000] Linux version 2.6.24-26-server (buildd@crested) (gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu3)) #1 SMP Tue Dec 1 18:26:43 UTC 2009 (Ubuntu 2.6.24-26.64-server)
```

### 2-accounts.sh 👤
**Purpose**: Identifies user accounts that may have been compromised by analyzing failed login attempts followed by successful logins.

**Output**: List of potentially compromised usernames.

**Example**:
```
root
```

### 3-ips.sh 🌐
**Purpose**: Counts unique IP addresses that have successfully established SSH connections to the root account.

**Output**: Number of unique IP addresses.

**Example**:
```
5
```

### 4-firewall.sh 🔥
**Purpose**: Counts the number of iptables INPUT rules that have been added to the firewall.

**Output**: Count of firewall rules.

**Example**:
```
12
```

### 5-users.sh 👥
**Purpose**: Lists all newly created user accounts from the authentication logs.

**Output**: Comma-separated list of usernames.

**Example**:
```
user1,user2,admin
```

## 🚨 Incident Response

📋 For a complete incident analysis and mitigation plan, refer to `INCIDENT_REPORT.md`. This document provides:

- 📊 Executive summary of findings
- 🔍 Detailed analysis of each forensic task
- 🛠️ Implementation phases for security hardening
- 👁️ Monitoring protocols
- 🔮 Future mitigation strategies

## ⚠️ Security Considerations

- 🔒 These scripts analyze historical log data and should be run in a controlled environment
- 💾 Always backup logs before analysis
- ⚡ Consider the impact of running these scripts on production systems
- 👨‍💼 Results should be reviewed by security professionals for accurate interpretation

## 📚 Contributing

🎓 This is an educational project for Holberton School cybersecurity training. Scripts are designed for learning forensic analysis techniques.