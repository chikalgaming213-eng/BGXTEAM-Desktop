#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
ROOT="${BGX_ROOT:-$HOME/BGXTEAM}"
command -v nethunter >/dev/null 2>&1 || { echo 'NetHunter belum terpasang. Jalankan install-nethunter.sh terlebih dahulu.' >&2; exit 1; }

nethunter -r '
  set -u
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  printf "%s\n" "wireshark-common wireshark-common/install-setuid boolean false" | debconf-set-selections 2>/dev/null || true

  apt_packages=(ca-certificates curl git golang-go python3 python3-pip python3-venv default-jre nmap metasploit-framework wireshark tshark hashcat openssh-client openssh-server sqlmap hydra john burpsuite gvm zaproxy nikto)
  installed=(); missing=()
  for package in "${apt_packages[@]}"; do
    if apt-get install -y --no-install-recommends "$package" >/dev/null 2>&1; then installed+=("$package"); else missing+=("$package"); fi
  done

  # Tools distributed through Python are isolated in a venv to avoid breaking Kali system packages.
  python3 -m venv /opt/bgx-python-tools 2>/dev/null || true
  if [ -x /opt/bgx-python-tools/bin/pip ]; then
    /opt/bgx-python-tools/bin/pip install --upgrade pip >/dev/null 2>&1 || true
    /opt/bgx-python-tools/bin/pip install shodan spiderfoot >/dev/null 2>&1 || true
    ln -sfn /opt/bgx-python-tools/bin/shodan /usr/local/bin/shodan
    ln -sfn /opt/bgx-python-tools/bin/sf.py /usr/local/bin/sf.py
  fi

  # Subfinder is installed from its upstream Go module when the Kali package is unavailable.
  if ! command -v subfinder >/dev/null 2>&1 && command -v go >/dev/null 2>&1; then
    GOBIN=/usr/local/bin go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest >/dev/null 2>&1 || true
  fi

  # ParamSpider is installed into a dedicated directory when Git and Python are available.
  if ! command -v paramspider >/dev/null 2>&1 && command -v git >/dev/null 2>&1; then
    rm -rf /opt/ParamSpider
    git clone --depth 1 https://github.com/devanshbatham/ParamSpider.git /opt/ParamSpider >/dev/null 2>&1 || true
    if [ -f /opt/ParamSpider/requirements.txt ]; then /opt/bgx-python-tools/bin/pip install -r /opt/ParamSpider/requirements.txt >/dev/null 2>&1 || true; fi
    [ -f /opt/ParamSpider/paramspider.py ] && ln -sfn /opt/ParamSpider/paramspider.py /usr/local/bin/paramspider
  fi

  printf "APT installed: %s\n" "${installed[*]:-none}"
  printf "APT unavailable: %s\n" "${missing[*]:-none}"
  for command_name in nuclei nmap msfconsole tshark hashcat ssh sqlmap hydra john shodan sf.py paramspider subfinder burpsuite gvm-cli zaproxy nikto; do
    resolved="$(command -v "$command_name" 2>/dev/null || true)"
    [ -n "$resolved" ] && printf "[OK] %s -> %s\n" "$command_name" "$resolved" || printf "[MISS] %s\n" "$command_name"
  done
'

mkdir -p "$ROOT/state"
printf 'NetHunter tools checked at %s\ncomponents=nmap,metasploit,wireshark,tshark,hashcat,openssh,sqlmap,hydra,john,shodan,spiderfoot,paramspider,openvas-gvm,subfinder,burpsuite,owasp-zap,nikto\n' "$(date -u +%FT%TZ)" > "$ROOT/state/kali-tools"
echo 'Pemeriksaan tool NetHunter selesai; lihat status [OK]/[MISS] di output.'
