#!/data/data/com.termux/files/usr/bin/bash
set -u
printf 'BGXTEAM Developer Center\n1) Versions\n2) Project folders\n3) Start local HTTP server\n0) Exit\n'
read -r -p '> ' choice
case "$choice" in
  1) git --version 2>/dev/null || true; python --version 2>/dev/null || true; node --version 2>/dev/null || true; ssh -V 2>&1 || true;;
  2) root="${BGX_ROOT:-$HOME/BGXTEAM}"; find "$root/projects" "$root/tools" -maxdepth 2 -type d 2>/dev/null | sort;;
  3) read -r -p 'Directory [current]: ' dir; dir="${dir:-.}"; read -r -p 'Port [8080]: ' port; port="${port:-8080}"; cd "$dir" && python -m http.server "$port";;
  0) exit 0;;
  *) exit 1;;
esac
