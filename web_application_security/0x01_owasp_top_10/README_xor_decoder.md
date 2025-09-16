# WebSphere XOR Decoder

## Description
Ce script décode les données obfusquées de WebSphere qui utilisent le format `{xor}` suivi d'une chaîne encodée en Base64.

## Contexte
IBM WebSphere utilise un mécanisme d'obfuscation simple pour masquer les mots de passe et autres données sensibles dans ses fichiers de configuration. Le format est : `{xor}base64_encoded_data`

## Fonctionnement
1. **Suppression du préfixe** : Retire `{xor}` du début de la chaîne
2. **Décodage Base64** : Convertit la chaîne Base64 en données binaires
3. **Opération XOR** : Applique un XOR avec la clé fixe `95` sur chaque byte
4. **Conversion** : Transforme le résultat en caractères ASCII

## Usage

```bash
./1-xor_decoder.sh {xor}KzosKw==
```

**Sortie attendue :**
```
test
```

## Exemples

| Input | Output |
|-------|--------|
| `{xor}KzosKw==` | `test` |
| `{xor}NzozMzA=` | `hello` |

## Prérequis
- Bash
- Python 3
- Module `base64` (inclus par défaut)

## Fichiers
- `1-xor_decoder.sh` : Script principal de décodage

## Algorithme
```
XOR_KEY = 95
encoded_data = input.split('}')[1]  // Retire {xor}
binary_data = base64_decode(encoded_data)
for each byte in binary_data:
    result += chr(byte XOR XOR_KEY)
```

## Notes de sécurité
⚠️ **Attention** : Ce type d'obfuscation n'est PAS sécurisé. Il s'agit d'une simple obfuscation, pas d'un chiffrement. Les données peuvent être facilement décodées comme le montre ce script.

## Tests
Pour tester le script :
```bash
chmod +x 1-xor_decoder.sh
./1-xor_decoder.sh {xor}KzosKw==
# Devrait afficher : test
```

## Structure du code
- **Ligne 1** : Shebang bash
- **Lignes 2-4** : Documentation et usage
- **Ligne 6** : Appel Python inline
- **Ligne 7** : Import du module base64
- **Ligne 8** : Suppression du préfixe {xor}
- **Ligne 9** : Décodage Base64
- **Ligne 10** : XOR et conversion en caractères
- **Ligne 11** : Affichage du résultat
- **Ligne 12** : Gestion des erreurs

---
*Script créé pour le projet Holberton School - Cyber Security*