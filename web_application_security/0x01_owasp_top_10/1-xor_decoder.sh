#!/bin/bash
python3 -c "import base64, sys; data = '$1'.split('}', 1)[1]; decoded = base64.b64decode(data); print(''.join(chr(b ^ 95) for b in decoded), end='')" 2>/dev/null || true
