#!/bin/bash
set -euo pipefail

TARGET="172.20.0.30"

echo "=== ESCANEO DE RED: $TARGET ==="
echo "fecha: $(date)"
echo ""

ping -c 1 "$TARGET" >/dev/null 2>&1 || { echo "ERROR: $TARGET no responde"; exit 1; }

echo "[1] SYN scan - detectado por suricata"
nmap -sS -T4 --top-ports 100 "$TARGET" 2>/dev/null
echo ""

echo "[2] XMAS scan - detectado por suricata"
nmap -sX -p 80,443,8080 "$TARGET" 2>/dev/null
echo ""

echo "[3] NULL scan - detectado por suricata"
nmap -sN -p 80,443,8080 "$TARGET" 2>/dev/null
echo ""

echo "[4] FIN scan - detectado por suricata"
nmap -sF -p 80,443,8080 "$TARGET" 2>/dev/null
echo ""

echo "=== ESCANEO COMPLETADO ==="
