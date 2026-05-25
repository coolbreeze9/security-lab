#!/bin/bash
set -e

echo "[1] Arrancando contenedores."
docker compose up -d

echo "[2] Esperando red Docker."
sleep 8

echo "[3] Detectando interfaz bridge."
IFACE=$(ip link show | grep -o 'br-[a-f0-9]*' | head -1)

if [ -z "$IFACE" ]; then
  echo "ERROR: Interfaz no encontrada. Verifica Docker."
  exit 1
fi

echo "[4] Configurando Suricata: $IFACE"
sed -i "s/- interface: br-.*/- interface: $IFACE/" ~/security-lab/suricata/config/suricata.yaml

echo "[5] Reiniciando Suricata."
docker compose restart suricata-ips

echo "Laboratorio listo"
echo "DVWA:          http://localhost:8080"
echo "Kibana:        http://localhost:5601"
echo "Elasticsearch: http://localhost:9200"
