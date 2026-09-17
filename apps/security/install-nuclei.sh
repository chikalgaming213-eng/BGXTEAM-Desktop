#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
ROOT="${BGX_ROOT:-$HOME/BGXTEAM}"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
command -v nethunter >/dev/null 2>&1 || { echo 'NetHunter belum tersedia. Jalankan install-nethunter.sh terlebih dahulu.'; exit 1; }
"$SCRIPT_DIR/install-nethunter.sh"
printf 'Nuclei telah dipasang di dalam distro Kali NetHunter.\nJalankan: nethunter nuclei -version\n'
