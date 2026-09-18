# BGXTEAM Desktop — User Manual Tool Keamanan

**Versi:** 1.0  
**Lingkungan:** Termux + Termux:X11 + XFCE + Kali NetHunter Rootless  
**Bahasa:** Indonesia

## 1. Tujuan dan batas penggunaan

BGXTEAM menyediakan launcher dan wrapper untuk menjalankan tool keamanan dari dalam Kali NetHunter Rootless. Semua tool dijalankan di lingkungan Kali, bukan langsung dari Termux host, melalui launcher resmi `nethunter`.

Gunakan tool hanya pada perangkat, akun, domain, aplikasi, jaringan, dan data yang Anda miliki atau yang secara jelas Anda diizinkan untuk uji. Pemindaian, enumerasi, pengujian kredensial, pengujian injeksi, dan pengujian eksploitasi dapat menimbulkan gangguan layanan atau konsekuensi hukum jika dilakukan tanpa izin.

> **Prinsip kerja aman:** tetapkan ruang lingkup tertulis, gunakan target uji, batasi kecepatan request, simpan bukti secara aman, dan hentikan proses bila layanan target terganggu.

## 2. Struktur lingkungan

```text
Termux host
└── BGXTEAM
    ├── scripts/                 # desktop, healthcheck, menu, konfigurasi
    ├── apps/security/           # installer dan Security Center
    ├── tools/nethunter          # wrapper menuju Kali
    ├── projects/nuclei/         # workspace Nuclei
    ├── state/                   # status instalasi dan tema
    └── assets/bgxteam.png       # wallpaper desktop

Kali NetHunter Rootless melalui installer resmi Termux
├── Nuclei
├── Nmap
├── Metasploit Framework
├── Wireshark/TShark
├── Hashcat
├── OpenSSH
├── SQLMap
├── Hydra
├── John the Ripper
├── Shodan
├── SpiderFoot
├── ParamSpider
├── OpenVAS/GVM
├── Subfinder
├── Burp Suite
├── OWASP ZAP
└── Nikto
```

## 3. Instalasi awal

Jalankan perintah berikut di Termux dari direktori proyek hasil ekstraksi.

```bash
bash install.sh
```

Installer memasang dependency desktop dan `proot-distro`. Setelah itu, pasang Kali NetHunter Rootless dan Nuclei. Saat installer meminta pilihan image, pilih ARM64 minimal untuk perangkat ARM64 atau ARMhf minimal untuk perangkat 32-bit:

```bash
bash ~/BGXTEAM/apps/security/install-nethunter.sh
```

Installer NetHunter yang digunakan adalah `https://offs.ec/2MceZWr`. Setelah selesai, perintah resmi yang tersedia adalah `nethunter`, `nethunter -r`, dan `nethunter kex start`.

Terakhir, pasang tool keamanan lainnya:

```bash
bash ~/BGXTEAM/apps/security/install-kali-tools.sh --install
```

Installer tool memeriksa paket satu per satu. Output `[OK]` berarti command ditemukan di Kali. Output `[MISS]` berarti paket belum tersedia pada repository Kali yang sedang digunakan atau nama paket perlu dipasang manual.

Untuk memperbarui paket di kemudian hari:

```bash
nethunter -r apt-get update
bash ~/BGXTEAM/apps/security/install-kali-tools.sh --update
```

## 4. Perintah dasar BGXTEAM

| Perintah | Fungsi |
|---|---|
| `bgxstart` | Menyalakan Termux:X11 dan sesi XFCE. |
| `bgxstop` | Menghentikan sesi XFCE dan Termux:X11. |
| `bgxrestart` | Menghentikan lalu menyalakan ulang desktop. |
| `bgx` | Membuka launcher BGXTEAM. |
| `bgxhealth` | Memeriksa dependency desktop dan status runtime. |
| `bgxinfo` | Menampilkan informasi sistem, storage, memory, dan proses. |
| `bgxkeyboard` | Mengatur additional keyboard Termux:X11. |
| `bgxtheme` | Mengganti tema BGXTEAM. |
| `nethunter` | Masuk ke shell Kali sebagai user NetHunter. |
| `nethunter -r` | Masuk ke shell Kali sebagai root. |
| `nethunter kex start` | Menjalankan desktop KeX NetHunter. |
| `nethunter -r apt-get install <package>` | Memasang paket tambahan melalui APT di Kali. |

Contoh login:

```bash
nethunter
cat /etc/os-release
exit
```

## 5. Security Center

Security Center dapat dibuka dari launcher `bgx`, lalu pilih **Security Center**. Menu tersebut menyediakan installer, status, dan launcher setiap tool.

Jika ingin membukanya langsung:

```bash
bash ~/BGXTEAM/apps/security/center.sh
```

Menu yang menjalankan pemindaian meminta target secara eksplisit. Target tetap harus berada dalam ruang lingkup izin Anda.

## 6. Nuclei

Nuclei adalah scanner berbasis template untuk menemukan pola kerentanan dan konfigurasi pada target web atau jaringan.

Perintah dasar:

```bash
nethunter nuclei -version
nethunter nuclei-update
nethunter nuclei -u https://target-berizin.example
nethunter nuclei -l targets.txt
```

Gunakan template dan rate limit yang sesuai dengan ruang lingkup. Untuk menyimpan hasil JSONL:

```bash
nethunter nuclei -u https://target-berizin.example -jsonl -o hasil.jsonl
```

Nuclei dipasang di Kali pada `/usr/local/bin/nuclei`, sedangkan template berada di dalam filesystem Kali.

## 7. Nmap

Nmap digunakan untuk pemetaan host, port, service, dan versi pada target yang diizinkan.

```bash
nethunter nmap --version
nethunter nmap -sV -p 22,80,443 target-berizin.example
nethunter nmap -oN hasil-nmap.txt target-berizin.example
```

Mulai dari pemindaian terbatas. Hindari opsi agresif pada sistem produksi tanpa persetujuan tertulis.

## 8. Metasploit Framework

Metasploit menyediakan console untuk validasi kerentanan dan pengujian eksploitasi dalam lab atau ruang lingkup resmi.

```bash
nethunter msfconsole
nethunter msfvenom --help
```

Gunakan target lab seperti Metasploitable atau aplikasi uji milik sendiri. Jangan menjalankan module exploit terhadap target publik tanpa otorisasi.

## 9. Wireshark dan TShark

Wireshark adalah antarmuka grafis untuk analisis paket. TShark adalah versi command-line.

```bash
nethunter wireshark
nethunter tshark --version
nethunter tshark -r capture.pcap
nethunter tshark -r capture.pcap -Y 'http' -T fields -e ip.src -e ip.dst
```

Pada NetHunter Rootless, live capture dari interface Android dapat terbatas oleh permission dan kernel. Analisis file `.pcap` biasanya lebih dapat diandalkan daripada capture langsung.

## 10. Hashcat

Hashcat digunakan untuk audit kekuatan hash yang Anda miliki atau diberi izin untuk uji.

```bash
nethunter hashcat --version
nethunter hashcat --help
nethunter hashcat -m 0 -a 0 hashes.txt wordlist.txt
```

Pastikan format mode `-m`, attack mode `-a`, dan wordlist sesuai dengan data uji. Dukungan GPU Android dapat terbatas atau tidak tersedia di dalam NetHunter Rootless.

## 11. OpenSSH

OpenSSH menyediakan client, transfer file, pembuatan key, dan server SSH.

```bash
nethunter ssh -V
nethunter ssh-keygen -t ed25519
nethunter ssh user@host-berizin
nethunter scp hasil.txt user@host-berizin:/tmp/
nethunter sshd
```

Jangan membuka `sshd` ke jaringan publik tanpa autentikasi key, konfigurasi port, dan firewall yang tepat. Di Android, akses jaringan dan proses background dapat dibatasi sistem.

## 12. SQLMap

SQLMap membantu menguji indikasi SQL injection pada aplikasi yang berada dalam ruang lingkup izin.

```bash
nethunter sqlmap --version
nethunter sqlmap -u 'https://target-berizin.example/item?id=1' --batch
```

Mulai dengan request yang aman dan hindari opsi yang memodifikasi atau menghapus data. Gunakan salinan database dan aplikasi uji jika memungkinkan.

## 13. Hydra

Hydra menguji autentikasi layanan menggunakan daftar kredensial dalam audit yang disetujui.

```bash
nethunter hydra -h
```

Hydra dapat menghasilkan banyak percobaan login dan memicu lockout. Gunakan rate rendah, akun uji, dan window pengujian yang telah disepakati.

## 14. John the Ripper

John digunakan untuk audit kekuatan password dari hash yang Anda miliki.

```bash
nethunter john --help
nethunter john hashes.txt
nethunter john --show hashes.txt
```

Simpan file hash dan hasil audit dengan permission terbatas. Hapus salinan sementara setelah laporan selesai.

## 15. Shodan

Shodan adalah layanan pencarian informasi aset internet dan membutuhkan API key.

Konfigurasi di dalam Kali:

```bash
nethunter
shodan init API_KEY_ANDA
shodan info
exit
```

Contoh query yang bersifat inventarisasi:

```bash
nethunter shodan host IP_MILIK_ANDA
nethunter shodan search 'org:"Organisasi Anda"'
```

Gunakan query pada organisasi atau aset yang memang berada dalam ruang lingkup Anda. API key tidak boleh dimasukkan ke script publik atau commit Git.

## 16. SpiderFoot

SpiderFoot mengotomatiskan pengumpulan informasi OSINT dari berbagai sumber.

```bash
nethunter spiderfoot --help
nethunter spiderfoot -l 127.0.0.1:5001
```

Setelah server berjalan, buka alamat localhost tersebut melalui browser X11. Modul dan API yang aktif dapat menghasilkan request eksternal, sehingga ruang lingkup dan privasi perlu diperiksa sebelum scan dimulai.

## 17. ParamSpider

ParamSpider mencari parameter URL yang pernah ditemukan pada domain.

```bash
nethunter paramspider --help
nethunter paramspider -d target-berizin.example
```

Hasilnya harus diperlakukan sebagai daftar kandidat untuk validasi manual, bukan bukti kerentanan.

## 18. Subfinder

Subfinder mengumpulkan subdomain dari sumber pasif.

```bash
nethunter subfinder -version
nethunter subfinder -d target-berizin.example -silent
nethunter subfinder -d target-berizin.example -o subdomains.txt
```

Pastikan domain berada dalam ruang lingkup. Sumber API tambahan dapat memerlukan konfigurasi provider di dalam Kali.

## 19. OpenVAS/GVM

OpenVAS saat ini dikelola sebagai bagian dari Greenbone Vulnerability Management atau GVM. Instalasi paket tidak otomatis berarti feed, database, dan service scanner sudah selesai dikonfigurasi.

Periksa command:

```bash
nethunter gvm --version
nethunter
gvm-check-setup
exit
```

Pada perangkat Android, GVM membutuhkan storage, memory, feed database, dan beberapa service yang cukup berat. Jika setup gagal, baca pesan `gvm-check-setup` sebelum mencoba ulang. Jangan menjalankan scanner terhadap jaringan di luar izin.

## 20. Burp Suite

Burp Suite adalah proxy dan toolkit pengujian aplikasi web.

```bash
nethunter burpsuite
```

Aplikasi grafis memerlukan XFCE/Termux:X11 dan Java yang kompatibel. Untuk pengujian browser, konfigurasi proxy browser ke listener lokal Burp dan pasang CA certificate hanya pada browser atau device uji.

## 21. OWASP ZAP

OWASP ZAP adalah proxy dan scanner aplikasi web.

```bash
nethunter zaproxy
```

ZAP juga membutuhkan GUI/X11 untuk penggunaan penuh. Gunakan mode passive atau baseline pada awal pengujian. Hindari active scan pada aplikasi produksi tanpa persetujuan eksplisit.

## 22. Nikto

Nikto memeriksa konfigurasi dan file umum pada web server.

```bash
nethunter nikto -Version
nethunter nikto -h https://target-berizin.example
```

Nikto dapat menghasilkan banyak request dan temuan yang perlu diverifikasi. Gunakan hanya pada host yang disetujui.

## 23. Diagnostik dan troubleshooting

Periksa dependency desktop:

```bash
bgxhealth
```

Periksa informasi sistem:

```bash
bgxinfo
```

Periksa status distro:

```bash
nethunter cat /etc/os-release
```

Jika command tool berstatus `MISS`, masuk ke Kali lalu pasang paketnya:

```bash
nethunter
apt-get update
apt-get install <nama-paket>
exit
```

Jika GUI tidak muncul, pastikan Termux:X11 aktif dan jalankan:

```bash
BGX_LEGACY_DRAWING=true bgxstart
```

Jika desktop berhenti tidak bersih:

```bash
bgxstop
bgxstart
```

Log utama berada di:

```text
~/BGXTEAM/logs/bgx.log
~/BGXTEAM/logs/xfce.log
~/BGXTEAM/logs/x11.log
```

Jika installer terhenti karena repository, ulangi setelah memperbarui repository Kali:

```bash
nethunter -r apt-get update
bash ~/BGXTEAM/apps/security/install-kali-tools.sh --install
```

## 24. Praktik penyimpanan hasil

Simpan output scan di folder proyek terpisah dan jangan memasukkan API key, password, private key, dump database, atau file hash ke repository publik. Gunakan permission terbatas:

```bash
chmod 700 ~/BGXTEAM/projects
chmod 600 ~/BGXTEAM/projects/*.txt 2>/dev/null || true
```

Catat waktu pengujian, target, command, versi tool, scope, dan hasil. Laporan yang baik memisahkan temuan terverifikasi dari indikasi yang masih memerlukan validasi.

## 25. Referensi

[1]: https://termux.dev/en/ "Termux Official Website"
[2]: https://github.com/termux/proot-distro "proot-distro Official Repository"
[3]: https://www.kali.org/tools/ "Kali Linux Tools"
[4]: https://docs.projectdiscovery.io/tools/nuclei/overview "ProjectDiscovery Nuclei Documentation"
[5]: https://nmap.org/book/man.html "Nmap Reference Guide"
[6]: https://docs.metasploit.com/ "Metasploit Documentation"
[7]: https://www.wireshark.org/docs/ "Wireshark Documentation"
[8]: https://hashcat.net/wiki/ "Hashcat Wiki"
[9]: https://www.openssh.com/manual.html "OpenSSH Manual Pages"
[10]: https://sqlmap.org/ "SQLMap Official Website"
[11]: https://www.openwall.com/john/ "John the Ripper Official Website"
[12]: https://help.shodan.io/ "Shodan Help Center"
[13]: https://www.spiderfoot.net/documentation/ "SpiderFoot Documentation"
[14]: https://github.com/devanshbatham/ParamSpider "ParamSpider Official Repository"
[15]: https://greenbone.github.io/docs/ "Greenbone Community Documentation"
[16]: https://portswigger.net/burp/documentation "Burp Suite Documentation"
[17]: https://www.zaproxy.org/docs/ "OWASP ZAP Documentation"
[18]: https://cirt.net/Nikto2 "Nikto Official Information"
[19]: https://github.com/projectdiscovery/subfinder "Subfinder Official Repository"
