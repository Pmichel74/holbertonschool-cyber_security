

# 0x0b - Web Application Fast Incident Response

Welcome to the Fast Incident Response project! 🚨

This project is all about learning how to quickly investigate and respond to web application security incidents. Here, you'll get hands-on experience with log analysis, spotting suspicious activity, and thinking like a security analyst. The focus is on building your skills to react efficiently and thoughtfully when something unusual happens on a web server.


## Learning Objectives

- Grasp the essentials of web application incident response
- Practice analyzing log files for signs of attacks
- Recognize possible vulnerabilities and attack vectors
- Automate information gathering and report creation
- Suggest general ways to improve security


## What You'll Do

Each task in this project is a step in the incident response journey:

1. **Spotting Attacks**  
   Dig into logs to find clues of suspicious activity (think: weird requests, brute force attempts, or file inclusions).
2. **Collecting Clues**  
   Pull out useful details like IP addresses, timestamps, URLs, and user info.
3. **Piecing Together the Story**  
   Put events in order to see how things unfolded.
4. **Assessing Vulnerabilities**  
   Figure out how the system might have been compromised and what weaknesses could have been targeted.
5. **Suggesting Fixes**  
   Come up with general ideas to help prevent similar incidents in the future.
6. **Automating Your Work**  
   Write scripts to make your analysis faster and easier.


## Project Structure

Here's what you'll find in this directory:

```
0x0b_web_application_fast_incident_response/
├── README.md
├── [analysis scripts].sh
├── [reports].txt
├── [log files].log
└── ...
```

- **README.md**: You're reading it!
- **Scripts**: Bash or Python tools to help with your analysis
- **Reports**: Summaries of your findings and recommendations
- **Logs**: Example log files to practice on


## How to Use This Project

1. Put the log files you want to analyze in this folder.
2. Run the scripts provided to pull out the important info:
   ```bash
   ./analyse_logs.sh
   ```
3. Check out the reports you generate to get a better understanding of what happened and think about how to respond.


## Handy Command Examples

Here are a few command-line tricks you might find useful:

- Count unique IP addresses:
	```bash
	awk '{print $1}' access.log | sort | uniq -c | sort -nr
	```
- Look for possible SQL injection attempts:
	```bash
	grep -i "union select" access.log
	```
- Find access to sensitive files:
	```bash
	grep "/etc/passwd" access.log
	```


## Resources

- [OWASP Incident Response Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Incident_Response_Cheat_Sheet.html)
- [Linux Logging Basics](https://www.loggly.com/ultimate-guide/linux-logging-basics/)
- [ANSSI Incident Response Guide](https://www.ssi.gouv.fr/guide/reponse-aux-incidents/)


## Author

This project is part of the Holberton School Cybersecurity curriculum. Have fun investigating and learning!