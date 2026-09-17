#!/data/data/com.termux/files/usr/bin/bash
set -u
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
"$SCRIPT_DIR/stop.sh"
sleep 2
exec "$SCRIPT_DIR/start.sh"
