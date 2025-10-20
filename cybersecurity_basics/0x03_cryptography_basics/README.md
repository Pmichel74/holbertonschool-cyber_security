# 0x03. Cryptography Basics 🔐

Welcome to the world of cryptography and password security! This project will take you on a journey through password hashing and hash cracking techniques.

## 🎯 What You'll Learn

By the end of this project, you'll master:
- **Hashing Algorithms**: SHA-1, SHA-256, and MD5
- **Password Security**: How salting protects passwords
- **Password Cracking**: Using industry-standard tools
- **Attack Techniques**: Dictionary attacks, combination attacks, and more
- **Hash Formats**: Understanding MD5, SHA, and NTLM

## 📚 Essential Resources

- [OpenSSL Documentation](https://www.openssl.org/docs/)
- [John the Ripper Wiki](https://www.openwall.com/john/)
- [Hashcat Documentation](https://hashcat.net/wiki/)
- RockYou Wordlist: `/usr/share/wordlists/rockyou.txt`

## 💡 Prerequisites

Before starting, make sure you have:
- Basic knowledge of bash scripting
- John the Ripper installed (`john`)
- Hashcat installed (`hashcat`)
- OpenSSL installed (`openssl`)
- RockYou wordlist (unzipped if necessary)

---

## 📝 Tasks

### Task 0: SHA1 Hash 🔑
**File:** `0-sha1.sh`

Create your first hashing script! This script will hash a password using the SHA-1 algorithm.

**💡 How to approach it:**
- Use `echo -n` to pass the password (the `-n` flag prevents adding a newline)
- Look for a command that can compute SHA-1 hashes
- Save your output to `0_hash.txt`
- Remember: your script receives the password as `$1`

**Expected output format:** A 40-character hexadecimal string

---

### Task 1: SHA256 Hash 🔒
**File:** `1-sha256.sh`

Level up! Now use the more secure SHA-256 algorithm.

**💡 How to approach it:**
- Very similar to Task 0, just change the algorithm
- Output goes to `1_hash.txt`
- SHA-256 is more secure than SHA-1!

**Expected output format:** A 64-character hexadecimal string

---

### Task 2: MD5 Hash 🗝️
**File:** `2-md5.sh`

Time to explore MD5 (even though it's considered weak nowadays).

**💡 How to approach it:**
- Use the MD5 hashing command
- Output saves to `2_hash.txt`
- MD5 is fast but not recommended for modern security

**Expected output format:** A 32-character hexadecimal string

---

### Task 3: Secure Password Hash with Salt 🧂
**File:** `3-password_hash.sh`

Now for something more realistic! Add a "salt" (random data) to your password before hashing.

**💡 How to approach it:**
- Generate 16 random characters using `openssl rand`
- Combine this salt with the password
- Hash the combination with SHA-512 using `openssl dgst`
- Keep the OpenSSL output format (it includes "SHA512(stdin)= ")

**Why salting?** It makes identical passwords produce different hashes!

---

### Task 4: Crack Passwords with John - Wordlist Mode 🔓
**Files:** `4-wordlist_john.sh`, `4-password.txt`

Switch sides! Now you're the attacker. Use John the Ripper to crack password hashes.

**💡 How to approach it:**
- Use `john --wordlist=/path/to/rockyou.txt hash_file`
- The hash file is passed as argument `$1`
- After cracking, extract passwords with `john --show`
- Save **only the passwords** (one per line) to `4-password.txt`

**Hint:** Use `cut` or `awk` to extract just the password from `hash:password`

---

### Task 5: Windows NTLM Hash Cracking 🪟
**Files:** `5-windows_john.sh`, `5-password.txt`

Windows systems use NTLM hashes. Let's crack one!

**💡 How to approach it:**
- Add `--format=nt` to tell John this is an NTLM hash
- NTLM is based on MD4 and used in Windows authentication
- Use the same wordlist approach as Task 4
- Extract and save only the password

**Fun fact:** NTLM hashes don't use salts, making them vulnerable!

---

### Task 6: More John Cracking! ⚡
**Files:** `6-crack_john.sh`, `6-password.txt`

Practice makes perfect! Crack another hash with John.

**💡 How to approach it:**
- John can auto-detect hash types, but you can specify `--format=raw-sha256` if needed
- Same process: crack, show, extract, save
- You're getting the hang of this!

---

### Task 7: Hashcat Straight Attack 💥
**Files:** `7-crack_hashcat.sh`, `7-password.txt`

Time to learn Hashcat, the GPU-powered cracking tool!

**💡 How to approach it:**
- Use `-m 0` for MD5 hash mode
- Use `-a 0` for straight/dictionary attack
- Specify your wordlist path
- Extract results with `hashcat --show hash_file`

**Hashcat vs John:** Hashcat is faster (especially with GPUs) but requires more specific configuration

---

### Task 8: Hashcat Combinator Mode 🔀
**File:** `8-combination_hashcat.sh`

Create new password candidates by combining two wordlists!

**💡 How to approach it:**
- Use `-a 1` for combination attack mode
- Use `--stdout` to display combinations without cracking
- Takes two wordlists: `$1` and `$2`
- Output: "word1word2", "word1word3", etc.

**Example:** `pass` + `word` = `password`

---

### Task 9: Hashcat Combination Attack 🎯
**Files:** `9-attack_hashcat.sh`, `9-password.txt`

Put it all together! Use combination attack to crack a hash.

**💡 How to approach it:**
- Combine `-a 1` (combination) with `-m 0` (MD5)
- Use `wordlist1.txt` and `wordlist2.txt` as your dictionaries
- Extract the cracked password and save it

**Strategy:** Combination attacks find passwords like "hello123" or "pass2024"!

---

## 🎓 Pro Tips & Best Practices

### 🔧 For Hashing Scripts (Tasks 0-3)

**Common Pitfall:** Forgetting the `-n` flag in `echo` adds a newline, changing your hash!

```bash
# Wrong: includes newline in hash
echo "password" | sha256sum

# Right: hashes only the password
echo -n "password" | sha256sum
```

**Useful commands:**
- `sha1sum` - SHA-1 hashing
- `sha256sum` - SHA-256 hashing
- `md5sum` - MD5 hashing
- `openssl` - Swiss army knife for crypto operations

**Extracting hash output:**
Most commands output `hash filename`, you might need just the hash:
```bash
command | cut -d' ' -f1
```

---

### 🔓 For John the Ripper (Tasks 4-6)

**Finding RockYou:**
```bash
# Usually located at:
/usr/share/wordlists/rockyou.txt

# If compressed:
gunzip /usr/share/wordlists/rockyou.txt.gz
```

**Understanding John's output:**
```
john --show hash.txt
# Output: 5f4dcc3b5aa765d61d8327deb882cf99:password
#         ^--- hash ---^              ^--- password ---^
```

**Extracting passwords:**
You need to parse `hash:password` to get just `password`:
```bash
# Use cut with : delimiter
john --show file.txt | cut -d':' -f2
```

**Common formats:**
- `--format=raw-md5` - Plain MD5
- `--format=raw-sha256` - Plain SHA-256
- `--format=nt` - Windows NTLM

---

### ⚡ For Hashcat (Tasks 7-9)

**Hash modes you'll need:**
- `-m 0` = MD5
- `-m 1000` = NTLM
- `-m 1400` = SHA-256
- `-m 1800` = SHA-512

**Attack modes:**
- `-a 0` = Straight/Dictionary attack (use a wordlist as-is)
- `-a 1` = Combination attack (combine two wordlists)
- `-a 3` = Brute-force attack (try all combinations)

**Viewing results:**
```bash
# After cracking:
hashcat --show hash.txt
# Output: hash:password
```

**Using --stdout:**
```bash
# See what Hashcat would try without actually cracking:
hashcat -a 1 --stdout wordlist1.txt wordlist2.txt
```

**Extracting passwords:**
Same as John, parse the output:
```bash
hashcat --show hash.txt | cut -d':' -f2
```

---

## 🚨 Important Notes

- **Ethics:** Only crack passwords you're authorized to test!
- **Performance:** Hashcat is much faster with a GPU
- **Wordlists:** RockYou contains 14+ million common passwords
- **Security:** Never use MD5 or SHA-1 for new applications (they're weak!)
- **Modern practice:** Use bcrypt, scrypt, or Argon2 for password hashing

---

## 📖 Additional Resources

- [Hashcat Examples](https://hashcat.net/wiki/doku.php?id=example_hashes)
- [John the Ripper Formats](https://openwall.info/wiki/john/sample-hashes)
- [OpenSSL Command Guide](https://www.openssl.org/docs/man1.1.1/man1/openssl.html)
- [Understanding Password Hashing](https://auth0.com/blog/hashing-passwords-one-way-road-to-security/)

---

## ✅ Repo Information

**Repository:** `holbertonschool-cyber_security`
**Directory:** `cybersecurity_basics/0x03_cryptography_basics`

**Project by:** Holberton School - Cybersecurity Program