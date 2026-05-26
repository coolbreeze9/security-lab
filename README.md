# Laboratorio Suricata IPS + ELK Stack

Laboratorio de ciberseguridad con Suricata, Docker y WSL2.

## Requisitos

- Windows 11
- WSL2 2.6.3.0
- Ubuntu 22.04
- Docker Engine 29.4.3

## Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/coolbreeze9/security-lab.git
cd security-lab
```

### 2. Configurar memoria para Elasticsearch

```bash
sudo sysctl -w vm.max_map_count=262144
```

### 3. Arrancar el laboratorio

```bash
chmod +x arranque.sh
bash arranque.sh
```

### 4. Configurar DVWA

- Abrir http://localhost:8080
- Usuario: admin / Contraseña: password
- Clic en Create / Reset Database
- DVWA Security → Low

### 5. Verificar Kibana

- Abrir http://localhost:5601

## Comandos útiles

### Gestión del laboratorio

```bash
# Levantar el laboratorio
bash arranque.sh

# Ver estado de los contenedores
docker compose ps

# Ver logs en tiempo real
docker compose logs -f

# Apagar el laboratorio
docker compose down

# Apagar y eliminar todo
docker compose down && docker system prune -a --volumes -f
```

### Acceder a los contenedores

```bash
# Acceder a Kali (atacante)
docker exec -it kali-attacker bash

# Acceder a Suricata
docker exec -it suricata-ips bash
```

### Ataques disponibles

```bash
# Desde el contenedor Kali
docker exec -it kali-attacker bash

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
# Ver alertas de Suricata en tiempo real
docker exec suricata-ips tail -f /var/log/suricata/fast.log

# Ver todos los eventos en eve.json
docker exec suricata-ips tail -f /var/log/suricata/eve.json

# Verificar estado de Elasticsearch
curl http://localhost:9200/_cluster/health | jq

# Ver índices creados
curl http://localhost:9200/_cat/indices?v | grep suricata
```

### Accesos web

| Servicio      | URL                        | Credenciales       |
|---------------|----------------------------|--------------------|
| DVWA          | http://localhost:8080      | admin / password   |
| Kibana        | http://localhost:5601      | —                  |
| Elasticsearch | http://localhost:9200      | —                  |
