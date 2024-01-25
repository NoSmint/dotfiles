#!/bin/bash

# Function to manage VPN connections the function takes a single optional argument, which is the
# path to the OpenVPN configuration file if no argument is passed, the default configuration file is
# use if the argument "-x" is passed, the function kills the active OpenVPN client

function vpn {
    
    # Elevate privilege to run commands with sudo
    
    # If the argument is "-x", kill the active OpenVPN client and reset the connection
    if [[ $* == "-x" ]] || [[ $* == "x" ]]; then
        # Kill the OpenVPN Client
        sudo killall -9 openvpn || return
        
        # Wait for the tun0 IP address to be reset
        counter=0
        oldVIP=$VIP
        while true; do
            CONN=$(ip addr show tun0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1) 2>/dev/null
            if [ -z "$CONN" ]; then
                echo "VPN connection reset"
                break
            fi
            if [ $counter -eq 10 ]; then
                echo "Failed to reset VPN connection after 10 seconds"
                echo "Connection might still be active. Please retry the command"
                break
            fi
            counter=$((counter+1))
            sleep 1
        done
        
        # Empty the clipboard buffer if it contains the disconnected VPN IP address
        CLIPBOARD=$(xsel -ob)
        if [[ "$oldVIP" == "$CLIPBOARD" ]]; then
            echo | clipcopy
            echo "Clipboard buffer emptied"
        fi
        
        return
    fi
    
    # Test if the VPN connection in TUN0 is already established
    
    CONN=$(ip addr show tun0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1) 2>/dev/null
    if [ -n "$CONN" ]; then
        echo "VPN connection for TUN0 already established. IP address: $CONN"
        export VIP=$CONN
        echo $VIP | clipcopy
        return
    fi
    
    # If an argument is passed, use it as the path to the configuration file if no argument is
    # passed, use the default configuration file
    if [ -z "$*" ]; then
        sudo openvpn --config ~/TryHackMe/NoSmint.ovpn --log /dev/stdout --data-ciphers-fallback BF-CBC --daemon 2>/dev/null
    else
        sudo openvpn --config "$*" --log /dev/stdout --daemon 2>/dev/null
    fi
    
    # Wait for the tun0 interface to receive its IP address
    while true; do
        CONN=$(ip addr show tun0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1) 2>/dev/null
        if [ "$CONN" != "" ]; then
            break
        fi
        sleep 1
    done
    export VIP=$CONN
    echo "VPN connection established. TUN0 IP: $VIP"
    echo $VIP | clipcopy
}

# With a press of the Ctrl+IP key, the function will evaluate the existence of a TUN0 IP address and
# insert it into the current buffer at the cursor's location. The cursor will then be moved to the
# right by the length of the IP address.

function get-vpn {
    CONN=$(ip addr show tun0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1) 2>/dev/null
    BUFFER=${BUFFER:0:$CURSOR}$CONN${BUFFER:$CURSOR}
    CURSOR=$((CURSOR + ${#CONN}))
}
zle -N get-vpn
bindkey '^i^p' get-vpn
bindkey '^[[17~' get-vpn

# Upon launching ZSH, the system will verify if a TUN0 connection is established. In the event of a
# successful connection, the IP address will be stored in the $VIP variable, granting access to it
# across all shell sessions, not just the one where the connection was established.
CONN=$(ip addr show tun0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1) 2>/dev/null
if [ -n "$CONN" ]; then
    export VIP=$CONN
fi


# TryHackMe Attack Box IP Functions
# The first function checks if the file ~/.config/.ip.thm exists and its content resembles a valid IPv4.
# If the conditions are met, the content is exported to the variable $IP.
#
# The second function takes one parameter and checks if it's a valid IPv4.
# If it is, the provided IP is stored in the ~/.config/.ip.thm file and exported to the variable $IP.
# If an invalid IP is provided, an error message is printed.

# Check if the file ~/.config/.ip.thm exists
if [ -f ~/.config/.ip.thm ]; then
    # Read the contents of the file into a variable
    file_contents=$(cat ~/.config/.ip.thm)
    
    # Check if the contents of the file resemble a valid IPv4 address
    if [[ $file_contents =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        # Export the contents of the file to the variable $IP
        export IP=$file_contents
        export thm=$file_contents
    fi
fi


function thm() {
    # Check if a valid IP address is provided as a parameter
    if [ -z $* ]; then
        unset VIP
        CONN=$(ip addr show tun0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1) 2>/dev/null
        if [ -n "$CONN" ]; then
            export VIP=$CONN
        fi
        echo "Current Attack-Box:  $IP\n       Current VPN:  $VIP" | boxes -d parchment -p l5 -s 50 && echo -n $IP | clipcopy && return
    fi
    if [[ $* == "-x" ]] || [[ $* == "x" ]] && cat /dev/null > ~/.config/.ip.thm && unset thm && unset IP && return
    if [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        # Store the IP address in the ~/.config/.ip.thm file, overwriting the existing content
        echo $1 > ~/.config/.ip.thm
        
        # Export the IP address to the $IP variable
        export IP=$1
        export thm=$1
    else
        # Print an error message if an invalid IP address is provided
        echo "Error: Invalid IP address provided"
    fi
}

# With a press of the Ctrl+THM key, the function will evaluate the existence of a $IP Variable and
# insert it into the current buffer at the cursor's location. The cursor will then be moved to the
# right by the length of the IP address.

function get-thm {
    if [ -z $IP ] && return
    BUFFER=${BUFFER:0:$CURSOR}$IP${BUFFER:$CURSOR}
    CURSOR=$((CURSOR + ${#IP}))
}
zle -N get-thm
bindkey '^t^h^m' get-thm
bindkey '^i^i' get-thm
bindkey '^[[15~' get-thm