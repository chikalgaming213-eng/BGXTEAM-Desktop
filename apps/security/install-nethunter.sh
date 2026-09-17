#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
ROOT="${BGX_ROOT:-$HOME/BGXTEAM}"
STATE="$ROOT/state"
mkdir -p "$STATE" "$ROOT/logs" "$ROOT/projects/nuclei" "$ROOT/tools"

require_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "Dependency missing: $1" >&2; exit 1; }; }
require_cmd proot-distro
if ! proot-distro list --installed 2>/dev/null | awk '{print $1}' | grep -qx kali; then
  echo 'Kali belum terpasang. Menginstal distro Kali minimal...'
  proot-distro install kali
fi

# Install hanya dependency dasar + Nuclei di dalam filesystem Kali.
echo 'Menyiapkan Kali dan Nuclei di dalam NetHunter...'
proot-distro login kali --termux-home -- /bin/bash -lc '
  set -e
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y --no-install-recommends ca-certificates curl git golang-go
  GOBIN=/usr/local/bin go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
  mkdir -p /root/nuclei-templates /root/.config/nuclei
  /usr/local/bin/nuclei -update-templates || true
  /usr/local/bin/nuclei -version
'

cat > "$ROOT/tools/nethunter" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

kali_exec() { exec proot-distro login kali --termux-home -- "$@"; }
kali_bin() {
  local command_name="$1"; shift
  exec proot-distro login kali --termux-home -- /bin/bash -lc '
    command_name="$1"; shift
    resolved="$(command -v "$command_name" 2>/dev/null || true)"
    [ -n "$resolved" ] || { echo "Command not installed in Kali: $command_name" >&2; exit 127; }
    exec "$resolved" "$@"
  ' bgx-command "$command_name" "$@"
}
require_args() { [ "$#" -gt 0 ] || { echo "Usage: $*" >&2; exit 2; }; }

case "${1:-login}" in
  login) shift || true; kali_exec /bin/bash -l "$@";;
  shell) shift || true; [ "$#" -gt 0 ] && kali_exec /bin/bash -lc "$*" || kali_exec /bin/bash -l;;
  update) kali_exec /bin/bash -lc 'apt-get update && apt-get -y upgrade';;
  install) shift || true; require_args 'nethunter install <package...>'; kali_exec /bin/bash -lc 'export DEBIAN_FRONTEND=noninteractive; apt-get update; apt-get install -y --no-install-recommends "$@"' bgx-install "$@";;
  nuclei) shift || true; kali_bin nuclei "$@";;
  nuclei-update) kali_bin nuclei -update-templates;;
  nmap|msfconsole|msfvenom|wireshark|tshark|hashcat|ssh|scp|ssh-keygen|sshd|sqlmap|hydra|john|shodan|sf.py|paramspider|subfinder|burpsuite|gvm-cli|zaproxy|nikto) command_name="$1"; shift || true; [ "$command_name" = sf.py ] && command_name=sf.py; kali_bin "$command_name" "$@";;
  spiderfoot) shift || true; kali_bin sf.py "$@";;
  gvm|openvas) shift || true; kali_bin gvm-cli "$@";;
  zap) shift || true; kali_bin zaproxy "$@";;
  status) exec proot-distro list --installed;;
  *) echo 'Usage: nethunter [login|shell|update|install <package...>|nuclei|nuclei-update|nmap|msfconsole|msfvenom|wireshark|tshark|hashcat|ssh|scp|ssh-keygen|sshd|sqlmap|hydra|john|shodan|spiderfoot|paramspider|subfinder|burpsuite|gvm|zaproxy|nikto|status]' >&2; exit 2;;
esac
EOF
chmod +x "$ROOT/tools/nethunter"
ln -sfn "$ROOT/tools/nethunter" "${PREFIX:-$HOME/.local}/bin/nethunter"
printf 'Kali NetHunter wrapper siap. Nuclei dipasang di dalam Kali.\n' > "$STATE/nethunter"
echo 'Kali NetHunter minimal + Nuclei siap.'
