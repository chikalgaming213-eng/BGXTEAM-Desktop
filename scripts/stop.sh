#!/data/data/com.termux/files/usr/bin/bash
set -u
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"; . "$SCRIPT_DIR/lib.sh"
stop_pidfile() { local f="$1"; [ -f "$f" ] || return 0; local pid; pid=$(cat "$f" 2>/dev/null || true); [ -n "$pid" ] && kill "$pid" 2>/dev/null || true; rm -f "$f"; }
stop_pidfile "$BGX_STATE_DIR/xfce.pid"; stop_pidfile "$BGX_STATE_DIR/x11.pid"
pkill -f "xfce4-session" 2>/dev/null || true; pkill -f "xfdesktop" 2>/dev/null || true; pkill -f "xfce4-panel" 2>/dev/null || true
if [ "${DISPLAY:-:1}" = ":1" ]; then pkill -f 'termux-x11.*:1' 2>/dev/null || true; fi
bgx_log "Desktop stopped"; echo "BGXTEAM stopped."
