#!/bin/bash
# WebSphere XOR decoder
# Usage: ./1-xor_decoder.sh {xor}KzosKw==

# Remove {xor} prefix, decode base64, XOR with 95
python3 -c "
import base64
data = '$1'.split('}', 1)[1]
decoded = base64.b64decode(data)
result = ''.join(chr(b ^ 95) for b in decoded)
print(result, end='')
" 2>/dev/null
