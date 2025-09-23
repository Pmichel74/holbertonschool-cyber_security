# 0x02. Burp Suite Fundamentals

## 📋 Description

This project introduces you to **Burp Suite**, a cornerstone tool in web application security testing. Through a series of hands-on tasks, you'll learn to configure Burp Suite for web traffic interception, manipulate requests and responses, and discover hidden vulnerabilities using various Burp Suite tools.

Burp Suite offers a vast array of features tailored for security professionals and ethical hackers, making it an essential tool for web application penetration testing.

## 🎯 Learning Objectives

By the end of this project, you will be able to:

- Install and configure Burp Suite Community Edition
- Set up proxy configurations for web traffic interception
- Install and manage TLS certificates
- Use the Proxy tool to intercept and modify HTTP/HTTPS traffic
- Utilize the Repeater tool for manual request testing
- Employ the Intruder tool for automated attacks
- Analyze session tokens with the Sequencer tool
- Decode and manipulate Bearer tokens using the Decoder tool
- Understand client-side TLS authentication
- Discover hidden information through response manipulation

## 🛠️ Prerequisites

- Basic understanding of HTTP/HTTPS protocols
- Knowledge of web application architecture
- Familiarity with browser developer tools
- Understanding of certificates and TLS/SSL

## 📂 Project Structure

```
0x02_burpsuite_fundamentals/
├── README.md
├── 0-flag.txt          # Task 0: Getting Started with Burp Suite
├── 1-flag.txt          # Task 1: Client-Side TLS Authentication
├── 2-flag.txt          # Task 2: Modifying Page Responses
├── 3-flag.txt          # Task 3: Exploring the Repeater Tool
├── 4-flag.txt          # Task 4: The Intruder's Path to Hidden Profiles
├── 5-flag.txt          # Task 5: Deciphering Tokens with Sequencer
└── 6-flag.txt          # Task 6: Decoder Tab - Manipulating Base64 Encoded Bearer Tokens
```

## 📋 Tasks

### Task 0: Getting Started with Burp Suite
**Mandatory** | **Score: 100.00%**

Your first mission is to get Burp Suite up and running, configure it for web traffic interception, and uncover hidden data within TLS certificate details.

**Steps:**
1. **Download and Install Burp Suite**
   - Download Burp Suite Community Edition from the official PortSwigger website
   - Follow installation instructions for your operating system
   - Launch Burp Suite and familiarize yourself with the setup screens

2. **Start Burp Suite**
   - **Method 1:** Manual proxy setup and certificate installation
     - Navigate to Proxy → Options tab
     - Set Burp Suite proxy to listen on `127.0.0.1:8080`
     - Configure your browser to route traffic through Burp proxy
     - Download and install the CA certificate from `http://burpsuite`
   - **Method 2:** Use the "Open Browser" button in the Proxy tab

3. **DNS Resolution Configuration**
   - Navigate to Project options → Connections → Hostname Resolution Overrides
   - Add a new record: hostname `web0x02.hbtn` with your container's IP address

4. **Discover the FLAG**
   - Visit `https://web0x02.hbtn` through your configured browser
   - Navigate to Project options → TLS → Server TLS Certificate
   - Examine the server certificate details for the hidden Flag

**File:** `0-flag.txt`

---

### Task 1: Client-Side TLS Authentication with Burp Suite
**Mandatory** | **Score: 100.00%**

Navigate client-side TLS authentication to access content protected by certificate-based authentication.

**Steps:**
1. **Download the PKCS#12 Certificate**
   - Visit `https://web0x02.hbtn` or directly access `https://web0x02.hbtn/static/web0x012.p12`
   - Download the `.p12` certificate from the welcome screen

2. **Configure Burp Suite with Client TLS Certificate**
   - Navigate to Proxy → Options → TLS → Client TLS Certificate
   - Select "Override options" checkbox
   - Click "Add" to configure a new client certificate
   - Destination Host: `web0x02.hbtn`
   - Certificate Type: "PKCS#12"
   - Select the downloaded `.p12` file
   - Password: `holberton`

3. **Access Hidden Content**
   - Reload `https://web0x02.hbtn` in your browser
   - Successful client-side TLS authentication will reveal new content

**File:** `1-flag.txt`

---

### Task 2: Modifying Page Responses to Reveal Hidden Information
**Mandatory** | **Score: 100.00%**

Learn to manipulate web server responses by intercepting and altering them in real-time to reveal hidden content.

**Steps:**
1. **Intercept the Download Request**
   - Navigate to `/task2` page
   - Ensure Intercept is On in Proxy → Intercept tab
   - Click the "Download" button to capture the request

2. **Modify the Server Response**
   - Click Action → Do intercept → Response to this request
   - Toggle Intercept to off to modify the response
   - Edit the response body to reveal or unhide the Flag
   - Maintain JSON format integrity while making modifications
   - Click Forward to send the altered response

3. **Reveal the Flag**
   - The modified response will reveal the hidden FLAG

**File:** `2-flag.txt`

---

### Task 3: Exploring the Repeater Tool
**Mandatory** | **Score: 100.00%**

Utilize Burp Suite's Repeater tool to test and tweak login requests, aiming to guess credentials on a router login portal.

**Steps:**
1. **Capture the Login Request**
   - Navigate to `/task3` page
   - Ensure Intercept is On
   - Click the login button to capture the request
   - Send to Repeater using Ctrl + R

2. **Guess Credentials with Repeater**
   - In the Repeater tab, modify the captured login request
   - Try common router credentials: `admin/admin`, `admin/password`, etc.
   - Pay attention to role and "remember me" options
   - Alter these values as needed

3. **Uncover the Flag**
   - Continue tweaking and resending requests based on server responses
   - Successful authentication will reveal a success message with the hidden Flag

**File:** `3-flag.txt`

---

### Task 4: The Intruder's Path to Hidden Profiles
**Mandatory** | **Score: 100.00%**

Use Burp Suite's Intruder tool to automate attacks and discover hidden user profiles by testing different ID values.

**Steps:**
1. **Capture the Request**
   - Navigate to `/task4` page
   - Ensure Intercept is On
   - Click "Refresh" button to generate a request
   - Send to Intruder using Ctrl + I

2. **Set Up Intruder Attack**
   - In Intruder → Positions tab, highlight the profile ID parameter
   - Click "Add" to set as attack point
   - Switch to Payloads tab
   - Select "Numbers" as payload type
   - Set range: From current ID to current ID + 100/200
   - Start the attack

3. **Identify Correct Profile ID**
   - Monitor attack results for responses with status code 200
   - Note the successful profile ID

4. **Retrieve the Flag**
   - Return to Proxy → Intercept tab
   - Replace profile ID with the discovered ID
   - Forward the request and turn off Intercept
   - The response will reveal the hidden user profile with the Flag

**File:** `4-flag.txt`

---

### Task 5: Deciphering Tokens with Sequencer
**Mandatory** | **Score: 100.00%**

Use Burp Suite's Sequencer tool to analyze session token randomness and identify patterns in the `hijack_session` cookie.

**Steps:**
1. **Capture the Request**
   - Navigate to `/task5` page
   - Ensure Intercept is On
   - Capture the initial request and send to Repeater (Ctrl + R)

2. **Prepare for Sequencer Analysis**
   - In Repeater tab, remove the `hijack_session` value from Cookie header
   - Right-click and select "Send to Sequencer"

3. **Configure and Start Sequencer**
   - Ensure Sequencer detects the `hijack_session` parameter
   - Adjust settings: "Throttle between requests (ms)" to 25
   - Start live capture and generate around 200 tokens
   - Stop capture

4. **Analyze Token Pattern**
   - Export/copy tokens to text editor
   - Identify patterns, skipped, or repeating values
   - Locate a skipped cookie value (valid session)

5. **Hijack Session and Reveal Flag**
   - Replace current session cookie with the valid `hijack_session` value
   - Reload `/task5` in browser
   - Interact with accessible features to uncover the Flag

**File:** `5-flag.txt`

---

### Task 6: Decoder Tab - Manipulating Base64 Encoded Bearer Tokens
**Mandatory** | **Score: 100.00%**

Learn Bearer Token manipulation by decoding, modifying, and re-encoding tokens to escalate privileges.

**Steps:**
1. **Intercept the Request**
   - Navigate to `/task6` page
   - Ensure Intercept is On
   - Click "Check All" button to generate request
   - Intercept the request

2. **Extract Bearer Token**
   - Locate Authorization header containing Bearer Token
   - Send token to Decoder or copy to Decoder tab

3. **Decode and Edit Token**
   - Decode from Base64
   - Decompress (GZIP)
   - View JSON object with `"admin": false`
   - Edit to `"admin": true`
   - Compress with GZIP
   - Encode back to Base64

4. **Replace and Forward**
   - Copy the modified token
   - Replace original Bearer Token in Authorization header
   - Forward the request

5. **Reveal the Flag**
   - Monitor response for elevated privileges indication
   - Document the revealed Flag

**File:** `6-flag.txt`

---

## 🔧 Tools Used

- **Burp Suite Community Edition** - Main penetration testing tool
- **Web Browser** - For accessing target applications
- **Text Editor** - For token analysis and manipulation

## 📝 Key Concepts

- **Proxy Configuration** - Routing web traffic through Burp Suite
- **TLS Certificate Management** - Installing and configuring certificates
- **Request/Response Interception** - Capturing and modifying HTTP traffic
- **Client-Side TLS Authentication** - Certificate-based authentication
- **Session Token Analysis** - Testing randomness and identifying patterns
- **Bearer Token Manipulation** - Decoding, modifying, and re-encoding tokens
- **Automated Attack Techniques** - Using Intruder for systematic testing

## ⚠️ Important Notes

- Always ensure you have proper authorization before testing web applications
- Use these techniques only in controlled environments or with explicit permission
- Burp Suite Community Edition has some limitations compared to the Professional version
- Keep your Burp Suite installation updated for the latest features and security fixes


---
  
**Author:** Holberton School Cybersecurity Program