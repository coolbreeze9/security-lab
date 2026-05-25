#!/bin/bash
TARGET="http://172.20.0.30"
COOKIE="PHPSESSID=test; security=low"

echo "ataques web contra dvwa"
echo ""

echo "[1] sql injection pr 1=1 bloqueado por suricata"
curl -s "$TARGET/vulnerabilities/sqli/?id=1'+OR+'1'='1&Submit=Submit" \
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
echo "[4] xss reflejado detectado pero no bloqueado"
curl -s "$TARGET/vulnerabilities/xss_r/?name=<script>alert('XSS')</script>" \
     -H "Cookie: $COOKIE" | head -5

echo ""
echo "ataques completados"
