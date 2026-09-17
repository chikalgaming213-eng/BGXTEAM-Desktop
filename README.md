# BGXTEAM Desktop

Lingkungan desktop XFCE untuk Termux + Termux:X11 dengan Kali NetHunter Rootless. Proyek ini menyediakan launcher desktop, wallpaper BGXTEAM, wrapper `nethunter`, Security Center, dan instalasi tool keamanan di dalam Kali.

## Clone repository

Repository ini bersifat public dan dapat di-clone langsung dari Termux:

```bash
pkg update -y
pkg install -y git
cd "$HOME"
git clone https://github.com/chikalgaming213-eng/BGXTEAM-Desktop.git
cd BGXTEAM-Desktop
```

Jika GitHub meminta autentikasi, gunakan GitHub CLI atau Personal Access Token. Jangan menaruh token di URL clone, file konfigurasi proyek, atau commit.

## Instalasi: urutan wajib

> **Penting:** Kali NetHunter dipasang **setelah** `install.sh`, bukan sebelumnya. Jalankan empat tahap berikut secara berurutan dari Termux.

### Tahap 1 — Pasang BGXTEAM dan dependency Termux

```bash
cd "$HOME/BGXTEAM-Desktop"
bash install.sh
```

Tahap ini memasang Termux:X11, XFCE, DBus, `proot-distro`, Python, Node.js, OpenSSH, dan utilitas dasar. Tahap ini **belum memasang Kali NetHunter**.

### Tahap 2 — Pasang Kali NetHunter minimal

```bash
bash "$HOME/BGXTEAM/apps/security/install-nethunter.sh"
```

Tahap ini memasang Kali NetHunter Rootless menggunakan installer resmi yang Anda berikan. Saat installer menampilkan pilihan image, pilih **ARM64 minimal** untuk perangkat ARM64 atau **ARMhf minimal** untuk perangkat 32-bit. Nuclei kemudian dipasang langsung di filesystem NetHunter. Tahap ini biasanya hanya perlu dijalankan sekali.

Installer resmi yang digunakan:

```text
https://offs.ec/2MceZWr
```

Periksa hasil instalasi Kali:

```bash
nethunter
cat /etc/os-release
exit
```

Untuk shell root NetHunter gunakan:

```bash
nethunter -r
cat /etc/os-release
exit
```

### Tahap 3 — Pasang tool keamanan tambahan di dalam Kali

```bash
bash "$HOME/BGXTEAM/apps/security/install-kali-tools.sh"
```

Tahap ini memasang Nmap, Metasploit, Wireshark/TShark, Hashcat, OpenSSH, SQLMap, Hydra, John, Shodan, SpiderFoot, ParamSpider, OpenVAS/GVM, Subfinder, Burp Suite, OWASP ZAP, dan Nikto **di dalam Kali**, bukan di Termux host.

### Tahap 4 — Jalankan desktop BGXTEAM

```bash
bgxstart
bgx
```

Jika suatu paket tidak tersedia pada repository Kali, installer menampilkan status `[MISS]` tanpa menghentikan pemeriksaan paket lainnya.

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
