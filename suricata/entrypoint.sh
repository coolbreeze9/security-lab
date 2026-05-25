#!/bin/bash
rm -f /var/run/suricata.pid
set -e

echo "iniciando suricata"

echo "[1] actualizando reglas"
suricata-update --no-test 2>/dev/null || true

mkdir -p /var/log/suricata

echo "[2] iniciando suricata en modod af_packet"
exec suricata -c /etc/suricata/suricata.yaml --af-packet
