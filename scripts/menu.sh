#!/data/data/com.termux/files/usr/bin/bash
set -u
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"; . "$SCRIPT_DIR/lib.sh"
launch() { if bgx_have "$1"; then "$@" & else echo "Command not installed: $1"; bgx_pause; fi; }
while true; do
  clear
  printf '\033[1;31mBGXTEAM LAUNCHER\033[0m | theme=%s | display=%s\n\n' "$BGX_THEME" "${DISPLAY:-:1}"
  printf '1) Terminal\n2) File Manager\n3) Developer tools\n4) System monitor\n5) Network diagnostics\n6) Security diagnostics\n7) XFCE settings\n8) System information\n9) Keyboard\nT) Change theme\n0) Exit\n\n'
  read -r -p 'BGX > ' n
  case "${n,,}" in
    1) launch "${SHELL:-bash}";;
    2) if bgx_have thunar; then thunar & elif bgx_have pcmanfm; then pcmanfm & else echo 'Install thunar or pcmanfm.'; bgx_pause; fi;;
    3) "$BGX_ROOT/apps/developer/center.sh"; bgx_pause;;
    4) launch htop;;
    5) "$BGX_ROOT/apps/network/diagnose.sh"; bgx_pause;;
    6) "$BGX_ROOT/apps/security/center.sh";;
    7) if bgx_have xfce4-settings; then xfce4-settings & else "$BGX_ROOT/apps/settings/control-center.sh"; bgx_pause; fi;;
    8) "$SCRIPT_DIR/info.sh"; bgx_pause;;
    9) "$SCRIPT_DIR/keyboard.sh"; bgx_pause;;
    t) "$SCRIPT_DIR/theme.sh";;
    0) exit 0;;
    *) echo 'Unknown option'; sleep 1;;
  esac
done
