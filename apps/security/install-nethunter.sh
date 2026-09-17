#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
ROOT="${BGX_ROOT:-$HOME/BGXTEAM}"
STATE="$ROOT/state"
mkdir -p "$STATE" "$ROOT/logs" "$ROOT/projects/nuclei" "$ROOT/tools"

command -v pkg >/dev/null 2>&1 || { echo 'Script ini harus dijalankan di Termux.' >&2; exit 1; }
pkg update -y
pkg upgrade -y
pkg install wget curl proot-distro -y

INSTALLER_URL="https://offs.ec/2MceZWr"
INSTALLER="$ROOT/cache/install-nethunter-termux"
mkdir -p "$ROOT/cache"
echo 'Mengunduh installer Kali NetHunter Termux...'
wget -O "$INSTALLER" "$INSTALLER_URL"
chmod +x "$INSTALLER"
echo 'Menjalankan installer NetHunter. Pilih opsi minimal saat diminta (ARM64 minimal untuk perangkat ARM64).'
"$INSTALLER"

command -v nethunter >/dev/null 2>&1 || { echo 'Installer selesai tetapi command nethunter belum ditemukan.' >&2; exit 1; }

# Wrapper BGXTEAM hanya meneruskan ke launcher resmi NetHunter dan tidak menimpa $PREFIX/bin/nethunter.
cat > "$ROOT/tools/nethunter" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
command -v nethunter >/dev/null 2>&1 || { echo 'Command nethunter belum tersedia. Jalankan install-nethunter.sh.' >&2; exit 1; }
exec nethunter "$@"
EOF
chmod +x "$ROOT/tools/nethunter"

# Pasang Nuclei di filesystem NetHunter menggunakan launcher resmi.
echo 'Memasang Nuclei di dalam Kali NetHunter...'
nethunter -r bash -lc '
  set -e
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y --no-install-recommends ca-certificates curl git golang-go
  GOBIN=/usr/local/bin go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
  mkdir -p /root/nuclei-templates /root/.config/nuclei
  /usr/local/bin/nuclei -update-templates || true
  /usr/local/bin/nuclei -version
'

printf 'NetHunter Rootless siap. Gunakan nethunter atau nethunter kex start.\n' > "$STATE/nethunter"
echo 'BGXTEAM: NetHunter Rootless berhasil disiapkan.'
