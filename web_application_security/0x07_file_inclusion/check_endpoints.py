#!/usr/bin/env python3
"""
Check for available endpoints on web0x07.hbtn
"""

import requests

BASE = "http://web0x07.hbtn"

# Common endpoints to check
endpoints = [
    "/task0/",
    "/task0/list_file",
    "/task0/upload",
    "/task0/upload_file",
    "/task0/file_upload",
    "/task0/add_file",
    "/task0/download_file",
    "/task0/index",
    "/task0/home",
]

print("Checking endpoints...\n")

for endpoint in endpoints:
    try:
        url = BASE + endpoint
        response = requests.get(url, timeout=5)
        status = response.status_code

        if status == 200:
            print(f"✓ [{status}] {url}")

            # Check if it contains a form
            if "<form" in response.text.lower():
                print(f"  → Contains FORM element!")
            if "upload" in response.text.lower():
                print(f"  → Contains 'upload' keyword!")
            if "<input" in response.text.lower() and "file" in response.text.lower():
                print(f"  → Contains file input!")
            print()
        elif status == 404:
            print(f"✗ [404] {url}")
        else:
            print(f"? [{status}] {url}")

    except Exception as e:
        print(f"✗ ERROR {url}: {e}")

print("\nDone!")
