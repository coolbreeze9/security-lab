# Laboratorio Suricata IPS + ELK Stack

Laboratorio de ciberseguridad con Suricata IDS/IPS, Docker y WSL2.

## Requisitos

| Componente | Versión             |
|------------|---------------------|
| Windows    | 10 v2004+ / 11      |
| BIOS       | VT-x / AMD-V activo |
| WSL2       | 2.6.3.0+            |
| Ubuntu     | 22.04 LTS           |
| Docker     | 29.4.3+             |
| RAM        | 16 GB mínimo        |
| Disco      | 50 GB mínimo        |

## Preparación del entorno

### 1. Habilitar WSL2
Ejecutar en PowerShell como administrador:
```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Restart-Computer
```

### 2. Instalar Ubuntu 22.04
```powershell
wsl --update
wsl --set-default-version 2
wsl --install -d Ubuntu-22.04
```

Verificar que WSL2 está activo:
```powershell
wsl -l -v
```
Debe mostrar `VERSION 2` junto a Ubuntu-22.04.

### 3. Configurar Ubuntu
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git jq net-tools
```

Hacer permanente el parámetro de memoria para Elasticsearch:
```bash
echo 'vm.max_map_count=262144' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### 4. Instalar Docker Engine
```bash
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo service docker start
```

Verificar que Docker funciona:
```bash
docker run hello-world
```

### 5. Crear usuario del laboratorio
```bash
sudo useradd -m -s /bin/bash suricata
sudo passwd suricata
sudo usermod -aG docker,sudo suricata
```

Cerrar y reabrir el terminal, luego cambiar al usuario:
```bash
su - suricata
```

## Instalación del laboratorio

```bash
git clone https://github.com/coolbreeze9/security-lab.git
cd security-lab
chmod +x start-lab.sh kali/scripts/*.sh
./start-lab.sh
```

El script `start-lab.sh` realiza automáticamente:
- Ajuste de `vm.max_map_count` para Elasticsearch
- Permisos del volumen de datos
- Detección de la interfaz bridge de Docker
- Espera activa hasta que todos los servicios estén listos

### Configurar DVWA

Abrir http://localhost:8080
Usuario: admin / Contraseña: password
Clic en Create / Reset Database
DVWA Security > Low

## Accesos

| Servicio      | URL                   | Credenciales     |
|---------------|-----------------------|------------------|
| DVWA          | http://localhost:8080 | admin / password |
| Kibana        | http://localhost:5601 | -                |
| Elasticsearch | http://localhost:9200 | -                |

## Comandos útiles

### Gestión del laboratorio
```bash
./start-lab.sh                                             # Iniciar
docker compose ps                                          # Estado
docker compose logs -f                                     # Logs
docker compose down                                        # Apagar
docker compose down && docker system prune -a --volumes -f # Apagar y limpiar todo
```

### Acceso a contenedores
```bash
docker exec -it kali-attacker bash   # Contenedor atacante
docker exec -it suricata-ips bash    # Contenedor Suricata
```

### Scripts de ataque
Desde dentro del contenedor `kali-attacker`:
```bash
/pentest/scripts/scan-target.sh    # Escaneos de puertos (SYN, XMAS, NULL, FIN)
/pentest/scripts/web-attacks.sh    # SQLi, LFI, XSS, CMDi, fuerza bruta
/pentest/scripts/sqlmap-attack.sh  # Ataque automatizado con SQLMap
```

### Monitorización de alertas
```bash
docker exec suricata-ips tail -f /var/log/suricata/fast.log
docker exec suricata-ips tail -f /var/log/suricata/eve.json
curl http://localhost:9200/_cat/indices?v | grep suricata
```

## Arquitectura

Windows 11
└── WSL2 (Ubuntu 22.04)
└── Docker
├── kali-attacker   (172.20.0.10)  — herramientas de ataque
├── dvwa-victim     (172.20.0.30)  — aplicación vulnerable
├── suricata-ips    (host)         — IDS/IPS
├── elasticsearch   (172.20.0.40)  — almacenamiento de alertas
├── logstash        (172.20.0.41)  — procesamiento de logs
└── kibana          (172.20.0.42)  — visualización
