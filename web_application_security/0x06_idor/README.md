# 0x06. IDOR - Insecure Direct Object References 🏦

![Cybersecurity](https://img.shields.io/badge/Cybersecurity-Web%20Application%20Security-red)
![IDOR](https://img.shields.io/badge/Vulnerability-IDOR-orange)
![Burp Suite](https://img.shields.io/badge/Tool-Burp%20Suite-blue)

## 📋 Table of Contents

- [Description](#description)
- [Learning Objectives](#learning-objectives)
- [Context: CyberBank](#context-cyberbank)
- [Resources](#resources)
- [Requirements](#requirements)
- [Tasks](#tasks)
  - [Task 0: Uncovering User IDs](#task-0-uncovering-user-ids)
  - [Task 1: Enumerating Account Numbers](#task-1-enumerating-account-numbers)
  - [Task 2: Wire Transfer Exploitation](#task-2-wire-transfer-exploitation)
  - [Task 3: Bypassing 3D Secure](#task-3-bypassing-3d-secure)
  - [Task 4: Vulnerability Report](#task-4-vulnerability-report)
- [Tools Used](#tools-used)
- [Project Structure](#project-structure)
- [Author](#author)

---

## 📖 Description

This project explores **IDOR (Insecure Direct Object References)** vulnerabilities in a simulated banking environment called **CyberBank**. Through a series of progressive challenges, you will learn to identify, exploit, and document critical security flaws affecting resource access and financial transactions.

### What is an IDOR?

An IDOR vulnerability occurs when an application exposes a direct reference to an internal object (user ID, account number, etc.) without verifying that the authenticated user has the right to access that resource. This allows an attacker to manipulate these references to access data or perform unauthorized actions.

**Example:**
```
❌ Vulnerable: GET /api/customer/info/12345
✅ Secure:     Verify that logged-in user = owner of ID 12345
```

---

## 🎯 Learning Objectives

By the end of this project, you will be able to:

- ✅ Identify and understand IDOR vulnerabilities
- ✅ Use Burp Suite to intercept and manipulate HTTP requests
- ✅ Enumerate resources (user IDs, account numbers, card IDs)
- ✅ Exploit authorization flaws to access sensitive data
- ✅ Manipulate financial transactions in an unauthorized manner
- ✅ Bypass security mechanisms (3D Secure)
- ✅ Write a professional vulnerability report
- ✅ Understand the impact of IDOR on real systems

---

## 🏦 Context: CyberBank

**CyberBank** is a simulated web banking application designed for web security learning. It intentionally presents critical IDOR vulnerabilities affecting:

- 👤 User profiles
- 💰 Bank accounts
- 💸 Money transfers
- 💳 Card payments

**Application URL:** `http://web0x06.hbtn`

⚠️ **Warning:** This application is a learning environment. Never apply these techniques on real systems without explicit authorization.

---

## 📚 Resources

### Official Documentation
- [OWASP Top 10 - A01:2021 Broken Access Control](https://owasp.org/Top10/A01_2021-Broken_Access_Control/)
- [PortSwigger - IDOR](https://portswigger.net/web-security/access-control/idor)
- [OWASP Testing Guide - IDOR](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/05-Authorization_Testing/04-Testing_for_Insecure_Direct_Object_References)

### Tools
- [Burp Suite Community](https://portswigger.net/burp/communitydownload)
- [Browser Developer Tools (F12)](https://developer.chrome.com/docs/devtools/)

### Articles & Tutorials
- [HackerOne IDOR Reports](https://www.hackerone.com/vulnerability-management/what-insecure-direct-object-reference-idor)
- [PentesterLab - IDOR Exercises](https://pentesterlab.com/)

---

## 🔧 Requirements

### Required Knowledge
- Basic understanding of HTTP protocol (GET, POST, headers, cookies)
- Knowledge of REST APIs
- Familiarity with JSON format
- Basic terminal/command line usage

### Software
- **Web browser** (Firefox, Chrome) with DevTools
- **Burp Suite Community Edition** (free)
- **cURL** (optional, for command-line testing)
- **jq** (optional, for JSON parsing)

### Burp Suite Setup
```bash
# 1. Download Burp Suite Community
# 2. Configure browser proxy: 127.0.0.1:8080
# 3. Enable interception: Proxy → Intercept → Intercept is on
```

---

## 📝 Tasks

### Task 0: Uncovering User IDs
**Score:** 100% ✅

#### Objective
Discover User IDs in the CyberBank application by exploring features and identifying how identifiers are exposed.

#### Instructions
1. Log in to `http://web0x06.hbtn/dashboard` with the provided credentials
2. Open DevTools (F12) → Network tab (with "Preserve log" enabled)
3. Explore the application and observe API requests
4. Identify endpoints exposing User IDs:
   - `/api/customer/info/me` → Your own ID
   - `/api/customer/contacts` → List of all users
5. Test IDOR access on `/api/customer/info/{user_id}`
6. Retrieve the flag from another user's information

#### Key Concepts
- User enumeration
- Information disclosure via public endpoints
- URL parameter manipulation

#### Output File
```
0-flag.txt
```

---

### Task 1: Enumerating Account Numbers for Balance Disclosure
**Score:** 100% ✅

#### Objective
Use discovered User IDs to enumerate bank account numbers and access balances in an unauthorized manner.

#### Instructions
1. Use User IDs from Task 0
2. Explore account-related endpoints:
   - `/api/customer/transactions` → Reveals `account_id`
   - `/api/customer/info/{user_id}` → Contains `accounts_id[]`
3. Identify the vulnerable endpoint: `/api/accounts/info/{account_id}`
4. Test IDOR access by changing the `account_id`
5. Access balances and account information of other users
6. Find the flag in a specific account

#### Key Concepts
- Horizontal resource enumeration
- Unauthorized access to financial data
- Sensitive information disclosure

#### Output File
```
1-flag.txt
```

---

### Task 2: Manipulating Wire Transfers to Inflate Account Balance
**Score:** 100% ✅

#### Objective
Exploit the wire transfer functionality to increase your balance beyond $10,000 and obtain flag_2.

#### Instructions
1. Analyze the transfer functionality on `/api/accounts/transfer_to/{destination_id}`
2. Identify required parameters (account_id, routing, number, amount)
3. Use Burp Suite Intruder to automate exploitation:
   - **Phase 1:** Retrieve credentials for 20 accounts via `/api/accounts/info/{account_id}`
   - **Phase 2:** Configure a Pitchfork attack with 4 payloads
4. Transfer funds from all accounts to your account
5. Reach a balance > $10,000 to unlock flag_2

#### Key Concepts
- IDOR on critical actions (money transfers)
- Attack automation with Burp Intruder
- Lack of ownership validation

#### Tools
- Burp Suite Intruder (Attack type: Pitchfork)
- Repeater for manual testing

#### Output File
```
2-flag.txt
```

---

### Task 3: Bypassing 3D Secure Verification for Unauthorized Payment
**Score:** 100% ✅

#### Objective
Perform a fraudulent payment using another user's card information and bypassing 3D Secure authentication.

#### Instructions
1. Explore the payment process on `/upgrade`
2. Identify the IDOR exploitation chain:
   - Step 1: `/api/customer/transactions` → Retrieve a victim's `card_id`
   - Step 2: `/api/cards/info/{card_id}` → Steal card details (number, CVV, expiration)
   - Step 3: `/api/cards/init_payment` → Initialize payment with stolen data
   - Step 4: `/api/cards/3dsecure/{card_id}` → Retrieve victim's OTP (Bypass 3D Secure!)
   - Step 5: `/api/cards/confirm_payment/{payment_id}` → Confirm payment with stolen OTP
3. Use Burp Suite Repeater with 3 tabs to orchestrate the attack
4. Retrieve flag_3 after payment confirmation

#### Key Concepts
- Complex IDOR exploitation chain
- Bypassing strong authentication mechanisms (3D Secure)
- Theft of sensitive banking data (PCI DSS violation)
- Financial identity theft

#### Output File
```
3-flag.txt
```

---

### Task 4: Crafting a Comprehensive Vulnerability Report
**Mandatory**

#### Objective
Compile all your findings into a professional, structured, and detailed vulnerability report suitable for presentation to a real financial institution.

#### Report Structure
1. **Introduction**
   - Overview of CyberBank
   - Security assessment objective

2. **Methodology**
   - Tools used (Burp Suite, DevTools, cURL)
   - Testing approach (gray-box)

3. **Vulnerability Details**
   - For each vulnerability:
     - Technical description
     - Impact (criticality)
     - Reproduction steps
     - Evidence (screenshots, request/response pairs)

4. **Additional Findings**
   - Other identified security flaws:
     - Lack of rate limiting
     - Sessions without timeout
     - Missing logging
     - Absence of MFA
     - Etc.

5. **Recommendations**
   - Specific and actionable solutions
   - Secure code examples
   - Priority action plan

6. **Conclusion**
   - Impact summary
   - Urgency of fixes

7. **References**
   - OWASP, PortSwigger, PCI DSS, etc.

#### Format
- Google Docs (recommended for collaboration)
- PDF (for final submission)
- Public read-only sharing

#### Output File
```
Google Docs link to submit
```

---

## 🛠️ Tools Used

### Burp Suite
- **Proxy**: HTTP/S traffic interception
- **Repeater**: Manual testing and request manipulation
- **Intruder**: Attack automation through enumeration

### Browser DevTools (F12)
- **Network Tab**: API request analysis
- **Console**: JavaScript debugging
- **Application Tab**: Cookie inspection

### Command Line Tools
```bash
# cURL - Command-line API testing
curl -H "Cookie: session=XXX" http://web0x06.hbtn/api/customer/info/me

# jq - JSON parser
curl -s http://web0x06.hbtn/api/customer/transactions | jq '.[].account_id'
```

---

## 📁 Project Structure

```
0x06_idor/
├── README.md                    # This file
├── .gitignore                   # Files not to commit
│
├── 0-flag.txt                   # Flag Task 0 (User IDs)
├── 1-flag.txt                   # Flag Task 1 (Account Numbers)
├── 2-flag.txt                   # Flag Task 2 (Wire Transfers)
├── 3-flag.txt                   # Flag Task 3 (3D Secure Bypass)
│
├── WRITEUP_TASK_0.md           # Task 0 documentation (not committed)
├── WRITEUP_TASK_1.md           # Task 1 documentation (not committed)
├── WRITEUP_TASK_2_BURP.md      # Task 2 documentation (not committed)
├── WRITEUP_TASK_3_BURP.md      # Task 3 documentation (not committed)
│
└── VULNERABILITY_REPORT.md     # Complete report (not committed)
```

---

## 🎓 Key Concepts Covered

### 1. IDOR (Insecure Direct Object References)
Manipulation of direct references to internal objects to access unauthorized resources.

### 2. Broken Access Control
Failure in access control mechanisms allowing a user to perform actions beyond their privileges.

### 3. Information Disclosure
Unintentional exposure of sensitive information (IDs, balances, credentials).

### 4. Horizontal Privilege Escalation
Access to data of other users at the same privilege level.

### 5. Business Logic Flaws
Exploitation of business logic (transfers, payments) for fraudulent actions.

---

## ⚠️ Legal and Ethical Warnings

### ⚖️ Important
- ✅ This project is an **authorized learning environment**
- ❌ **NEVER** apply these techniques on real systems without authorization
- ⚠️ Unauthorized hacking is **illegal** and prosecutable
- 🎯 Use these skills **ethically**: bug bounties, authorized pentests

### Ethical Hacking Guidelines
1. Always obtain **written authorization** before testing
2. Respect the defined **scope** of the test
3. **Report** vulnerabilities responsibly
4. **Never** cause damage or access unnecessary data
5. Maintain **confidentiality** of findings

---

## 📊 Progress

| Task | Description | Status | Score |
|------|-------------|--------|-------|
| 0 | Uncovering User IDs | ✅ | 100% |
| 1 | Enumerating Account Numbers | ✅ | 100% |
| 2 | Wire Transfer Exploitation | ✅ | 100% |
| 3 | Bypassing 3D Secure | ✅ | 100% |
| 4 | Vulnerability Report | 📝 | - |

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