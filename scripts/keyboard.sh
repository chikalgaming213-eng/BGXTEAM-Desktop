#!/data/data/com.termux/files/usr/bin/bash
set -u
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"; . "$SCRIPT_DIR/lib.sh"
set_keyboard() { local value="$1"; sed -i "s/^SHOW_ADDITIONAL_KEYBOARD=.*/SHOW_ADDITIONAL_KEYBOARD=$value/" "$BGX_CONFIG_DIR/keyboard.conf"; command -v termux-x11-preference >/dev/null 2>&1 && termux-x11-preference "showAdditionalKbd=$([[ "$value" = true ]] && echo true || echo false)" || true; }
printf 'Keyboard controls\n1) Show additional keys\n2) Hide additional keys\n3) Reload Termux settings\n4) Show current config\n'
read -r -p 'Select [1-4]: ' n
case "$n" in
  1) set_keyboard true; echo 'Additional keyboard enabled.';;
  2) set_keyboard false; echo 'Additional keyboard disabled.';;
  3) command -v termux-reload-settings >/dev/null 2>&1 && termux-reload-settings; echo 'Settings reloaded.';;
  4) cat "$BGX_CONFIG_DIR/keyboard.conf";;
  *) echo 'Invalid selection.'; exit 1;;
esac
