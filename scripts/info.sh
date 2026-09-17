#!/data/data/com.termux/files/usr/bin/bash
set -u
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"; . "$SCRIPT_DIR/lib.sh"
clear
printf '\033[1;31mBGXTEAM SYSTEM\033[0m\nDesktop: XFCE\nDisplay: %s\nTheme: %s\nUser: %s\nKernel: %s\nArch: %s\n\n' "${DISPLAY:-:1}" "$BGX_THEME" "$(whoami)" "$(uname -sr)" "$(uname -m)"
echo 'CPU:'; (top -bn1 2>/dev/null | head -n 3 || uptime); echo
echo 'Memory:'; free -h 2>/dev/null || true; echo
echo 'Storage:'; df -h "$HOME" 2>/dev/null | tail -n 1 || true; echo
echo 'Processes:'; pgrep -af 'xfce4-session|termux-x11' 2>/dev/null || echo 'Desktop processes are not running.'
