#!/bin/zsh

# Description:
#   Bash Script for System Update - Loaded at Terminal Startup
#
# Usage:
#   To update the system, run 'update' in the terminal.
#
# Notes:
#   - Ensure you have sudo privileges.
#   - The script will prompt for sudo password if necessary.
#   - Uses ANSI color codes for better output formatting.
#
# Author:
#   Nils Uhde, 2024

# ANSI color codes
GREEN='\033[1;32m' # Bold green
BLUE='\033[1;34m'  # Bold blue
RED='\033[1;31m'   # Bold red
NC='\033[0m'       # No color

# Function to update the system
update() {

    local custom_param="$1"

    # Prompt for sudo password before the first use of apt
    sudo -nv 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${BLUE}[*]${NC} [sudo] Authentication valid."
        sudo -nv 2>/dev/null
    else
        echo -en "${BLUE}[*]${NC} "
        sudo -nv 2>/dev/null
    fi

    sudo -v

    if [ $? -ne 0 ]; then
        echo -e "\n[${RED}ERROR${NC}] Unable to authenticate with sudo. Exiting."
        return 0
    fi

    # Detecting Presence of Nala Modern Package Manager
    echo -e "\n[${GREEN}*${NC}] ${BLUE}Detecting Nala Package Manager...${NC}"
    if command -v "nala" &>/dev/null && [ -z $custom_param ]; then

        # Upgrade system packages with nala
        echo -e "[${GREEN}*${NC}] ${BLUE}Nala Detected${NC}"
        echo -e "\n[${GREEN}*${NC}] Running: ${BLUE}Updating System Packages with Nala${NC}"
        # sudo apt upgrade -y 2> /dev/null | sed "s/^/  [*] /"
        sudo nala upgrade -y

        if [ $? -eq 0 ]; then
            echo -e "[${GREEN}SUCCESS${NC}] Upgrade completed successfully."
        else
            echo -e "[${RED}ERROR${NC}] Upgrade failed."
            return 0
        fi

    elif [[ $custom_param == a* ]]; then

        # Update system packages with apt
        if [[ "$custom_param" == "a*" ]]; then
            echo -e "[${GREEN}*${NC}] ${RED}Nala Detection Overruled by Custom Parameter. Using apt.${NC}"
        else
            echo -e "[${GREEN}*${NC}] ${RED}Nala Detection Failed. Fallback to apt.${NC}"
        fi
        echo -e "\n[${GREEN}*${NC}] ${BLUE}Updating Sources... ${NC}"
        echo -e "[${GREEN}*${NC}] Running: ${BLUE}sudo apt update${NC}"
        sudo apt update 2>/dev/null | sed "s/^/  [*] /"

        if [ $? -eq 0 ]; then
            echo -e "[${GREEN}SUCCESS${NC}] Update completed successfully."
        else
            echo -e "[${RED}ERROR${NC}] Update failed."
            return 0
        fi

        # Upgrade system packages with apt
        echo -e "\n[${GREEN}*${NC}] ${BLUE}Upgrading System Packages... ${NC}"
        echo -e "[${GREEN}*${NC}] Running: ${BLUE}sudo apt upgrade -y${NC}"
        sudo apt upgrade -y 2>/dev/null | sed "s/^/  [*] /"

        if [ $? -eq 0 ]; then
            echo -e "[${GREEN}SUCCESS${NC}] Upgrade completed successfully."
        else
            echo -e "[${RED}ERROR${NC}] Upgrade failed."
            return 0
        fi

        # Clean up unnecessary packages
        echo -e "\n[${GREEN}*${NC}] ${BLUE}Cleaning System Packages...${NC}"
        echo -e "[${GREEN}*${NC}] Running: ${BLUE}sudo apt autoclean${NC}"
        sudo apt autoclean 2>/dev/null | sed "s/^/  [*] /"

        if [ $? -eq 0 ]; then
            echo -e "[${GREEN}SUCCESS${NC}] Autoclean completed successfully."
        else
            echo -e "[${RED}ERROR${NC}] Autoclean failed."
            return 0
        fi

    else

        echo -e "\n[${RED}*${NC}] [${RED}Parameter \"$@\" unknown. Exiting${NC}"

    fi

}
