#!/bin/bash

# ============================================================
# Project  : KAWAII DEAUTHER PRO V.2026 (SIMULATION MODE)
# Author   : Rolandino (Coded By Rolandino!)
# Status   : DEMO / NON-ROOT SAFE
# ============================================================

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
    echo -e "${WH}  [ SIMULATION MODE - NO ROOT REQUIRED ]${NT}"
    echo -e "${CY}=============================================${NT}"
}

echo -e "${YW}[*] Inisialisasi Mode Simulasi...${NT}"
sleep 1
banner

# Simulasi Interface
echo -e "\n${CY}${BD}Pilih Interface WiFi (SIMULASI):${NT}"
echo -e " [${YW}0${NT}] wlan0 (Internal)"
echo -e " [${YW}1${NT}] wlan1mon (External Adapter)"
read -p "Masukkan Nomor Interface: " iface_idx
selected_iface="wlan0mon"

while true; do
    banner
    echo -e "${WH}Interface: ${GR}$selected_iface ${NT}| ${WH}Mode: ${YW}Monitor (SIM)${NT}"
    echo -e "\n${CY}--- MENU PENGUJIAN (SIMULASI) ---${NT}"
    echo -e " [${YW}1${NT}] Scan & Deauth Target"
    echo -e " [${YW}2${NT}] Spam Fake AP (Beacon Flood)"
    echo -e " [${YW}3${NT}] Chaos Mode"
    echo -e " [${YW}4${NT}] Exit Simulation"
    echo -e "${CY}----------------------${NT}"
    read -p "Pilih Opsi >> " opt

    case $opt in
        1)
            echo -e "${YW}[*] Scanning WiFi...${NT}"
            sleep 2
            echo -e "${WH}SSID              BSSID              CHAN   BARS"
            echo -e "${GR}WiFi_Tetangga     AA:BB:CC:11:22:33  6      ▂▄▆█"
            echo -e "${GR}IndiHome_Pro      BB:CC:DD:44:55:66  11     ▂▄▆ "
            echo -e "${GR}Rolandino_WiFi    CC:DD:EE:77:88:99  1      ▂▄▆█${NT}"
            echo -ne "\n${RD}Masukkan SSID Target: ${NT}"; read target_ssid
            echo -e "${YW}[+] Mengacak MAC Address...${NT}"
            sleep 1
            echo -e "${RD}[!] MENYERANG $target_ssid...${NT}"
            echo -e "${CY}(Simulasi mdk4 sedang berjalan... Tekan CTRL+C untuk stop)${NT}"
            # Animasi serangan palsu
            while true; do
                echo -e "${RD}Sending Deauth Packet to >> All Clients on $target_ssid [$(date +%T)]${NT}"
                sleep 0.5
            done
            ;;
        2)
            echo -e "${YW}[*] Membaca list.txt...${NT}"
            sleep 1
            echo -e "${GR}[+] Memulai Banjir WiFi Palsu (Beacon Flood)${NT}"
            echo -e "${CY}(Daftar nama galau sedang dipancarkan...)${NT}"
            echo "Spamming SSID: 'You drime me crazy'..."
            echo "Spamming SSID: 'Darkness my old friend'..."
            echo "Spamming SSID: 'Eka Sri Susman'..."
            while true; do
                echo -e "${GR}Packet Beacon Sent: 500 pps [$(date +%T)]${NT}"
                sleep 0.3
            done
            ;;
        3)
            echo -e "${RD}[!!!] CHAOS MODE AKTIF!${NT}"
            echo -e "${RD}Memutuskan semua koneksi pada semua channel...${NT}"
            while true; do
                echo -e "${YW}Hopping to Channel $((1 + RANDOM % 13)) - Attacking...${NT}"
                sleep 0.2
            done
            ;;
        4)
            echo -e "${GR}[V] Simulasi Selesai. Arigato!${NT}"
            exit 0
            ;;
        *)
            echo -e "${RD}[!] Pilihan Tidak Valid!${NT}"; sleep 1 ;;
    esac
done
