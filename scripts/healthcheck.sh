#!/data/data/com.termux/files/usr/bin/bash
set -u
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"; . "$SCRIPT_DIR/lib.sh"
fail=0; printf '=== BGXTEAM HEALTH CHECK ===\nRoot: %s\nDisplay: %s\nTheme: %s\n\n' "$BGX_ROOT" "${DISPLAY:-:1}" "$BGX_THEME"
for x in termux-x11 startxfce4 dbus-launch xfconf-query git python node ssh; do if bgx_have "$x"; then printf '[OK]   %s\n' "$x"; else printf '[MISS] %s\n' "$x"; fail=1; fi; done
if pgrep -f xfce4-session >/dev/null 2>&1; then echo '[OK]   XFCE session running'; else echo '[INFO] XFCE session is not running'; fi
if [ -S "${TMPDIR:-/tmp}/.X11-unix/X1" ] || [ -S /tmp/.X11-unix/X1 ]; then echo '[OK]   X11 socket detected'; else echo '[INFO] X11 socket not detected'; fi
[ -f "$BGX_LOG_DIR/xfce.log" ] && echo "[INFO] XFCE log: $BGX_LOG_DIR/xfce.log"
exit "$fail"
