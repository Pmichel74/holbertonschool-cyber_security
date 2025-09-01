# 🦈 0x05 - Wireshark Basics

![Wireshark Logo](https://img.shields.io/badge/Wireshark-1679A7?style=for-the-badge&logo=wireshark&logoColor=white)
![Network Security](https://img.shields.io/badge/Network_Security-FF6B6B?style=for-the-badge&logo=security&logoColor=white)
![Holberton](https://img.shields.io/badge/Holberton-FF4500?style=for-the-badge&logo=holberton&logoColor=white)

## 📋 Table of Contents

- [📖 Description](#-description)
- [🎯 Learning Objectives](#-learning-objectives)
- [🛠️ Requirements](#️-requirements)
- [📁 Files and Tasks](#-files-and-tasks)
- [🔍 Wireshark Filters Guide](#-wireshark-filters-guide)
- [🚀 Getting Started](#-getting-started)
- [📚 Resources](#-resources)
- [👨‍💻 Author](#-author)

## 📖 Description

This project introduces the fundamentals of network packet analysis using **Wireshark**, the world's most popular network protocol analyzer. You'll learn to create filters to detect various network scanning techniques and understand how different network reconnaissance tools work at the packet level.

## 🎯 Learning Objectives

By the end of this project, you will be able to:

- 🔍 Use Wireshark to capture and analyze network traffic
- 🎯 Create effective display filters for packet analysis
- 🛡️ Identify common network scanning techniques (nmap, etc.)
- 📊 Understand network protocols at the packet level
- 🔒 Detect security-related network activities
- 📈 Analyze different types of port scans and ping sweeps

## 🛠️ Requirements

### Software Requirements
- **OS**: Ubuntu 20.04 LTS or later
- **Tools**: Wireshark, nmap
- **Network**: Access to capture network traffic
- **Permissions**: sudo access for packet capture

### Installation

```bash
# Install Wireshark
sudo apt update
sudo apt install wireshark

# Install nmap for testing
sudo apt install nmap

# Add user to wireshark group (optional, for GUI access)
sudo usermod -a -G wireshark $USER
```

## 📁 Files and Tasks

| File | Task | Description | Filter Type |
|------|------|-------------|-------------|
| `0-ip_scan.txt` | 📡 IP Scan Detection | Filter to detect IP scanning activities | IP Layer |
| `1-tcp_syn.txt` | 🔌 TCP SYN Scan | Identify TCP SYN port scanning | TCP SYN |
| `2-tcp_connect_scan.txt` | 🤝 TCP Connect Scan | Detect full TCP connection scans | TCP Connect |
| `3-tcp_fin.txt` | 🏁 TCP FIN Scan | Filter for TCP FIN scan detection | TCP FIN |
| `4-tcp_ping_sweep.txt` | 📊 TCP Ping Sweep | Identify TCP-based host discovery | TCP Ping |
| `5-udp_port_scan.txt` | 🔍 UDP Port Scan | Detect UDP port scanning | UDP Scan |
| `6-udp_ping_sweep.txt` | 📡 UDP Ping Sweep | Filter for UDP-based ping sweeps | UDP Ping |
| `7-icmp_ping_sweep.txt` | 🏓 ICMP Ping Sweep | Detect ICMP ping sweep activities | ICMP |
| `8-arp_scanning.txt` | 🗺️ ARP Scanning | Identify ARP-based network discovery | ARP |

## 🔍 Wireshark Filters Guide

### Common Filter Syntax

| Filter Type | Syntax | Example |
|-------------|--------|---------|
| **Protocol** | `protocol` | `tcp`, `udp`, `icmp`, `arp` |
| **Port** | `tcp.port == X` | `tcp.port == 80` |
| **IP Address** | `ip.src == X` | `ip.src == 192.168.1.1` |
| **Flags** | `tcp.flags.syn == 1` | TCP SYN flag set |
| **Length** | `frame.len > X` | `frame.len > 1000` |

### 🎯 Scanning Detection Patterns

#### Port Scans
- **SYN Scan**: `tcp.flags.syn == 1 and tcp.flags.ack == 0`
- **Connect Scan**: `tcp.flags.syn == 1 and tcp.flags.ack == 1`
- **FIN Scan**: `tcp.flags.fin == 1 and tcp.flags.syn == 0`

#### Host Discovery
- **ICMP Ping**: `icmp.type == 8`
- **TCP Ping**: `tcp.flags.syn == 1 and tcp.window_size <= 1024`
- **UDP Ping**: `udp.length == 8`

#### Network Discovery
- **ARP Scan**: `arp.dst.hw_mac == 00:00:00:00:00:00`

## 🚀 Getting Started

### 1. Launch Wireshark
```bash
# Command line
sudo wireshark

# Or use the GUI from applications menu
```

### 2. Select Network Interface
- Choose your active network interface (usually `eth0` or `wlan0`)
- Start packet capture

### 3. Generate Test Traffic
```bash
# Example: Run a SYN scan to test your filters
nmap -sS 192.168.1.0/24

# Example: Run a ping sweep
nmap -sn 192.168.1.0/24

# Example: UDP scan
nmap -sU 192.168.1.1
```

### 4. Apply Filters
- Copy the filter from the appropriate `.txt` file
- Paste it into Wireshark's display filter bar
- Press Enter to apply

## 📚 Resources

### Official Documentation
- 📖 [Wireshark User Guide](https://www.wireshark.org/docs/wsug_html_chunked/)
- 🔧 [Wireshark Display Filters](https://www.wireshark.org/docs/dfref/)
- 🗺️ [Nmap Documentation](https://nmap.org/book/)

### Tutorials
- 🎓 [Wireshark Tutorial for Beginners](https://www.wireshark.org/docs/wsug_html_chunked/ChapterIntroduction.html)
- 🛡️ [Network Security with Wireshark](https://www.sans.org/white-papers/)

### Cheat Sheets
- ⚡ [Wireshark Display Filters Cheat Sheet](https://www.comparitech.com/net-admin/wireshark-cheat-sheet/)
- 🔍 [Nmap Cheat Sheet](https://www.stationx.net/nmap-cheat-sheet/)

## 🏆 Tips and Best Practices

### 🎯 Effective Filtering
1. **Be Specific**: Use multiple conditions to reduce false positives
2. **Test Filters**: Verify your filters capture the intended traffic
3. **Document**: Comment your complex filters for future reference

### 🔒 Security Considerations
- ⚠️ Only capture traffic on networks you own or have permission to monitor
- 🔐 Be aware of privacy implications when analyzing network traffic
- 📝 Follow your organization's security policies

### 📊 Analysis Tips
- 📈 Look for patterns in timing and frequency
- 🔍 Cross-reference multiple protocols
- 📋 Use statistics menu for traffic summaries

## 🐛 Troubleshooting

### Common Issues
| Problem | Solution |
|---------|----------|
| Permission denied | Run with `sudo` or add user to wireshark group |
| No interfaces shown | Check network adapter and drivers |
| Filter not working | Verify syntax and protocol names |

## 👨‍💻 Author

**Patrick Michel**
- 🏫 Holberton School - Cybersecurity Track
- 📧 Contact: [patrick.yann.michel@gmail.com]
- 🐙 GitHub: [Pmichel74]

---

*This project is part of the Holberton School Cybersecurity curriculum - Network Security module*

![Footer](https://img.shields.io/badge/Made_with-❤️-red?style=flat-square)
![Holberton](https://img.shields.io/badge/School-Holberton-orange?style=flat-square)