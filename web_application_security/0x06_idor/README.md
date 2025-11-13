# 0x06. IDOR - Insecure Direct Object References 🏦

<div align="center">

![Cybersecurity](https://img.shields.io/badge/Cybersecurity-Web%20Application%20Security-red?style=for-the-badge&logo=security)
![IDOR](https://img.shields.io/badge/Vulnerability-IDOR-orange?style=for-the-badge&logo=hack-the-box)
![Burp Suite](https://img.shields.io/badge/Tool-Burp%20Suite-blue?style=for-the-badge&logo=burp-suite)
![Score](https://img.shields.io/badge/Score-100%25-success?style=for-the-badge&logo=target)

### 🔓 Break into CyberBank & Master IDOR Vulnerabilities 🔓

*A hands-on journey through Insecure Direct Object References in a realistic banking simulation*

[📖 Overview](#-overview) • [🎯 Objectives](#-learning-objectives) • [🏦 CyberBank](#-cyberbank-simulation) • [📝 Tasks](#-project-tasks) • [🛠️ Tools](#%EF%B8%8F-tools--setup) • [🚀 Resources](#-additional-resources)

---

</div>

## 🌟 Overview

Welcome to the **IDOR Challenge**! This project takes you deep into the world of web application security through a simulated banking environment called **CyberBank**. 

You'll discover, exploit, and document critical vulnerabilities that affect millions of real-world applications. By the end, you'll understand how attackers breach systems and how developers can protect them.

### 💡 What is an IDOR?

**IDOR (Insecure Direct Object Reference)** occurs when an application exposes direct references to internal objects without proper authorization checks.

```diff
- ❌ Vulnerable:  GET /api/customer/info/12345
+ ✅ Secure:      Verify user owns resource before access
```

**Real-world Impact:**
- 💸 Financial theft (unauthorized transfers)
- 🔓 Data breaches (access to private information)
- 🎭 Identity theft (impersonation attacks)
- 🏛️ Regulatory violations (GDPR, PCI DSS)

---

## 🎯 Learning Objectives

<table>
<tr>
<td width="50%">

### 🔍 Technical Skills
- ✅ Identify IDOR vulnerabilities in web applications
- ✅ Master **Burp Suite** (Proxy, Repeater, Intruder)
- ✅ Intercept and manipulate HTTP/S traffic
- ✅ Enumerate resources systematically
- ✅ Chain multiple vulnerabilities for impact

</td>
<td width="50%">

### 🛡️ Security Expertise
- ✅ Understand **Broken Access Control** (OWASP #1)
- ✅ Exploit business logic flaws
- ✅ Bypass authentication mechanisms
- ✅ Document findings professionally
- ✅ Think like both attacker & defender

</td>
</tr>
</table>

---

## 🏦 CyberBank Simulation

<div align="center">

```ascii
╔══════════════════════════════════════════════════════════╗
║                    🏦 CYBERBANK 🏦                       ║
║              Your Target Banking Application             ║
╠══════════════════════════════════════════════════════════╣
║  🌐 URL: http://web0x06.hbtn                            ║
║  🎯 Mission: Find & exploit IDOR vulnerabilities        ║
║  🚩 Goal: Capture all flags & write security report     ║
╚══════════════════════════════════════════════════════════╝
```

</div>

### 🔴 Vulnerable Areas

| Component | Vulnerability | Impact |
|-----------|--------------|--------|
| 👤 **User Profiles** | No ownership validation | Access any user's data |
| 💰 **Bank Accounts** | Direct account_id exposure | View all balances |
| 💸 **Wire Transfers** | Missing authorization | Steal money from anyone |
| 💳 **Card Payments** | 3D Secure bypass | Fraudulent transactions |

⚠️ **Disclaimer:** This is a **legal, authorized learning environment**. Never test these techniques on real systems without written permission!

---

## 📚 Essential Resources

<details>
<summary>🔗 Click to expand resources</summary>

### 📖 Official Documentation
- [OWASP Top 10 - A01:2021 Broken Access Control](https://owasp.org/Top10/A01_2021-Broken_Access_Control/)
- [PortSwigger Web Security Academy - IDOR](https://portswigger.net/web-security/access-control/idor)
- [OWASP Testing Guide - IDOR Testing](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/05-Authorization_Testing/04-Testing_for_Insecure_Direct_Object_References)

### 🛠️ Tools
- [Burp Suite Community (FREE)](https://portswigger.net/burp/communitydownload) - Essential HTTP proxy
- [Browser DevTools](https://developer.chrome.com/docs/devtools/) - Built-in network analysis

### 📺 Video Tutorials
- [PortSwigger Academy - Free Labs](https://portswigger.net/web-security/all-labs)
- [HackerOne IDOR Case Studies](https://www.hackerone.com/vulnerability-management/what-insecure-direct-object-reference-idor)

</details>

---

## 🔧 Requirements & Setup

### ✅ Prerequisites

<table>
<tr>
<td width="50%">

**💡 Knowledge**
```
✓ HTTP protocol basics
✓ REST API concepts
✓ JSON format
✓ Terminal commands
```

</td>
<td width="50%">

**💻 Software**
```
✓ Web Browser (Firefox/Chrome)
✓ Burp Suite Community
✓ cURL (optional)
✓ jq (optional)
```

</td>
</tr>
</table>

### ⚙️ Burp Suite Configuration

```bash
# Quick Setup Guide
1. Download Burp Suite Community Edition
2. Configure browser proxy: 127.0.0.1:8080
3. Start Burp Suite
4. Enable interception: Proxy → Intercept is on
5. Browse to http://web0x06.hbtn
```

<details>
<summary>🔍 Detailed Firefox/Chrome proxy setup</summary>

**Firefox:**
1. Settings → Network Settings → Manual proxy configuration
2. HTTP Proxy: `127.0.0.1`, Port: `8080`
3. Check "Use this proxy for all protocols"

**Chrome:**
1. Install FoxyProxy extension
2. Add proxy: `127.0.0.1:8080`
3. Toggle proxy on when testing

</details>

---

## 📝 Project Tasks

<div align="center">

### 🎮 Your Mission: Complete 4 Progressive Challenges

</div>

---

### 🔍 Task 0: Uncovering User IDs

<table>
<tr>
<td width="70%">

**🎯 Mission:** Discover how CyberBank exposes user identifiers

**📍 Starting Point:** `http://web0x06.hbtn/dashboard`

**🔑 Key Steps:**
1. Log in with provided credentials
2. Open DevTools (F12) → Network tab (enable "Preserve log")
3. Explore the application and observe API calls
4. Find endpoints exposing User IDs:
   - `/api/customer/info/me` → Your own ID
   - `/api/customer/contacts` → Everyone's IDs! 🚨
5. Test IDOR: Access `/api/customer/info/{another_user_id}`
6. Capture the flag from victim's profile

</td>
<td width="30%">

```ascii
┌─────────────┐
│ Difficulty  │
├─────────────┤
│ ⭐ Easy     │
└─────────────┘

┌─────────────┐
│   Concepts  │
├─────────────┤
│ • Enumeration│
│ • Info leak │
│ • IDOR basics│
└─────────────┘
```

**📁 Output:**
`0-flag.txt`

**✅ Score:** 100%

</td>
</tr>
</table>

<details>
<summary>💡 Hint: Where to look?</summary>

Look for API endpoints that return user lists or accept user IDs as parameters. The browser's Network tab is your best friend!

</details>

---

### 💰 Task 1: Enumerating Account Numbers

<table>
<tr>
<td width="70%">

**🎯 Mission:** Use discovered User IDs to access bank account balances

**🔑 Key Steps:**
1. Use User IDs from Task 0
2. Explore financial endpoints:
   - `/api/customer/transactions` → Exposes `account_id` 🚨
   - `/api/customer/info/{user_id}` → Contains `accounts_id[]`
3. Find vulnerable endpoint: `/api/accounts/info/{account_id}`
4. Test IDOR by swapping account IDs
5. Access other users' balances and account details
6. Locate the flag in a target account

</td>
<td width="30%">

```ascii
┌─────────────┐
│ Difficulty  │
├─────────────┤
│ ⭐⭐ Medium │
└─────────────┘

┌─────────────┐
│   Concepts  │
├─────────────┤
│ • Horizontal│
│   escalation│
│ • Financial │
│   data leak │
└─────────────┘
```

**📁 Output:**
`1-flag.txt`

**✅ Score:** 100%

</td>
</tr>
</table>

<details>
<summary>💡 Hint: Transaction history is gold</summary>

Transaction logs often reveal account IDs of both sender and receiver. Check the `receiver_payment_id` fields!

</details>

---

### 💸 Task 2: Wire Transfer Exploitation

<table>
<tr>
<td width="70%">

**🎯 Mission:** Steal money from 20 accounts to reach $10,000+ balance

**🔥 Advanced Technique:** Burp Suite Intruder automation

**🔑 Key Steps:**
1. Analyze transfer endpoint: `/api/accounts/transfer_to/{destination}`
2. Identify required parameters: `account_id`, `routing`, `number`, `amount`
3. **Phase 1 - Reconnaissance:**
   - Use Intruder to gather credentials from 20 accounts
   - Endpoint: `/api/accounts/info/{account_id}`
4. **Phase 2 - Exploitation:**
   - Configure Pitchfork attack with 4 payload sets
   - Transfer funds from all 20 accounts to yours
5. Reach $10,000 balance → Unlock flag_2! 🎉

</td>
<td width="30%">

```ascii
┌─────────────┐
│ Difficulty  │
├─────────────┤
│ ⭐⭐⭐ Hard │
└─────────────┘

┌─────────────┐
│   Tools     │
├─────────────┤
│ • Burp Proxy│
│ • Intruder  │
│ • Repeater  │
└─────────────┘
```

**📁 Output:**
`2-flag.txt`

**✅ Score:** 100%

</td>
</tr>
</table>

<details>
<summary>🛠️ Burp Intruder Configuration Tip</summary>

**Attack Type:** Pitchfork (synchronizes multiple payload sets)

**Payloads needed:**
1. Amount (balance - 1)
2. Account ID
3. Routing number
4. Account number

Set delay to 500ms to avoid rate limiting!

</details>

---

### 💳 Task 3: Bypassing 3D Secure for Fraudulent Payments

<table>
<tr>
<td width="70%">

**🎯 Mission:** Complete unauthorized payment using stolen card + OTP

**💀 Attack Chain:** 5-step IDOR exploitation

**🔑 Key Steps:**
1. **Step 1:** Get victim's `card_id` from `/api/customer/transactions`
2. **Step 2:** Steal card details via `/api/cards/info/{card_id}`
   - Number, CVV, expiration date 🔓
3. **Step 3:** Initialize payment with stolen card: `/api/cards/init_payment`
4. **Step 4:** 🚨 **CRITICAL EXPLOIT** → Get victim's OTP!
   - `/api/cards/3dsecure/{card_id}` exposes the OTP
5. **Step 5:** Confirm payment: `/api/cards/confirm_payment/{payment_id}`
   - Use stolen card number + OTP
6. Payment successful → Flag_3 captured! 🎯

</td>
<td width="30%">

```ascii
┌─────────────┐
│ Difficulty  │
├─────────────┤
│⭐⭐⭐⭐Expert│
└─────────────┘

┌─────────────┐
│  Critical!  │
├─────────────┤
│ • PCI DSS   │
│   violation │
│ • 3D Secure │
│   bypass    │
│ • Identity  │
│   theft     │
└─────────────┘
```

**📁 Output:**
`3-flag.txt`

**✅ Score:** 100%

</td>
</tr>
</table>

<details>
<summary>🎯 Pro Tip: Use 3 Repeater tabs</summary>

Open 3 tabs in Burp Repeater for the attack chain:
- Tab 1: Init payment
- Tab 2: Get OTP
- Tab 3: Confirm payment

Execute them in sequence!

</details>

---

### 📋 Task 4: Professional Vulnerability Report

<table>
<tr>
<td width="70%">

**🎯 Mission:** Document your findings like a real penetration tester

**📝 Report Structure:**
1. **Introduction** - What is CyberBank? Why this assessment?
2. **Methodology** - Tools used, testing approach
3. **Vulnerability Details** - For EACH flaw:
   - Technical description
   - Severity/Impact rating
   - Step-by-step reproduction
   - Screenshots/evidence (request/response pairs)
4. **Additional Findings** - Other issues discovered:
   - Missing rate limiting
   - Session timeout issues
   - No MFA/2FA
   - Logging gaps
5. **Recommendations** - Specific fixes with code examples
6. **Conclusion** - Summary of critical risks
7. **References** - OWASP, PCI DSS, etc.

</td>
<td width="30%">

```ascii
┌─────────────┐
│   Format    │
├─────────────┤
│ Google Docs │
│ or PDF      │
└─────────────┘

┌─────────────┐
│  Must Have  │
├─────────────┤
│ ✓ Screenshots│
│ ✓ HTTP traces│
│ ✓ Code fixes│
│ ✓ Criticality│
└─────────────┘
```

**📤 Submission:**
Google Docs link
(public read-only)

**✅ Mandatory**

</td>
</tr>
</table>

<details>
<summary>📸 Screenshot Checklist</summary>

Essential screenshots to include:
- [ ] User enumeration (Task 0)
- [ ] Account balance disclosure (Task 1)
- [ ] Burp Intruder results (Task 2)
- [ ] OTP exposure (Task 3)
- [ ] Successful exploits with flags

</details>

## 🛠️ Tools & Setup

<div align="center">

### 🎯 Your Hacker Toolkit

</div>

<table>
<tr>
<td width="33%">

### 🔥 Burp Suite
**The Swiss Army Knife**

- **Proxy** - Intercept HTTP/S
- **Repeater** - Manual testing
- **Intruder** - Automated attacks
- **Decoder** - Decode data

```bash
# Free version includes
# all essential features!
```

</td>
<td width="33%">

### 🌐 Browser DevTools
**Built-in Power Tools**

- **Network Tab** - API monitoring
- **Console** - JavaScript debug
- **Application** - Cookie inspector
- **Sources** - Code review

```bash
# Shortcut: F12
# Chrome, Firefox, Edge
```

</td>
<td width="33%">

### ⚙️ Command Line
**Terminal Ninjas**

- **cURL** - API testing
- **jq** - JSON parsing
- **grep** - Pattern search
- **wget** - File download

```bash
# Install on Ubuntu:
sudo apt install curl jq
```

</td>
</tr>
</table>

### 📦 Quick Start Commands

```bash
# Test an endpoint with cURL
curl -H "Cookie: session=YOUR_SESSION" \
     http://web0x06.hbtn/api/customer/info/me | jq .

# Pretty-print JSON response
curl -s http://web0x06.hbtn/api/customer/transactions | jq '.[]'

# Extract specific fields
curl -s http://web0x06.hbtn/api/customer/transactions | jq '.[].account_id'
```

---

## 📁 Project Structure

```
0x06_idor/
│
├── 📄 README.md                 ← You are here!
├── 🚫 .gitignore                ← Keep secrets safe
│
├── 🚩 0-flag.txt                ← Task 0: User IDs
├── 🚩 1-flag.txt                ← Task 1: Account Numbers  
├── 🚩 2-flag.txt                ← Task 2: Wire Transfers ($10k!)
├── 🚩 3-flag.txt                ← Task 3: 3D Secure Bypass
│
├── 📝 WRITEUP_TASK_0.md        ← Detailed solutions (not committed)
├── 📝 WRITEUP_TASK_1.md        
├── 📝 WRITEUP_TASK_2_BURP.md   
├── 📝 WRITEUP_TASK_3_BURP.md   
│
└── 📋 VULNERABILITY_REPORT.md  ← Professional report (not committed)
```

---

## 🎓 Key Concepts Deep Dive

<details>
<summary><b>🔍 1. IDOR - Insecure Direct Object References</b></summary>

**What it is:** Direct access to resources using predictable identifiers without authorization checks.

**Example Attack:**
```http
GET /api/customer/info/123  ← Attacker changes ID
Host: vulnerable-bank.com
Cookie: session=attacker_session

→ Returns victim's data! 🚨
```

**Real-world cases:**
- USPS informed delivery breach (2018)
- Instagram account takeovers
- Financial institutions data leaks

</details>

<details>
<summary><b>🚪 2. Broken Access Control (OWASP #1)</b></summary>

**Why it's #1:** Most common vulnerability in 2021-2024.

**Variants:**
- Horizontal escalation (access peer's data)
- Vertical escalation (access admin functions)
- Missing function-level controls

**Impact:** Complete system compromise

</details>

<details>
<summary><b>🔓 3. Information Disclosure</b></summary>

**Sources of leaks:**
- API responses with extra data
- Error messages (stack traces)
- URLs revealing structures
- Hidden form fields

**In CyberBank:**
- `/api/customer/contacts` lists all users
- Transaction history exposes account IDs

</details>

<details>
<summary><b>💼 4. Business Logic Flaws</b></summary>

**Definition:** Exploiting application workflows for unintended behavior.

**Examples:**
- Transfer negative amounts → increase balance
- Race conditions in payment processing  
- Bypass multi-step validations

**CyberBank case:** Transfer from ANY account without ownership check

</details>

---

## 📊 Progress Tracker

<div align="center">

| Task | Challenge | Difficulty | Status | Score |
|:----:|-----------|:----------:|:------:|:-----:|
| 0️⃣ | Uncovering User IDs | ⭐ Easy | ✅ | 100% |
| 1️⃣ | Account Enumeration | ⭐⭐ Medium | ✅ | 100% |
| 2️⃣ | Wire Transfer Exploit | ⭐⭐⭐ Hard | ✅ | 100% |
| 3️⃣ | 3D Secure Bypass | ⭐⭐⭐⭐ Expert | ✅ | 100% |
| 4️⃣ | Vulnerability Report | 📝 Writing | 🔄 | - |

### 🏆 Total Score: **400/400** Points!

</div>

---

## 🔐 Security - Lessons Learned

### For Developers
1. **Always validate authorization server-side**
   ```python
   if resource.owner_id != current_user.id:
       return 403  # Forbidden
   ```

2. **Never expose internal identifiers directly**
   - Use indirect references
   - Tokenize sensitive IDs

3. **Implement robust access controls**
   - RBAC (Role-Based Access Control)
   - ABAC (Attribute-Based Access Control)

4. **Log and monitor access**
   - Detect enumeration patterns
   - Alert on suspicious behaviors

5. **Principle of least privilege**
   - Return only strictly necessary data

---

## 🚀 Going Further

### Training Platforms
- [HackTheBox](https://www.hackthebox.eu/) - Pentesting labs
- [TryHackMe](https://tryhackme.com/) - Progressive challenges
- [PortSwigger Academy](https://portswigger.net/web-security) - Free IDOR labs
- [PentesterLab](https://pentesterlab.com/) - Specialized exercises

### Certifications
- **CEH** (Certified Ethical Hacker)
- **OSCP** (Offensive Security Certified Professional)
- **OSWE** (Offensive Security Web Expert)
- **GWAPT** (GIAC Web Application Penetration Tester)

### Bug Bounty Programs
- [HackerOne](https://www.hackerone.com/)
- [Bugcrowd](https://www.bugcrowd.com/)
- [Intigriti](https://www.intigriti.com/)
- [YesWeHack](https://www.yeswehack.com/)

---

## 📞 Support & Contact

### Questions?
- Consult OWASP documentation
- Join cybersecurity communities
- Ask for help on specialized forums

### Community Resources
- [r/netsec](https://www.reddit.com/r/netsec/)
- [r/AskNetsec](https://www.reddit.com/r/AskNetsec/)
- [OWASP Slack](https://owasp.org/slack/invite)

---

## 👨‍💻 Author

**Holberton School - Cybersecurity Specialization**

---

## 📜 License

This project is for educational purposes only. Using these techniques on unauthorized systems is strictly prohibited.

---

## 🏆 Acknowledgments

- **OWASP** for documentation and guidelines
- **PortSwigger** for Burp Suite and educational resources
- **Holberton School** for the curriculum and learning environment

---

**Happy Hacking! 🎩🔓**

*Remember: With great power comes great responsibility. Always hack ethically.* 