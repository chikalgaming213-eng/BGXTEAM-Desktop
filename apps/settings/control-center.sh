#!/data/data/com.termux/files/usr/bin/bash
set -u
ROOT="${BGX_ROOT:-$HOME/BGXTEAM}"
printf 'BGXTEAM Control Center\n1) Health check\n2) Theme\n3) Keyboard\n4) Restart desktop\n0) Exit\n'
read -r -p '> ' choice
case "$choice" in
  1) "$ROOT/scripts/healthcheck.sh";; 2) "$ROOT/scripts/theme.sh";; 3) "$ROOT/scripts/keyboard.sh";; 4) "$ROOT/scripts/restart.sh";; 0) exit 0;; *) exit 1;;
esac
