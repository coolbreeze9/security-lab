#!/bin/bash
set -euo pipefail

# Directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Comprobaciones previas
echo "[0] Comprobando dependencias"
command -v docker >/dev/null 2>&1 || { echo "ERROR: Docker no instalado"; exit 1; }
docker info       >/dev/null 2>&1 || { echo "ERROR: Docker no está en ejecución"; exit 1; }

# Parámetros del sistema
echo "[1] Configurando sistema"
CURRENT_MAP=$(cat /proc/sys/vm/max_map_count)
if [ "$CURRENT_MAP" -lt 262144 ]; then
  sudo sysctl -w vm.max_map_count=262144 >/dev/null
fi

# Permisos Elasticsearch
echo "[2] Preparando volumen Elasticsearch"
mkdir -p "$SCRIPT_DIR/elasticsearch/data"
sudo chown -R 1000:1000 "$SCRIPT_DIR/elasticsearch/data"

# Arrancar contenedores
echo "[3] Arrancando contenedores"
docker compose up -d

# Esperar interfaz bridge
echo "[4] Esperando red Docker bridge"
TIMEOUT=30
ELAPSED=0
until ip link show 2>/dev/null | grep -q 'br-[a-f0-9]*'; do
  sleep 1
  ELAPSED=$((ELAPSED + 1))
  [ "$ELAPSED" -ge "$TIMEOUT" ] && { echo "ERROR: Timeout esperando red bridge"; exit 1; }
done

# Detectar interfaz
IFACE=$(ip link show | grep -o 'br-[a-f0-9]*' | head -1)
echo "[5] Interfaz detectada: $IFACE"

# Configurar Suricata
YAML="$SCRIPT_DIR/suricata/config/suricata.yaml"
[ -f "$YAML" ] || { echo "ERROR: No se encuentra $YAML"; exit 1; }
sed -i "s/- interface: br-.*/- interface: $IFACE/" "$YAML"

# Esperar Elasticsearch
echo "[6] Esperando Elasticsearch"
TIMEOUT=60
ELAPSED=0
until docker exec elasticsearch curl -s http://localhost:9200 >/dev/null 2>&1; do
  sleep 2
  ELAPSED=$((ELAPSED + 2))
  [ "$ELAPSED" -ge "$TIMEOUT" ] && { echo "ERROR: Elasticsearch no respondió en ${TIMEOUT}s"; exit 1; }
done

# Reiniciar Suricata
echo "[7] Reiniciando Suricata"
docker compose restart suricata-ips >/dev/null

echo ""
echo "Laboratorio listo"
echo "DVWA:          http://localhost:8080"
echo "Kibana:        http://localhost:5601"
echo "Elasticsearch: http://localhost:9200"
