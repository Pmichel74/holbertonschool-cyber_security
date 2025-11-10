# 0x06. Nmap Advanced Port Scans

![Nmap](https://img.shields.io/badge/Nmap-7.80+-blue.svg)
![Bash](https://img.shields.io/badge/Bash-Script-green.svg)
![Security](https://img.shields.io/badge/Security-Network-red.svg)

## Description

This project explores advanced port scanning techniques with **Nmap**, a powerful network reconnaissance tool. You will learn to use different types of TCP scans to identify open, closed, or filtered ports on remote machines, while remaining as stealthy as possible to avoid detection by security systems.

## Background

Port scanning is essential in network security for:
- Identifying exposed services on a network
- Testing firewall rules
- Detecting potential vulnerabilities
- Performing authorized security audits

## Prerequisites

- **Operating System**: Linux (Kali, Ubuntu, Debian, etc.)
- **Nmap** version 7.80 or higher
- **Sudo privileges** to execute scans
- **Bash** shell

### Nmap Installation

```bash
sudo apt update
sudo apt install nmap -y
```

## Implemented Scan Types

### 1. NULL Scan (-sN) 🔇
**File**: `0-null_scan.sh`

**Principle**: Sends empty TCP packets (no flags set). Open ports don't respond, while closed ports respond with RST.

**Features**:
- Very stealthy
- Can bypass some firewalls
- Scans ports 20-25

**Usage**:
```bash
./0-null_scan.sh www.holbertonschool.com
```

---

### 2. FIN Scan (-sF) 👻
**File**: `1-fin_scan.sh`

**Principle**: Sends TCP packets with only the FIN flag set (normally used to close a connection).

**Features**:
- Uses packet fragmentation (`-f`)
- Timing set to 2 (slow scan to avoid detection)
- Scans ports 80-85
- May take time to complete

**Usage**:
```bash
./1-fin_scan.sh www.holbertonschool.com
```

---

### 3. Xmas Scan (-sX) 🎄
**File**: `2-xmas_scan.sh`

**Principle**: Sends packets with FIN, PSH, and URG flags set (the packet is "lit up" like a Christmas tree).

**Features**:
- Shows all sent and received packets (`--packet-trace`)
- Shows only open ports (`--open`)
- Displays the reason for each port's state (`--reason`)
- Scans ports 440-450

**Usage**:
```bash
./2-xmas_scan.sh www.holbertonschool.com
```

---

### 4. Maimon Scan (-sM) 🪄
**File**: `3-maimon_scan.sh`

**Principle**: Sends packets with both FIN and ACK flags set simultaneously.

**Features**:
- Scans services: FTP (21), SSH (22), Telnet (23), HTTP (80), HTTPS (443)
- High verbosity (`-vv`)
- Named after Uriel Maimon who discovered this technique

**Usage**:
```bash
./3-maimon_scan.sh www.holbertonschool.com
```

---

### 5. TCP ACK Scan (-sA) 🚪
**File**: `4-ask_scan.sh`

**Principle**: Sends packets with the ACK flag set to analyze firewall rules.

**Features**:
- Accepts host (`$1`) and ports (`$2`) as arguments
- Displays the reason for the state (`--reason`)
- 1000ms timeout per host (`--host-timeout`)
- Useful for mapping firewall rules

**Usage**:
```bash
./4-ask_scan.sh www.holbertonschool.com 80,22,25
```

---

### 6. TCP Window Scan (-sW) 🔍
**File**: `5-window_scan.sh`

**Principle**: Analyzes the TCP window size in RST packets to determine port status.

**Features**:
- Accepts host, ports, and ports to exclude
- Non-zero window = open port
- Zero window = closed port

**Usage**:
```bash
./5-window_scan.sh www.holbertonschool.com 20-30 25-28
```

---

### 7. Custom Scan (--scanflags) ⚙️
**File**: `6-custom_scan.sh`

**Principle**: Sends packets with ALL TCP flags set (URG+ACK+PSH+RST+SYN+FIN).

**Features**:
- Non-standard packets used to bypass defenses
- Saves to `custom_scan.txt`
- No screen output (redirected to `/dev/null`)

**Usage**:
```bash
./6-custom_scan.sh www.holbertonschool.com 80-90
cat custom_scan.txt
```

---

## Project Structure

```
0x06_nmap_advanced_port_scans/
├── README.md
├── 0-null_scan.sh
├── 1-fin_scan.sh
├── 2-xmas_scan.sh
├── 3-maimon_scan.sh
├── 4-ask_scan.sh
├── 5-window_scan.sh
└── 6-custom_scan.sh
```

## Summary Table

| Scan | TCP Flag(s) | Stealth | Ports | Purpose |
|------|-------------|---------|-------|---------|
| NULL | None | ⭐⭐⭐⭐⭐ | 20-25 | Basic firewall bypass |
| FIN | FIN | ⭐⭐⭐⭐ | 80-85 | Stealthy reconnaissance |
| Xmas | FIN+PSH+URG | ⭐⭐⭐ | 440-450 | Detailed analysis |
| Maimon | FIN+ACK | ⭐⭐⭐⭐ | Common services | Service detection |
| ACK | ACK | ⭐⭐⭐ | Custom | Firewall mapping |
| Window | ACK | ⭐⭐⭐⭐ | Custom | SYN alternative |
| Custom | ALL | ⭐ | Custom | Advanced testing |

## Key Concepts

### Bash Redirections

```bash
> /dev/null       # Redirects stdout to /dev/null (suppresses output)
2>&1              # Redirects stderr to stdout
>/dev/null 2>&1   # Suppresses all output (stdout + stderr)
&> /dev/null      # Equivalent shortcut
```

### Port States

- **open**: Port is open, service listening
- **closed**: Port is closed, no service
- **filtered**: Firewall blocks/filters the port
- **unfiltered**: Port is accessible but state unknown
- **open|filtered**: Nmap cannot determine

### TCP Flags

| Flag | Meaning | Usage |
|------|---------|-------|
| SYN | Synchronize | Initiate connection |
| ACK | Acknowledge | Acknowledge receipt |
| FIN | Finish | Terminate connection |
| RST | Reset | Reset connection |
| PSH | Push | Send immediately |
| URG | Urgent | Urgent data |

## Security Considerations

- **Authorization**: Only scan networks you have permission to test
- **Legality**: Unauthorized scans may be illegal in your jurisdiction
- **Ethics**: Use these techniques only for legitimate security audits, CTF, or test environments
- **Detection**: Scans can be detected by IDS/IPS systems

## Resources

- [Nmap Official Documentation](https://nmap.org/book/man.html)
- [Nmap Scan Types](https://nmap.org/book/man-port-scanning-techniques.html)
- [TCP/IP Protocol Fundamentals](https://www.ietf.org/rfc/rfc793.txt)

## Author

**Holberton School** - Cyber Security Project

---

**Note**: This project is for educational purposes only. Use these tools responsibly and ethically.
