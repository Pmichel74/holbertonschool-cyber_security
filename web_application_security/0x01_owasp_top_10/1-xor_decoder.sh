#!/bin/bash
# WebSphere XOR decoder - Decodes obfuscated passwords/data from WebSphere
# Usage: ./1-xor_decoder.sh {xor}KzosKw==

# Process: Remove {xor} prefix, decode base64, XOR each byte with key 95
python3 -c "
import base64                                    # Import base64 module for decoding
data = '$1'.split('}', 1)[1]                    # Remove '{xor}' prefix from input argument
decoded = base64.b64decode(data)                 # Decode the base64 encoded string to bytes
result = ''.join(chr(b ^ 95) for b in decoded)  # XOR each byte with 95 and convert to char
print(result, end='')                           # Print result without newline
" 2>/dev/null                                   # Redirect errors to /dev/null (silent)
