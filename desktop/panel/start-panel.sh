#!/data/data/com.termux/files/usr/bin/bash
set -u
ROOT="${BGX_ROOT:-$HOME/BGXTEAM}"
[ -f "$ROOT/scripts/lib.sh" ] && . "$ROOT/scripts/lib.sh"
if ! command -v xfce4-panel >/dev/null 2>&1; then exit 0; fi
if pgrep -f 'xfce4-panel' >/dev/null 2>&1; then exit 0; fi
xfce4-panel >/dev/null 2>&1 &
panel_pid=$!
[ -n "${BGX_STATE_DIR:-}" ] && echo "$panel_pid" > "$BGX_STATE_DIR/panel.pid"
if command -v xfconf-query >/dev/null 2>&1; then
  xfconf-query -c xfce4-panel -p /panels/panel-1/position -s "${PANEL_POSITION:-bottom}" 2>/dev/null || true
  xfconf-query -c xfce4-panel -p /panels/panel-1/size -s "${PANEL_SIZE:-36}" 2>/dev/null || true
fi
