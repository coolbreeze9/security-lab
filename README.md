# Laboratorio Suricata IPS + ELK Stack

Laboratorio de ciberseguridad con Suricata, Docker y WSL2.

## Requisitos
- Windows 11
- WSL2 2.6.3.0
- Ubuntu 22.04
- Docker Engine 29.4.3

## Instalación

### 1. Clonar el repositorio
git clone https://github.com/coolbreeze9/security-lab.git
cd security-lab

### 2. Configurar memoria para Elasticsearch
sudo sysctl -w vm.max_map_count=262144

### 3. Arrancar el laboratorio
chmod +x arranque.sh
bash arranque.sh

### 4. Configurar DVWA
- Abrir http://localhost:8080
- Usuario: admin / Contraseña: password
- Clic en Create / Reset Database
- DVWA Security → Low

### 5. Verificar Kibana
- Abrir http://localhost:5601
