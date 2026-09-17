#!/data/data/com.termux/files/usr/bin/bash
set -u
host="${1:-1.1.1.1}"
printf 'Interfaces:\n'; ip -brief addr 2>/dev/null || ifconfig 2>/dev/null || true
printf '\nRoutes:\n'; ip route 2>/dev/null || true
printf '\nConnectivity to %s:\n' "$host"
if command -v ping >/dev/null 2>&1; then ping -c 1 -W 2 "$host"; else echo 'ping is not installed'; fi
printf '\nDNS:\n'; getent hosts example.com 2>/dev/null || nslookup example.com 2>/dev/null || echo 'DNS lookup unavailable'
