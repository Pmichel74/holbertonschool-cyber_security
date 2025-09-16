#!/bin/bash
# WebSphere XOR decoder - decodes {xor}base64_data format
# Usage: ./script.sh {xor}KzosKw==
# Removes {xor} prefix, decodes base64, applies XOR with key 95, outputs result
python3 -c "import base64, sys; data = '$1'.split('}', 1)[1]; decoded = base64.b64decode(data); print(''.join(chr(b ^ 95) for b in decoded), end='')" 2>/dev/null || true
