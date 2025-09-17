# 🛡️ OWASP Top 10 - Web Application Security

<div align="center">

![OWASP](https://img.shields.io/badge/OWASP-Top%2010-red?style=for-the-badge&logo=owasp)
![Security](https://img.shields.io/badge/Security-Web%20Application-blue?style=for-the-badge&logo=security)
![Holberton](https://img.shields.io/badge/Holberton-School-orange?style=for-the-badge)

**Practical exercises on the most critical web vulnerabilities**

</div>

---

## 📋 Table of Contents

- [About](#about)
- [Project Structure](#project-structure)
- [Exercises](#exercises)
- [Tools and Technologies](#tools-and-technologies)
- [Installation](#installation)
- [Usage](#usage)
- [Resources](#resources)
- [Security Warnings](#security-warnings)
- [Contributing](#contributing)
- [License](#license)

---

<h2 id="about">🎯 About</h2>

This project is part of the **Holberton School - Cyber Security** curriculum and focuses on the practical study of the **OWASP Top 10**, the ten most critical web security vulnerabilities.

### Learning Objectives

- 🔍 Identify common web vulnerabilities
- 🛠️ Understand exploitation techniques
- 🔒 Learn protection methods
- 💡 Develop a defensive security mindset

---

<h2 id="project-structure">📁 Project Structure</h2>

```
0x01_owasp_top_10/
├── README.md                    # Main documentation
├── README_xor_decoder.md        # XOR decoder documentation
├── 0-flag.txt                   # Challenge 0 flag
├── 1-xor_decoder.sh            # WebSphere XOR decoding script
├── 2-flag.txt                   # Challenge 2 flag
├── 3-flag.txt                   # Challenge 3 flag
└── 4-vuln.txt                   # Vulnerability analysis
```

---

<h2 id="exercises">🎮 Exercises</h2>

### Challenge 0: Reconnaissance
- **File**: `0-flag.txt`
- **Objective**: Information discovery and analysis
- **Flag**: `z2d4d0eade9d64db4c2cfa297bb89abfc`

### Challenge 1: WebSphere XOR Decoding
- **File**: `1-xor_decoder.sh`
- **Objective**: Decode obfuscated WebSphere passwords
- **Type**: Cryptanalysis and reverse engineering

#### Usage example:
```bash
./1-xor_decoder.sh {xor}KzosKw==
# Output: test
```

### Challenge 2: Web Exploitation
- **File**: `2-flag.txt`
- **Flag**: `1c45863521d3d149ebdc35dc7a1cbb2c`

### Challenge 3: Security Analysis
- **File**: `3-flag.txt`
- **Flag**: `1d6905659293f517d00668f7ea02eec6`

### Challenge 4: Vulnerability Identification
- **File**: `4-vuln.txt`
- **Identified vulnerability**: `bio`

---

<h2 id="tools-and-technologies">🛠️ Tools and Technologies</h2>

### Languages and Scripts
- ![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)
- ![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)

### Python Modules Used
- `base64` - Base64 decoding
- `sys` - System argument management

### Security Techniques
- **Cryptanalysis**: XOR decoding
- **Obfuscation**: WebSphere mechanism analysis
- **Reverse Engineering**: Algorithm deconstruction

---

<h2 id="installation">⚙️ Installation</h2>

### Prerequisites
```bash
# Check Python version
python3 --version

# Check Bash
bash --version
```

### Configuration
```bash
# Clone the repository
git clone <repository-url>

# Navigate to the folder
cd holbertonschool-cyber_security/web_application_security/0x01_owasp_top_10

# Make scripts executable
chmod +x 1-xor_decoder.sh
```

---

<h2 id="usage">🚀 Usage</h2>

### WebSphere XOR Decoder

The `1-xor_decoder.sh` script allows you to decode obfuscated passwords used by IBM WebSphere:

```bash
# General syntax
./1-xor_decoder.sh {xor}<base64_encoded_data>

# Practical examples
./1-xor_decoder.sh {xor}KzosKw==     # Output: test
./1-xor_decoder.sh {xor}NzozMzA=     # Output: hello
```

### 🔍 How does it work?

1. **Extraction**: Removes the `{xor}` prefix
2. **Decoding**: Converts Base64 to binary data
3. **XOR**: Applies XOR operation with key `95`
4. **Conversion**: Transforms to readable ASCII characters

---

<h2 id="resources">📚 Resources</h2>

### OWASP Top 10 (2021)
1. **A01:2021** – Broken Access Control
2. **A02:2021** – Cryptographic Failures
3. **A03:2021** – Injection
4. **A04:2021** – Insecure Design
5. **A05:2021** – Security Misconfiguration
6. **A06:2021** – Vulnerable and Outdated Components
7. **A07:2021** – Identification and Authentication Failures
8. **A08:2021** – Software and Data Integrity Failures
9. **A09:2021** – Security Logging and Monitoring Failures
10. **A10:2021** – Server-Side Request Forgery (SSRF)

### Useful Links
- [🌐 OWASP Official Website](https://owasp.org/)
- [📖 OWASP Top 10 Documentation](https://owasp.org/www-project-top-ten/)
- [🎓 WebSphere Security Guide](https://www.ibm.com/docs/en/was)

---

<h2 id="security-warnings">⚠️ Security Warnings</h2>

> **Important**: The techniques presented in this project are for educational purposes only. 
> Using these methods on systems without explicit authorization is illegal.

### Best Practices
- ✅ Test only on your own systems
- ✅ Use laboratory environments
- ✅ Respect local and international laws
- ❌ Never exploit vulnerabilities on third-party systems

---

<h2 id="contributing">🤝 Contributing</h2>

This project is part of the Holberton School curriculum. Contributions are welcome for:

- 📝 Improving documentation
- 🐛 Fixing bugs
- ✨ Adding new examples
- 🔧 Optimizing existing scripts

### Contribution Process
1. Fork the project
2. Create a branch for your feature
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

---

<h2 id="license">📝 License</h2>

This project is developed as part of the Holberton School - Cyber Security program.

---

<div align="center">

**Made with ❤️ for Cyber Security Education**

![Holberton School](https://img.shields.io/badge/Holberton-School-orange?style=flat&logo=holberton&logoColor=white)

</div>