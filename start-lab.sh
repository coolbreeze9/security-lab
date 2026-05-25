#!/bin/bash

docker compose up -d

sleep 5

IFACE=$(ip link show | grep -o 'br-[a-f0-9]*' | head -1)

sed -i "s/- interface: br-.*/- interface: $IFACE/" ~/security-lab/suricata/config/suricata.yaml

docker compose restart suricata-ips

echo "laboratorio listo"
