#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
ROOT="${BGX_ROOT:-$HOME/BGXTEAM}"

command -v nethunter >/dev/null 2>&1 || { echo '[FAIL] NetHunter belum terpasang. Jalankan install-nethunter.sh terlebih dahulu.' >&2; exit 1; }

MODE="${1:-menu}"
case "$MODE" in
  --help|-h)
    cat <<'EOF'
Usage: install-kali-tools.sh [--check|--install|--update|--help]

  --check    Cek arsitektur, dependency, lokasi binary, dan versi tanpa install.
  --install  Install hanya tool/dependency yang belum tersedia lalu verifikasi.
  --update   Update Go/GitHub tools dengan metode upstream resmi lalu verifikasi.
  --help     Tampilkan bantuan.
Tanpa argument, tampilkan menu interaktif.
EOF
    exit 0
    ;;
  --check|--install|--update) ;;
  menu)
    printf '%s\n' '1) Check tools' '2) Install missing tools' '3) Update GitHub/Go tools' '4) Exit'
    read -r -p 'Pilih [1-4]: ' choice
    case "$choice" in
      1) MODE=--check;; 2) MODE=--install;; 3) MODE=--update;; *) exit 0;;
    esac
    ;;
  *) echo "Mode tidak dikenal: $MODE. Gunakan --help." >&2; exit 2;;
esac

REMOTE_SCRIPT=''
read -r -d '' REMOTE_SCRIPT <<'KALI_SCRIPT' || true
set +e
MODE="${BGX_MODE:---check}"
export DEBIAN_FRONTEND=noninteractive
export GOPATH="${GOPATH:-$HOME/go}"
export PATH="$GOPATH/bin:$HOME/.local/bin:$PATH"
mkdir -p "$GOPATH/bin" "$HOME/.local/bin" "$HOME/.config/bgxteam"

# Tambahkan PATH sekali saja ke bashrc milik Kali.
PATH_LINE='export GOPATH="${GOPATH:-$HOME/go}"; export PATH="$GOPATH/bin:$HOME/.local/bin:$PATH"'
if ! grep -Fqx "$PATH_LINE" "$HOME/.bashrc" 2>/dev/null; then printf '\n%s\n' "$PATH_LINE" >> "$HOME/.bashrc"; fi

printf '%s\n' '[+] Checking environment'
printf 'Architecture: '; uname -m
arch="$(uname -m)"
if [ "$arch" != aarch64 ] && [ "$arch" != arm64 ] && [ "$arch" != armv7l ] && [ "$arch" != armhf ]; then
  printf '[SKIP] Unsupported/untested architecture: %s\n' "$arch"
fi

TOOLS=(nuclei subfinder sqlmap hydra john shodan sf.py paramspider nikto nmap msfconsole tshark hashcat ssh burpsuite gvm-cli zaproxy)
declare -A STATUS LOCATION SOURCE
for tool in "${TOOLS[@]}"; do
  location="$(command -v "$tool" 2>/dev/null || true)"
  if [ -n "$location" ]; then STATUS["$tool"]='OK'; LOCATION["$tool"]="$location"; else STATUS["$tool"]='MISS'; LOCATION["$tool"]=''; fi
done

printf '%s\n' '[+] Checking dependencies'
DEPS=(git curl wget python3 pip python3-venv go ca-certificates)
for dep in "${DEPS[@]}"; do
  check="$dep"; [ "$dep" = pip ] && check=pip3; [ "$dep" = python3-venv ] && check=python3
  if command -v "$check" >/dev/null 2>&1; then printf '[OK] dependency %s -> %s\n' "$dep" "$(command -v "$check")"; else printf '[MISS] dependency %s\n' "$dep"; fi
done

apt_install_for_missing() {
  [ "$MODE" = --check ] || [ "$MODE" = --update ] && return 0
  printf '%s\n' '[+] Installing missing APT dependencies and Kali tools'
  apt-get update
  apt_packages=(ca-certificates curl git golang-go python3 python3-pip python3-venv default-jre)
  declare -A PACKAGE_FOR
  PACKAGE_FOR[nmap]=nmap; PACKAGE_FOR[msfconsole]=metasploit-framework; PACKAGE_FOR[tshark]=tshark; PACKAGE_FOR[hashcat]=hashcat
  PACKAGE_FOR[ssh]=openssh-client; PACKAGE_FOR[sqlmap]=sqlmap; PACKAGE_FOR[hydra]=hydra; PACKAGE_FOR[john]=john
  PACKAGE_FOR[burpsuite]=burpsuite; PACKAGE_FOR[gvm-cli]=gvm-tools; PACKAGE_FOR[zaproxy]=zaproxy; PACKAGE_FOR[nikto]=nikto
  for tool in "${!PACKAGE_FOR[@]}"; do
    [ "${STATUS[$tool]}" = OK ] && continue
    apt_packages+=("${PACKAGE_FOR[$tool]}")
  done
  local package
  for package in "${apt_packages[@]}"; do
    apt-get install -y --no-install-recommends "$package" >/dev/null 2>&1 && printf '[OK] apt %s\n' "$package" || printf '[MISS] apt %s\n' "$package"
  done
}

install_go_tool() {
  [ "$MODE" = --check ] && return 0
  local name="$1" module="$2"
  [ "$MODE" = --install ] && [ "${STATUS[$name]}" = OK ] && return 0
  printf '[+] Go install %s from %s\n' "$name" "$module"
  if command -v go >/dev/null 2>&1 && GOBIN="$GOPATH/bin" go install "$module" >/dev/null 2>&1; then SOURCE["$name"]="$module"; else STATUS["$name"]='FAIL'; printf '[FAIL] %s -> go install failed\n' "$name"; fi
}

install_python_tools() {
  [ "$MODE" = --check ] && return 0
  local venv="$HOME/.local/share/bgxteam-security-venv"
  python3 -m venv "$venv" >/dev/null 2>&1 || { printf '[FAIL] Python virtual environment\n'; return; }
  "$venv/bin/pip" install --upgrade pip >/dev/null 2>&1 || true
  if [ "$MODE" = --update ] || [ "${STATUS[shodan]}" != OK ]; then
    "$venv/bin/pip" install --upgrade shodan >/dev/null 2>&1 && SOURCE[shodan]='https://pypi.org/project/shodan/' || STATUS[shodan]='FAIL'
  fi
  ln -sfn "$venv/bin/shodan" "$HOME/.local/bin/shodan"
  if [ -n "${SF_PY_SOURCE:-}" ]; then
    "$venv/bin/pip" install --upgrade "$SF_PY_SOURCE" >/dev/null 2>&1 && ln -sfn "$venv/bin/sf.py" "$HOME/.local/bin/sf.py" && SOURCE[sf.py]="$SF_PY_SOURCE" || STATUS[sf.py]='FAIL'
  else
    STATUS[sf.py]='SKIP'
    printf '[SKIP] sf.py - source belum dikonfigurasi\n'
  fi
}

install_paramspider() {
  [ "$MODE" = --check ] && return 0
  local dir="$HOME/.local/share/ParamSpider" venv="$HOME/.local/share/bgxteam-security-venv"
  if [ "$MODE" = --update ] || [ "${STATUS[paramspider]}" != OK ]; then
    if [ -d "$dir/.git" ]; then git -C "$dir" pull --ff-only >/dev/null 2>&1; else git clone --depth 1 https://github.com/devanshbatham/ParamSpider.git "$dir" >/dev/null 2>&1; fi
    "$venv/bin/pip" install -r "$dir/requirements.txt" >/dev/null 2>&1 || true
    if [ -f "$dir/paramspider.py" ]; then chmod +x "$dir/paramspider.py"; ln -sfn "$dir/paramspider.py" "$HOME/.local/bin/paramspider"; SOURCE[paramspider]='https://github.com/devanshbatham/ParamSpider'; else STATUS[paramspider]='FAIL'; fi
  fi
}

printf '%s\n' '[+] Detecting installed tools'
for tool in "${TOOLS[@]}"; do printf '[%s] %s%s\n' "${STATUS[$tool]}" "$tool" "${LOCATION[$tool]:+ -> ${LOCATION[$tool]}}"; done
if [ "$MODE" != --check ]; then
  printf '%s\n' '[+] Installing missing tools'
  apt_install_for_missing
  install_go_tool nuclei github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
  install_go_tool subfinder github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
  install_python_tools
  install_paramspider
fi

printf '%s\n' '[+] Verifying installations'
for tool in "${TOOLS[@]}"; do
  location="$(command -v "$tool" 2>/dev/null || true)"
  if [ -n "$location" ]; then STATUS["$tool"]='OK'; LOCATION["$tool"]="$location"; else [ "${STATUS[$tool]}" != SKIP ] && STATUS["$tool"]='MISS'; fi
done
printf '%s\n' '================ SECURITY TOOL REPORT ================'
for tool in "${TOOLS[@]}"; do
  if [ -n "${LOCATION[$tool]:-}" ]; then printf '[%s] %s -> %s\n' "${STATUS[$tool]}" "$tool" "${LOCATION[$tool]}"; else printf '[%s] %s\n' "${STATUS[$tool]}" "$tool"; fi
  [ -n "${SOURCE[$tool]:-}" ] && printf '      source: %s\n' "${SOURCE[$tool]}"
done
printf '%s\n' '[+] Installation completed'
KALI_SCRIPT

nethunter -r "BGX_MODE='$MODE'; $REMOTE_SCRIPT"
mkdir -p "$ROOT/state"
printf 'NetHunter tools checked at %s\nmode=%s\n' "$(date -u +%FT%TZ)" "$MODE" > "$ROOT/state/kali-tools"
