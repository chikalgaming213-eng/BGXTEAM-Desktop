#!/data/data/com.termux/files/usr/bin/bash
# BGXTEAM shared runtime helpers
set -u

BGX_ROOT="${BGX_ROOT:-$HOME/BGXTEAM}"
BGX_CONFIG_DIR="${BGX_CONFIG_DIR:-$BGX_ROOT/config}"
BGX_LOG_DIR="${BGX_LOG_DIR:-$BGX_ROOT/logs}"
BGX_STATE_DIR="${BGX_STATE_DIR:-$BGX_ROOT/state}"
BGX_RUNTIME_DIR="${BGX_RUNTIME_DIR:-${TMPDIR:-/tmp}/bgx-runtime}"
mkdir -p "$BGX_LOG_DIR" "$BGX_STATE_DIR" "$BGX_RUNTIME_DIR" 2>/dev/null || true

bgx_log() { printf '[%s] %s\n' "$(date '+%F %T')" "$*" >> "$BGX_LOG_DIR/bgx.log"; }
bgx_have() { command -v "$1" >/dev/null 2>&1; }
bgx_pause() { read -r -p "Press Enter to continue..." _ </dev/tty 2>/dev/null || true; }
bgx_load_config() {
  [ -f "$BGX_CONFIG_DIR/desktop.conf" ] && . "$BGX_CONFIG_DIR/desktop.conf"
  [ -f "$BGX_CONFIG_DIR/display.conf" ] && . "$BGX_CONFIG_DIR/display.conf"
  [ -f "$BGX_CONFIG_DIR/keyboard.conf" ] && . "$BGX_CONFIG_DIR/keyboard.conf"
  export BGX_ROOT BGX_CONFIG_DIR BGX_LOG_DIR BGX_STATE_DIR BGX_RUNTIME_DIR
}
bgx_load_theme() {
  local theme="${BGX_THEME:-BGXTEAM-RED}"
  local file="$BGX_ROOT/themes/$theme/theme.conf"
  [ -f "$BGX_STATE_DIR/theme" ] && theme=$(cat "$BGX_STATE_DIR/theme")
  file="$BGX_ROOT/themes/$theme/theme.conf"
  [ -f "$file" ] && . "$file"
  export BGX_THEME="$theme"
}
bgx_load_config
bgx_load_theme
