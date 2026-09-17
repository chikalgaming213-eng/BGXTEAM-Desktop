#!/data/data/com.termux/files/usr/bin/bash
set -u
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"; . "$SCRIPT_DIR/lib.sh"
mapfile -t themes < <(find "$BGX_ROOT/themes" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort)
[ "${#themes[@]}" -gt 0 ] || { echo 'No themes found.'; exit 1; }
printf 'Available themes:\n'; for i in "${!themes[@]}"; do printf '%d) %s\n' "$((i+1))" "${themes[$i]}"; done
read -r -p 'Select theme: ' n
if [[ "$n" =~ ^[0-9]+$ ]] && [ "$n" -ge 1 ] && [ "$n" -le "${#themes[@]}" ]; then
  theme="${themes[$((n-1))]}"; printf '%s\n' "$theme" > "$BGX_STATE_DIR/theme"; bgx_load_theme
  if bgx_have xfconf-query; then xfconf-query -c xsettings -p /Net/ThemeName -s "$GTK_THEME" 2>/dev/null || true; xfconf-query -c xsettings -p /Net/IconThemeName -s "$ICON_THEME" 2>/dev/null || true; fi
  bgx_log "Theme selected: $theme"; echo "Theme selected: $theme"; echo 'Restart XFCE or run bgxrestart to apply all settings.'
else echo 'Invalid selection.'; exit 1; fi
