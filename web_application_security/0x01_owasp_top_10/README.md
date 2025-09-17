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

This project is part of the **Holberton School - Cyber Security** curriculum and focuses on the practical study of the **OWASP Top 10**, specifically targeting the most critical web security vulnerabilities through hands-on exploitation exercises.

### Learning Objectives

- 🔍 Master **Cryptographic Failures** (A2:2021) through XOR decoding and encoding analysis
- 🛠️ Exploit **Injection vulnerabilities** (A3:2021) including Stored Cross-Site Scripting (XSS)
- � Understand **WebSphere security mechanisms** and their weaknesses
- 💡 Develop practical penetration testing skills for web applications
- 🧪 Learn to identify vulnerable input fields and exploit them ethically

### OWASP Categories Covered

- **A2:2021 - Cryptographic Failures**: Weak encoding mechanisms, password obfuscation bypass
- **A3:2021 - Injection**: Stored XSS vulnerabilities, profile manipulation attacks
- **Reverse Engineering**: IBM WebSphere XOR decoding algorithms

---

<h2 id="project-structure">📁 Project Structure</h2>

```
0x01_owasp_top_10/
├── README.md                    # Main documentation
├── README_xor_decoder.md        # XOR decoder documentation
├── 0-flag.txt                   # Challenge 0: Reconnaissance flag
├── 1-xor_decoder.sh            # Challenge 1: WebSphere XOR decoding script
├── 2-flag.txt                   # Challenge 2: Cryptographic Failures flag
├── 3-flag.txt                   # Challenge 3: Stored XSS (Part 1/3) flag
└── 4-vuln.txt                   # Challenge 4: XSS vulnerable field identification
```

---

<h2 id="exercises">🎮 Exercises</h2>

### Challenge 0: Reconnaissance
- **File**: `0-flag.txt`
- **Objective**: Information discovery and analysis
- **Flag**: `z2d4d0eade9d64db4c2cfa297bb89abfc`

---

### Challenge 1: WebSphere XOR Decoder
- **File**: `1-xor_decoder.sh`
- **Objective**: Create a Bash script that decodes XOR WebSphere obfuscated passwords
- **Type**: Cryptanalysis and reverse engineering
- **Score**: 4/4 pts

**📋 Requirements:**
- Accept the hash as argument: `$1`
- Decode WebSphere XOR obfuscated data format: `{xor}base64_encoded_data`
- Match the exact output format shown below

**💻 Expected Usage:**
```bash
┌──(user㉿hbtn-lab)-[~/…/web_application_security/0x1_owasp_top_10]
└─$ ./1-xor_decoder.sh {xor}KzosKw==
test
```

**🔧 Technical Details:**
- Process: Remove `{xor}` prefix, decode Base64, XOR each byte with key `95`
- Output: Plain text password without newline

---

### Challenge 2: (A2:2021) - Cryptographic Failures - Catch The Flag
- **File**: `2-flag.txt`
- **Objective**: Exploit cryptographic encoding failures to retrieve login credentials
- **OWASP Category**: A2:2021 - Cryptographic Failures
- **Score**: 6/6 pts

**🎯 Mission:**
1. Navigate to the target machine `cyber_websec_0x01`
2. Access: **A2 - Cryptographic Failures → Encoding Failure**
3. Find login credentials to retrieve the flag after signing in

**🌐 Target Endpoints:**
- **Login Page**: `http://[MACHINE-IP]/a2/crypto_encoding_failure/`
- **Profile Page**: `http://[MACHINE-IP]/a2/crypto_encoding_failure/profile`

**💡 Hints:**
- Analyze the headers of all Fetch/XHR requests
- Use the XOR decoder from the previous task to decrypt the password
- Monitor network traffic for encoded credentials

**🔍 Where to Start:**
- Use browser developer tools (F12) to inspect network requests
- Look for encoded data in request/response headers
- Apply XOR decoding techniques learned in Challenge 1

---

### Challenge 3: (A3:2021) - Injection [Stored XSS] - Part 1/3
- **File**: `3-flag.txt`
- **Objective**: Identify and follow specific profiles to exploit Stored XSS vulnerability
- **OWASP Category**: A3:2021 - Injection
- **Score**: 6/6 pts

**🦠 Context:**
This exercise mimics the famous **Samy worm** that propagated across MySpace in 2005 by exploiting Cross-Site Scripting (XSS) vulnerabilities.

**🎯 Mission: Identifying Profiles to Follow**

**📋 Instructions:**

1. **Navigate and Capture Requests:**
   - Explore the web application thoroughly
   - Monitor network requests and responses using browser developer tools (F12)
   - Pay attention to user data exchanges

2. **Identify Profile IDs:**
   - Look for requests that return user information
   - Identify **three specific profile IDs** that you need to follow
   - These profiles are crucial for the next steps

3. **Follow the Profiles:**
   - Navigate to each profile: `http://[MACHINE-IP]/a3/xss_stored/profile/[PROFILE-ID]`
   - Follow each profile by clicking the **heart icon** or designated follow button

4. **Catch the Flag:**
   - Return to your profile to find your waiting Flag ⛳️

**🔧 Tools Required:**
- Browser developer tools for network monitoring
- Understanding of HTTP requests/responses
- Profile navigation and interaction capabilities

---

### Challenge 4: (A3:2021) - Injection [Stored XSS] - Part 2/3
- **File**: `4-vuln.txt`
- **Objective**: Discover vulnerable input field susceptible to Cross-Site Scripting
- **OWASP Category**: A3:2021 - Injection
- **Score**: Points TBD

**🎯 Mission: Discovering a Vulnerable Input Field**

**📋 Instructions:**

1. **Explore Edit Profile Page:**
   - Navigate to: `http://[MACHINE-IP]/a3/xss_stored/edit`
   - Examine multiple input fields for personal information updates

2. **Test for XSS Vulnerability:**
   - Test each input field with XSS payload: `<script>alert('XSS')</script>`
   - Save changes after entering the payload
   - Observe which field triggers JavaScript alert when viewing your profile

3. **Analyze Source Code Behavior:**
   - Examine how quotes are handled in the source code
   - Identify the vulnerable field name

4. **Submit the Vulnerable Field Name:**
   ```bash
   $ echo "fieldname" > 4-vuln.txt
   ```

**💡 Key Points:**
- XSS vulnerability occurs when user input is not properly sanitized
- Stored XSS persists the malicious script in the application's database
- Pay attention to quote handling and input validation mechanisms

**🔍 What to Look For:**
- Input fields that don't escape HTML/JavaScript
- Fields where script tags are executed upon page load
- Improper quote handling in form submissions

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