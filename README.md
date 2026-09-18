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
bash "$HOME/BGXTEAM/apps/security/install-kali-tools.sh" --install
```

Tahap ini memasang Nmap, Metasploit, Wireshark/TShark, Hashcat, OpenSSH, SQLMap, Hydra, John, Shodan, SpiderFoot, ParamSpider, OpenVAS/GVM, Subfinder, Burp Suite, OWASP ZAP, dan Nikto **di dalam Kali**, bukan di Termux host.

### Tahap 4 — Masuk ke desktop BGXTEAM

Desktop BGXTEAM menggunakan **Termux:X11 + XFCE**. Pastikan aplikasi Termux:X11 sudah terpasang di Android.

1. Buka aplikasi **Termux:X11** dari menu aplikasi Android. Biarkan aplikasi tersebut terbuka.
2. Kembali ke Termux.
3. Jalankan desktop:

```bash
cd "$HOME/BGXTEAM-Desktop"
bgxstart
```

4. Setelah sesi XFCE aktif, tampilan desktop BGXTEAM akan muncul di aplikasi Termux:X11.
5. Buka launcher BGXTEAM dari terminal lain atau dari terminal yang sama setelah command selesai:

```bash
bgx
```

Jika command `bgxstart` belum ditemukan, gunakan path script langsung:

```bash
bash "$HOME/BGXTEAM/scripts/start.sh"
```

Untuk keluar dari desktop:

```bash
bgxstop
```

NetHunter KeX adalah opsi terpisah dari desktop BGXTEAM. Jika ingin memakai desktop bawaan NetHunter, jalankan:

```bash
nethunter kex passwd
nethunter kex start
```

Hentikan KeX dengan:

```bash
nethunter kex stop
```

Jika suatu paket tidak tersedia pada repository Kali, installer menampilkan status `[MISS]` tanpa menghentikan pemeriksaan paket lainnya.

## Troubleshooting desktop

Jika desktop tidak muncul atau layar hitam:

```bash
BGX_LEGACY_DRAWING=true bgxstart
```

Jika masih gagal, jalankan pemeriksaan:

```bash
bgxhealth
bgxinfo
```

Pastikan dependency desktop sudah terpasang dengan mengulangi:

```bash
cd "$HOME/BGXTEAM-Desktop"
bash install.sh
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
nethunter
nethunter -r
nethunter cat /etc/os-release
nethunter -r apt-get update
nethunter -r apt-get install <nama-paket>
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
bash apps/security/install-kali-tools.sh --update
```

## Troubleshooting

```bash
bgxhealth
nethunter
```

Log utama berada di:

```text
$HOME/BGXTEAM/logs/bgx.log
$HOME/BGXTEAM/logs/xfce.log
$HOME/BGXTEAM/logs/x11.log
```

Jika repository Kali bermasalah, jalankan `nethunter -r apt-get update` lalu ulangi installer tool dengan mode `--install`. Detail batasan GUI, GPU, packet capture, OpenVAS/GVM, Burp Suite, dan OWASP ZAP dibahas di user manual.
