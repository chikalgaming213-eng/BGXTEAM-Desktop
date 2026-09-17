#!/data/data/com.termux/files/usr/bin/bash
set -u
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"; . "$SCRIPT_DIR/lib.sh"
bgx_load_config
export DISPLAY="${DISPLAY:-${DISPLAY_CONF:-:1}}" XDG_CURRENT_DESKTOP=XFCE DESKTOP_SESSION=xfce
export XDG_RUNTIME_DIR="$BGX_RUNTIME_DIR"
mkdir -p "$XDG_RUNTIME_DIR"; chmod 700 "$XDG_RUNTIME_DIR"

if ! bgx_have termux-x11 || ! bgx_have startxfce4; then
  echo "Missing Termux:X11/XFCE dependencies. Run install.sh first."; exit 1
fi
if pgrep -f "xfce4-session" >/dev/null 2>&1; then echo "BGXTEAM is already running on $DISPLAY."; exit 0; fi
if ! pgrep -f "termux-x11.*${DISPLAY}" >/dev/null 2>&1; then
  args=("$DISPLAY"); [ "${LEGACY_DRAWING:-${BGX_LEGACY_DRAWING:-false}}" = "true" ] && args+=("-legacy-drawing")
  termux-x11 "${args[@]}" >>"$BGX_LOG_DIR/x11.log" 2>&1 & echo $! > "$BGX_STATE_DIR/x11.pid"
  sleep 2
fi
if bgx_have dbus-launch; then nohup dbus-launch --exit-with-session startxfce4 >"$BGX_LOG_DIR/xfce.log" 2>&1 &
else nohup startxfce4 >"$BGX_LOG_DIR/xfce.log" 2>&1 & fi
echo $! > "$BGX_STATE_DIR/xfce.pid"
sleep 3
WALL="$BGX_ROOT/assets/bgxteam.png"
if bgx_have xfconf-query && [ -f "$WALL" ]; then
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "$WALL" 2>/dev/null || true
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-style -s 5 2>/dev/null || true
fi
[ -x "$BGX_ROOT/desktop/panel/start-panel.sh" ] && "$BGX_ROOT/desktop/panel/start-panel.sh" >>"$BGX_LOG_DIR/panel.log" 2>&1 &
bgx_log "Desktop started display=$DISPLAY theme=$BGX_THEME"
echo "BGXTEAM Desktop started on DISPLAY=$DISPLAY (theme: $BGX_THEME)"
