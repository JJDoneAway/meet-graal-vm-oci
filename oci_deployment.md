Hier ist eine Schritt-für-Schritt-Anleitung, wie du ein Docker-Image auf einer VM in Oracle Cloud Infrastructure (OCI) deployen kannst:

---

### **1. Erstellen einer VM in OCI**
1. **Melde dich bei der OCI-Konsole an.**
2. Gehe zu **Compute → Instances**.
3. Klicke auf **Create Instance**.
4. Konfiguriere die VM:
   - Wähle ein passendes Shape (z. B. `VM.Standard2.1` für kleine Workloads).
   - Wähle ein Betriebssystem (z. B. Oracle Linux oder Ubuntu).
5. **Öffentliche IP-Adresse aktivieren:**
   - Aktiviere die Option **Assign a public IPv4 address**.
6. Erstelle die Instanz.

Nach der Erstellung erhält die VM eine öffentliche IP-Adresse.

---

### **2. Öffentliche IP und SSH-Zugriff**
1. **SSH-Schlüssel:** Stelle sicher, dass du beim Erstellen der VM einen SSH-Schlüssel angegeben hast oder einen neuen Schlüssel erzeugst:
   ```bash
   ssh-keygen -t rsa -b 2048 -f ~/.ssh/my-oci-key
   ```
   Lade den öffentlichen Schlüssel hoch.

2. **SSH-Zugriff auf die VM:**
   Nach der Erstellung kannst du dich mit folgendem Befehl verbinden:
   ```bash
   ssh -i ~/.ssh/my-oci-key opc@<public-ip>
   ```

---

### **3. Docker auf der VM installieren**
1. Melde dich per SSH auf der VM an.
2. Installiere Docker:
   - Für **Oracle Linux**:
     ```bash
     sudo dnf install -y docker
     sudo systemctl enable docker
     sudo systemctl start docker
     ```
   - Für **Ubuntu**:
     ```bash
     sudo apt update
     sudo apt install -y docker.io
     sudo systemctl enable docker
     sudo systemctl start docker
     ```
3. **Prüfe die Installation:**
   ```bash
   docker --version
   ```

4. **Aktiviere Docker für den aktuellen Benutzer:**
   ```bash
   sudo usermod -aG docker $USER
   ```

---

### **4. Docker Image in eine Registry pushen**
OCI bietet eine integrierte **Container Registry (OCIR)**, die für solche Zwecke geeignet ist.

#### **Schritt 1: Erstelle ein OCIR-Repository**
1. Gehe in der OCI-Konsole zu **Developer Services → Container Registry → Repositories**.
2. Klicke auf **Create Repository**.
   - Wähle `private` oder `public`.
   - Notiere dir den Namespace, z. B. `namespace` (du benötigst ihn später).

#### **Schritt 2: Docker Image taggen**
1. Stelle sicher, dass du in deinem lokalen Docker registriert bist:
   ```bash
   docker login <region-code>.ocir.io
   ```
   OCI-Regionen haben spezifische Codes, z. B.:
   - Frankfurt: `fra.ocir.io`
   - Ashburn: `iad.ocir.io`

   Verwende deinen namespace/OCI-Benutzernamen und ein Auth-Token (kein normales Passwort). Das Auth-Token kannst du in der OCI-Konsole unter **Profile → Auth Tokens** erstellen.

2. Tagge dein Image:
   ```bash
   docker tag <image-name>:<tag> <region-code>.ocir.io/<namespace>/<repository-name>:<tag>
   ```

3. Pushe das Image in die Registry:
   ```bash
   docker push <region-code>.ocir.io/<namespace>/<repository-name>:<tag>
   ```

---

### **5. Image von der VM aus pullen**
1. Logge dich auf der VM in die OCIR ein:
   ```bash
   docker login <region-code>.ocir.io
   ```
2. Ziehe das Image:
   ```bash
   docker pull <region-code>.ocir.io/<namespace>/<repository-name>:<tag>
   ```

---

### **6. Container starten**
1. Starte den Container mit der entsprechenden Konfiguration:
   ```bash
   docker run -d -p 8080:8080 --name my-app <region-code>.ocir.io/<namespace>/<repository-name>:<tag>
   ```

2. Verifiziere, dass der Container läuft:
   ```bash
   docker ps
   ```

---

### **7. Firewall und Netzwerkkonfiguration**
1. **Sicherheitsregeln für die Subnetzgruppe anpassen:**
   - Gehe in der OCI-Konsole zu **Networking → Virtual Cloud Networks (VCN)**.
   - Wähle die Subnetzgruppe deiner VM.
   - Bearbeite die Sicherheitsregeln, um eingehenden Datenverkehr auf Port `8080` (oder den verwendeten Port) zuzulassen.

2. Verifiziere, dass die Anwendung über die öffentliche IP der VM und den Port erreichbar ist:
   ```bash
   http://<public-ip>:8080
   ```

---

### Zusammenfassung
Du hast:
1. Eine VM mit öffentlicher IP erstellt.
2. Docker installiert.
3. Dein Image in die OCIR gepusht und auf der VM ausgeführt.
4. Die Netzwerkkonfiguration angepasst, um den Zugriff auf den Container zu ermöglichen.


4. IDP-Client in OCI erstellen
a. IDP-Konfiguration in OCI
Melde dich in der OCI-Konsole an und gehe zu Identity → Federation → Identity Providers.

Klicke auf Create Identity Provider und wähle OpenID Connect.

Gib die Metadaten-URL deines IDPs ein (z. B. von Auth0 oder Okta) und konfiguriere die erforderlichen Felder:

Name: Ein benutzerdefinierter Name (z. B. MySpringBootApp).
Audience: Die URI deiner Anwendung.
Nach der Erstellung notiere dir:

Client-ID
Client-Secret
b. Verwendung von Client-ID und Secret
Bei Spring Boot brauchst du in der Regel nur die issuer-uri. Diese enthält alle Informationen über den Token-Endpunkt und die JWKs.
Wenn du eine explizite Client-Authentifizierung benötigst (z. B. für benutzerdefinierte Token-Validierungen), speichere client-id und client-secret in den Umgebungsvariablen und greife darauf im Code zu.
