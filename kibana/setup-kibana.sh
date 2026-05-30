#!/bin/bash
set -euo pipefail

KIBANA_URL="http://localhost:5601"
DASHBOARD="$(dirname "$0")/dashboards/suricata-dashboard.ndjson"

echo "[1] Esperando Kibana"
until curl -s "$KIBANA_URL/api/status" | grep -q '"level":"available"'; do
  sleep 5
done

echo "[2] Importando dashboard"
curl -s -X POST "$KIBANA_URL/api/saved_objects/_import?overwrite=true" \
  -H "kbn-xsrf: true" \
  -F "file=@$DASHBOARD" | jq .

echo "Dashboard importado correctamente"
echo "Abrir: $KIBANA_URL/app/dashboards"
