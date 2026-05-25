#!/bin/bash
TARGET="172.20.0.30"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "escaneo de red: $TARGET"
echo "fecha: $(date)"
echo ""

echo "[1] escaneo syn de puertos principales"
nmap -sS -T4 --top-ports 100 $TARGET

echo ""
echo "[2] escaneo xmas detectado por suricata"
nmap -sX -p 80,443,8080 $TARGET

echo ""
echo "[3] escaneo null detectado por suricata"
nmap -sN -p 80,443,8080 $TARGET

echo ""
echo "escaneo completado"
