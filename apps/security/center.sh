#!/data/data/com.termux/files/usr/bin/bash
set -u
ROOT="${BGX_ROOT:-$HOME/BGXTEAM}"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
while true; do
  clear
  printf 'BGXTEAM SECURITY CENTER\n\n1) Install Kali NetHunter + Nuclei di dalam Kali\n2) Install Metasploit + Nmap + Wireshark + Hashcat + OpenSSH + SQLMap + Hydra + John + Shodan + SpiderFoot + ParamSpider + OpenVAS + Subfinder + Burp Suite + OWASP ZAP + Nikto\n3) Update Kali\n4) Security status\n5) Login NetHunter\n6) Jalankan Nuclei pada target berizin\n7) Nmap pada target berizin\n8) Metasploit Console\n9) TShark capture/read pcap\n10) Hashcat\n11) SQLMap pada target berizin\n12) OpenSSH shell\n13) Hydra help\n14) John help\n15) Shodan CLI\n16) SpiderFoot\n17) ParamSpider\n18) Subfinder\n19) Burp Suite\n20) OpenVAS/GVM status\n21) OWASP ZAP\n22) Nikto pada target berizin\n0) Exit\n\n'
  read -r -p 'Security > ' choice
  case "$choice" in
    1) "$SCRIPT_DIR/install-nethunter.sh"; read -r -p 'Enter...' _;;
    2) "$SCRIPT_DIR/install-kali-tools.sh" --install; read -r -p 'Enter...' _;;
    3) "$ROOT/tools/nethunter" -r apt-get update; read -r -p 'Enter...' _;;
    4) printf 'NetHunter Rootless: '; command -v nethunter >/dev/null 2>&1 && echo OK || echo MISSING; "$ROOT/tools/nethunter" nuclei -version 2>&1 || true; "$ROOT/tools/nethunter" nmap --version 2>&1 | head -n 1 || true; "$ROOT/tools/nethunter" msfconsole --version 2>&1 || true; "$ROOT/tools/nethunter" tshark --version 2>&1 | head -n 1 || true; "$ROOT/tools/nethunter" hashcat --version 2>&1 || true; "$ROOT/tools/nethunter" ssh -V 2>&1 || true; "$ROOT/tools/nethunter" sqlmap --version 2>&1 || true; "$ROOT/tools/nethunter" hydra -h 2>&1 | head -n 1 || true; "$ROOT/tools/nethunter" john --version 2>&1 | head -n 1 || true; "$ROOT/tools/nethunter" shodan version 2>&1 || true; "$ROOT/tools/nethunter" spiderfoot --help 2>&1 | head -n 1 || true; "$ROOT/tools/nethunter" subfinder -version 2>&1 || true; "$ROOT/tools/nethunter" gvm --version 2>&1 | head -n 1 || true; "$ROOT/tools/nethunter" zaproxy --version 2>&1 | head -n 1 || true; "$ROOT/tools/nethunter" nikto -Version 2>&1 | head -n 1 || true; read -r -p 'Enter...' _;;
    5) "$ROOT/tools/nethunter";;
    6) echo 'Hanya gunakan pada target yang Anda miliki atau berizin.'; read -r -p 'URL atau file target: ' target; if [ -n "$target" ]; then if [[ "$target" == http://* || "$target" == https://* ]]; then "$ROOT/tools/nethunter" nuclei -u "$target"; elif [ -f "$target" ]; then "$ROOT/tools/nethunter" nuclei -l "$target"; else echo 'Target file tidak ditemukan.'; fi; fi; read -r -p 'Enter...' _;;
    7) echo 'Hanya gunakan pada target yang Anda miliki atau berizin.'; read -r -p 'Target Nmap: ' target; [ -n "$target" ] && "$ROOT/tools/nethunter" nmap "$target"; read -r -p 'Enter...' _;;
    8) "$ROOT/tools/nethunter" msfconsole;;
    9) echo 'Capture interface/permissions depend on Android and proot-distro. Read a pcap with: nethunter tshark -r file.pcap'; read -r -p 'PCAP file (blank opens live args): ' pcap; if [ -n "$pcap" ]; then "$ROOT/tools/nethunter" tshark -r "$pcap"; else "$ROOT/tools/nethunter" tshark; fi; read -r -p 'Enter...' _;;
    10) echo 'Gunakan Hashcat hanya pada hash yang Anda miliki atau berizin.'; "$ROOT/tools/nethunter" hashcat --help | head -n 30; read -r -p 'Enter...' _;;
    11) echo 'Gunakan SQLMap hanya pada aplikasi yang Anda miliki atau berizin.'; read -r -p 'Target URL: ' target; [ -n "$target" ] && "$ROOT/tools/nethunter" sqlmap -u "$target" --batch; read -r -p 'Enter...' _;;
    12) echo 'SSH client berjalan di dalam Kali. Gunakan hanya ke host yang Anda punya akses.'; "$ROOT/tools/nethunter" ssh; read -r -p 'Enter...' _;;
    13) echo 'Hydra hanya untuk layanan yang Anda miliki atau berizin.'; "$ROOT/tools/nethunter" hydra -h | head -n 35; read -r -p 'Enter...' _;;
    14) echo 'John hanya untuk hash yang Anda miliki atau berizin.'; "$ROOT/tools/nethunter" john --help 2>&1 | head -n 35; read -r -p 'Enter...' _;;
    15) echo 'Shodan memerlukan API key dan hanya untuk reconnaissance yang berizin.'; "$ROOT/tools/nethunter" shodan info; read -r -p 'Enter...' _;;
    16) echo 'SpiderFoot hanya untuk aset yang Anda miliki atau berizin.'; "$ROOT/tools/nethunter" spiderfoot --help 2>&1 | head -n 35; read -r -p 'Enter...' _;;
    17) echo 'ParamSpider hanya untuk domain yang Anda miliki atau berizin.'; read -r -p 'Domain: ' domain; [ -n "$domain" ] && "$ROOT/tools/nethunter" paramspider -d "$domain"; read -r -p 'Enter...' _;;
    18) echo 'Subfinder hanya untuk domain yang Anda miliki atau berizin.'; read -r -p 'Domain: ' domain; [ -n "$domain" ] && "$ROOT/tools/nethunter" subfinder -d "$domain"; read -r -p 'Enter...' _;;
    19) "$ROOT/tools/nethunter" burpsuite;;
    20) echo 'OpenVAS/GVM command status:'; "$ROOT/tools/nethunter" gvm --version 2>&1 | head -n 10; read -r -p 'Enter...' _;;
    21) "$ROOT/tools/nethunter" zaproxy;;
    22) echo 'Nikto hanya untuk target yang Anda miliki atau berizin.'; read -r -p 'Target URL/host: ' target; [ -n "$target" ] && "$ROOT/tools/nethunter" nikto -h "$target"; read -r -p 'Enter...' _;;
    0) exit 0;;
    *) echo 'Pilihan tidak valid'; sleep 1;;
  esac
done
