#!/bin/bash
set -euo pipefail

rm -f /var/run/suricata.pid
mkdir -p /var/log/suricata

echo "[1] actualizando reglas"
suricata-update --no-test 2>/dev/null || true

echo "[2] validando configuracion"
suricata -T -c /etc/suricata/suricata.yaml -v 2>/dev/null \
  && echo "configuracion valida" \
  || { echo "ERROR: configuracion invalida"; exit 1; }

echo "[3] iniciando suricata en modo af_packet"
exec suricata -c /etc/suricata/suricata.yaml --af-packet
