#!/bin/bash
TARGET="http://172.20.0.30"
COOKIE="PHPSESSID=test; security=low"

echo "ataques web contra dvwa"
echo ""

echo "[1] sql injection OR 1=1 bloqueado por suricata"
curl -s "$TARGET/vulnerabilities/sqli/?id=1'+OR+1%3D1&Submit=Submit" \
     -H "Cookie: $COOKIE" | head -5
echo ""

echo "[2] sql injection union select bloqueado"
curl -s "$TARGET/vulnerabilities/sqli/?id=1'+UNION+SELECT+1,2--&Submit=Submit" \
     -H "Cookie: $COOKIE" | head -5
echo ""

echo "[3] path traversal bloqueado"
curl -s "$TARGET/vulnerabilities/fi/?page=../../../etc/passwd" \
     -H "Cookie: $COOKIE" | head -5
echo ""

echo "[4] xss reflejado detectado"
curl -s "$TARGET/vulnerabilities/xss_r/?name=<script>alert('XSS')</script>" \
     -H "Cookie: $COOKIE" | head -5
echo ""

echo "[5] command injection bloqueado"
curl -s -X POST "$TARGET/vulnerabilities/exec/" \
     -H "Cookie: $COOKIE" \
     -d "ip=127.0.0.1|id&Submit=Submit" | head -5
echo ""

echo "[6] fuerza bruta detectada por suricata"
for i in {1..6}; do
  curl -s -X POST "$TARGET/login.php" \
       -d "username=admin&password=test$i&Login=Login" | head -1
done
echo ""

echo "ataques completados"
