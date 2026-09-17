# BGXTEAM Desktop

Lingkungan desktop XFCE untuk Termux + Termux:X11 dengan Kali NetHunter minimal melalui `proot-distro`. Proyek ini menyediakan launcher desktop, wallpaper BGXTEAM, wrapper `nethunter`, Security Center, dan instalasi tool keamanan di dalam Kali.

## Clone repository

Repository ini bersifat private. Pastikan akun GitHub Anda memiliki akses, lalu jalankan di Termux:

```bash
pkg update -y
pkg install -y git
cd "$HOME"
git clone https://github.com/chikalgaming213-eng/BGXTEAM-Desktop.git
cd BGXTEAM-Desktop
```

Jika GitHub meminta autentikasi, gunakan GitHub CLI atau Personal Access Token. Jangan menaruh token di URL clone, file konfigurasi proyek, atau commit.

## Instalasi

Jalankan dari Termux:

```bash
bash install.sh
```

Installer memasang dependency Termux, termasuk Termux:X11, XFCE, DBus, `proot-distro`, Python, Node.js, OpenSSH, dan utilitas dasar. Setelah selesai, siapkan Kali NetHunter:

```bash
bash "$HOME/BGXTEAM/apps/security/install-nethunter.sh"
bash "$HOME/BGXTEAM/apps/security/install-kali-tools.sh"
```

Tool keamanan dipasang di filesystem Kali, bukan di Termux host. Jika suatu paket tidak tersedia pada repository Kali yang sedang digunakan, installer menampilkan status `[MISS]` tanpa menghentikan pemeriksaan paket lainnya.

## Menjalankan desktop

```bash
bgxstart
```

Jika layar hitam:

```bash
BGX_LEGACY_DRAWING=true bgxstart
```

Perintah utama:

```bash
bgx          # launcher
bgxhealth    # pemeriksaan dependency dan runtime
bgxinfo      # informasi sistem
bgxrestart   # restart desktop
bgxstop      # berhenti
bgxtheme     # pilih tema
```

## Menggunakan Kali

```bash
nethunter login
nethunter status
nethunter shell 'cat /etc/os-release'
nethunter update
nethunter install <nama-paket>
```

Contoh wrapper tool:

```bash
nethunter nuclei -version
nethunter nmap --version
nethunter subfinder -version
nethunter nikto -Version
nethunter sqlmap --version
```

Daftar lengkap command dan panduan penggunaan tersedia di [`docs/USER-MANUAL-ID.md`](docs/USER-MANUAL-ID.md).

## Keamanan dan izin

Gunakan seluruh tool hanya terhadap aset yang Anda miliki atau yang secara tertulis Anda diizinkan untuk uji. Mulai dengan target lab, batasi scope, rate, dan waktu pengujian. Jangan commit API key Shodan, password, private key, file hash, hasil scan sensitif, atau data pelanggan.

## Update dari repository

```bash
cd "$HOME/BGXTEAM-Desktop"
git pull --ff-only
bash install.sh
bash apps/security/install-nethunter.sh
bash apps/security/install-kali-tools.sh
```

## Troubleshooting

```bash
bgxhealth
nethunter status
```

Log utama berada di:

```text
$HOME/BGXTEAM/logs/bgx.log
$HOME/BGXTEAM/logs/xfce.log
$HOME/BGXTEAM/logs/x11.log
```

Jika repository Kali bermasalah, jalankan `nethunter update` lalu ulangi installer tool. Detail batasan GUI, GPU, packet capture, OpenVAS/GVM, Burp Suite, dan OWASP ZAP dibahas di user manual.
