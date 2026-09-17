#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

SOURCE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
ROOT="${BGX_ROOT:-$HOME/BGXTEAM}"
BIN="${PREFIX:-$HOME/.local}/bin"
mkdir -p "$BIN" "$ROOT"

if command -v pkg >/dev/null 2>&1; then
  pkg update -y
  pkg install x11-repo -y || true
  pkg install termux-x11-nightly xfce dbus proot-distro git curl wget nano vim python nodejs openssh htop unzip zip tar file procps iproute -y
fi

mkdir -p "$ROOT"/{assets,config,core,desktop,apps,input,logs,cache,backups,projects,tools,themes,state}
if [ "$SOURCE_DIR" != "$ROOT" ]; then
  cp -a "$SOURCE_DIR"/. "$ROOT"/
fi
find "$ROOT" -type f -name '*.sh' -exec chmod +x {} +

for cmd in bgxstart bgxstop bgxrestart bgx bgxinfo bgxhealth bgxkeyboard bgxtheme; do
  case "$cmd" in
    bgxstart) src="$ROOT/scripts/start.sh";; bgxstop) src="$ROOT/scripts/stop.sh";;
    bgxrestart) src="$ROOT/scripts/restart.sh";; bgx) src="$ROOT/scripts/menu.sh";;
    bgxinfo) src="$ROOT/scripts/info.sh";; bgxhealth) src="$ROOT/scripts/healthcheck.sh";;
    bgxkeyboard) src="$ROOT/scripts/keyboard.sh";; bgxtheme) src="$ROOT/scripts/theme.sh";;
  esac
  ln -sfn "$src" "$BIN/$cmd"
done

mkdir -p "$HOME/.termux"
cat > "$HOME/.termux/termux.properties" <<'EOF'
extra-keys = [['ESC','TAB','CTRL','ALT','SHIFT','HOME','END'],['CTRL','C','CTRL','V','CTRL','Z','UP','DOWN','LEFT','RIGHT']]
EOF
command -v termux-reload-settings >/dev/null 2>&1 && termux-reload-settings || true
printf 'BGXTEAM installed at %s\nCommands available in %s: bgxstart bgx bgxinfo bgxhealth bgxtheme\n' "$ROOT" "$BIN"
