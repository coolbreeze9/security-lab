#!/bin/bash
set -euo pipefail

TARGET="http://172.20.0.30"
COOKIE="PHPSESSID=test; security=low"

resultado() {
  local output="$1"
  if [ -z "$output" ]; then
    echo "BLOQUEADO por Suricata"
  else
    echo "DETECTADO - respuesta recibida"
  fi
}

echo "=== ATAQUES WEB CONTRA DVWA =="
echo ""

echo "[1] SQLi OR 1=1 - bloqueado por suricata"
OUT=$(curl -s "$TARGET/vulnerabilities/sqli/?id=1'+OR+1%3D1&Submit=Submit" \
     -H "Cookie: $COOKIE" || true)
resultado "$OUT"
echo ""

echo "[2] SQLi UNION SELECT - bloqueado por suricata"
OUT=$(curl -s "$TARGET/vulnerabilities/sqli/?id=1'+UNION+SELECT+1,2--&Submit=Submit" \
     -H "Cookie: $COOKIE" || true)
resultado "$OUT"
echo ""

echo "[3] LFI Path Traversal - bloqueado por suricata"
OUT=$(curl -s "$TARGET/vulnerabilities/fi/?page=../../../etc/passwd" \
     -H "Cookie: $COOKIE" || true)
resultado "$OUT"
echo ""

echo "[4] LFI /etc/passwd - bloqueado por suricata"
OUT=$(curl -s "$TARGET/vulnerabilities/fi/?page=/etc/passwd" \
     -H "Cookie: $COOKIE" || true)
resultado "$OUT"
echo ""

echo "[5] XSS reflejado - detectado por suricata"
OUT=$(curl -s "$TARGET/vulnerabilities/xss_r/?name=<script>alert('XSS')</script>" \
     -H "Cookie: $COOKIE" || true)
resultado "$OUT"
echo ""

echo "[6] CMDi Pipe - bloqueado por suricata"
OUT=$(curl -s -G "$TARGET/vulnerabilities/exec/" \
     --data-urlencode "ip=127.0.0.1|id" \
     -d "Submit=Submit" \
     -H "Cookie: $COOKIE" || true)
resultado "$OUT"
echo ""

echo "[7] CMDi Semicolon - bloqueado por suricata"
OUT=$(curl -s -G "$TARGET/vulnerabilities/exec/" \
     --data-urlencode "ip=127.0.0.1;id" \
     -d "Submit=Submit" \
     -H "Cookie: $COOKIE" || true)
resultado "$OUT"
echo ""

echo "[8] Fuerza bruta login - detectado por suricata"
for i in {1..6}; do
  curl -s -X POST "$TARGET/login.php" \
       -d "username=admin&password=test$i&Login=Login" \
       -H "Cookie: $COOKIE" >/dev/null || true
  echo "intento $i enviado"
done
echo ""

echo "=== ATAQUES COMPLETADOS ==="
