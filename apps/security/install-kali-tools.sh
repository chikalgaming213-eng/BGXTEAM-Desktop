#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
ROOT="${BGX_ROOT:-$HOME/BGXTEAM}"
command -v proot-distro >/dev/null 2>&1 || { echo 'proot-distro belum tersedia. Jalankan: pkg install proot-distro' >&2; exit 1; }
proot-distro list --installed 2>/dev/null | awk '{print $1}' | grep -qx kali || { echo 'Kali belum terpasang. Jalankan install-nethunter.sh terlebih dahulu.' >&2; exit 1; }

proot-distro login kali --termux-home -- /bin/bash -lc '
  set -u
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  printf "%s\n" "wireshark-common wireshark-common/install-setuid boolean false" | debconf-set-selections 2>/dev/null || true
  packages=(nmap metasploit-framework wireshark tshark hashcat openssh-client openssh-server sqlmap hydra john shodan spiderfoot paramspider subfinder burpsuite gvm zaproxy nikto)
  installed=(); missing=()
  for package in "${packages[@]}"; do
    if apt-get install -y --no-install-recommends "$package" >/dev/null 2>&1; then installed+=("$package"); else missing+=("$package"); fi
  done
  printf "Installed: %s\n" "${installed[*]:-none}"
  printf "Unavailable in current Kali repositories: %s\n" "${missing[*]:-none}"
  for command_name in nuclei nmap msfconsole tshark hashcat ssh sqlmap hydra john shodan sf.py paramspider subfinder burpsuite gvm-cli zaproxy nikto; do
    resolved="$(command -v "$command_name" 2>/dev/null || true)"
    [ -n "$resolved" ] && printf "[OK] %s -> %s\n" "$command_name" "$resolved" || printf "[MISS] %s\n" "$command_name"
  done
' 

mkdir -p "$ROOT/state"
printf 'Kali tools checked at %s\ncomponents=nmap,metasploit,wireshark,tshark,hashcat,openssh,sqlmap,hydra,john,shodan,spiderfoot,paramspider,openvas-gvm,subfinder,burpsuite,owasp-zap,nikto\n' "$(date -u +%FT%TZ)" > "$ROOT/state/kali-tools"
echo 'Pemasangan tool Kali selesai; lihat status [OK]/[MISS] di output di atas.'
