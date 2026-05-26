#!/bin/bash
set -eo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[1] Arrancando contenedores"
docker compose up -d

echo "[2] Esperando interfaz bridge"
TIMEOUT=30
COUNT=0
until IFACE=$(ip link show | grep -o 'br-[a-f0-9]*' | head -1) && [ -n "$IFACE" ]; do
  sleep 1
  COUNT=$((COUNT + 1))
  if [ "$COUNT" -ge "$TIMEOUT" ]; then
    echo "ERROR: Interfaz no encontrada tras ${TIMEOUT}s"
    exit 1
  fi
done

echo "[3] Configurando Suricata: $IFACE"
sed -i "s/- interface: br-.*/- interface: $IFACE/" "$DIR/suricata/config/suricata.yaml"

echo "[4] Reiniciando Suricata"
docker compose restart suricata-ips

echo "Laboratorio listo"
echo "DVWA:          http://localhost:8080"
echo "Kibana:        http://localhost:5601"
echo "Elasticsearch: http://localhost:9200"
