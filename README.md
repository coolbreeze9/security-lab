# Laboratorio Suricata IPS + ELK Stack

Laboratorio de ciberseguridad con Suricata, Docker y WSL2.

## Requisitos

| Componente  | Versión              |
|-------------|----------------------|
| Windows     | 10 v2004+ / 11       |
| BIOS        | VT-x / AMD-V activo  |
| WSL2        | 2.6.3.0+             |
| Ubuntu      | 22.04 LTS            |
| Docker      | 29.4.3+              |
| RAM         | 16 GB mínimo         |
| Disco       | 50 GB mínimo         |

## Preparación del entorno

### Windows — Habilitar WSL2

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Restart-Computer
```

### Windows — Instalar Ubuntu 22.04

```powershell
wsl --update
wsl --set-default-version 2
wsl --install -d Ubuntu-22.04
```

Verificar que muestra VERSION 2:

```powershell
wsl -l -v
```

### Ubuntu — Configurar sistema

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git vim jq net-tools
echo 'vm.max_map_count=262144' | sudo tee -a /etc/sysctl.conf
sudo sysctl -w vm.max_map_count=262144
```

## Instalación de Docker Engine

```bash
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker $USER
sudo service docker start
```

Cerrar y reabrir el terminal para aplicar los cambios de grupo.

Verificar:

```bash
docker run hello-world
```

## Instalación del laboratorio

```bash
git clone https://github.com/coolbreeze9/security-lab.git
cd security-lab
chmod +x start-lab.sh
./start-lab.sh
```

### Configurar DVWA

- Abrir http://localhost:8080
- Usuario: admin / Contraseña: password
- Clic en Create / Reset Database
- DVWA Security → Low

### Verificar Kibana

- Abrir http://localhost:5601

## Comandos útiles

### Gestión

```bash
./start-lab.sh                                    # Levantar
docker compose ps                                 # Estado
docker compose logs -f                            # Logs
docker compose down                               # Apagar
docker compose down && docker system prune -a --volumes -f  # Apagar y limpiar todo
```

### Acceso a contenedores

```bash
docker exec -it kali-attacker bash
docker exec -it suricata-ips bash
```

### Ataques disponibles

Acceder primero al contenedor Kali:

```bash
docker exec -it kali-attacker bash
```

```bash
# Escaneo de red
nmap -sS -T4 172.20.0.30

# SQL Injection
curl "http://172.20.0.30/vulnerabilities/sqli/?id=1'+OR+'1'='1&Submit=Submit" \
     -H "Cookie: PHPSESSID=test; security=low"

# SQLMap
sqlmap -u "http://172.20.0.30/vulnerabilities/sqli/?id=1&Submit=Submit" \
       --cookie="PHPSESSID=test; security=low" --batch

# Path Traversal
curl "http://172.20.0.30/vulnerabilities/fi/?page=../../../etc/passwd" \
     -H "Cookie: PHPSESSID=test; security=low"

# XSS
curl "http://172.20.0.30/vulnerabilities/xss_r/?name=<script>alert(1)</script>" \
     -H "Cookie: PHPSESSID=test; security=low"
```

### Monitorización

```bash
docker exec suricata-ips tail -f /var/log/suricata/fast.log   # Alertas en tiempo real
docker exec suricata-ips tail -f /var/log/suricata/eve.json   # Eventos completos
curl http://localhost:9200/_cluster/health | jq               # Estado Elasticsearch
curl http://localhost:9200/_cat/indices?v | grep suricata     # Índices creados
```

## Accesos

| Servicio      | URL                   | Credenciales     |
|---------------|-----------------------|------------------|
| DVWA          | http://localhost:8080 | admin / password |
| Kibana        | http://localhost:5601 | —                |
| Elasticsearch | http://localhost:9200 | —                |
