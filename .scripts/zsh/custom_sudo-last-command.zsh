#!/bin/zsh

# Description:
#   Zsh function to prepend 'sudo' to the last command or current buffer input.
#
# Usage:
#   Invoke the function with a key binding (Super + Enter) to execute the last command with 'sudo'
#   or prepend 'sudo' to the current buffer input if it's not empty.
#
# Notes:
#   - The function checks if 'sudo' is already part of the command to avoid duplication.
#   - It manages the command history and current buffer input seamlessly.
#   - Ensure you have sudo privileges for this function to work properly.
#
# Author:
#   Nils Uhde, 2024

sudo-last-command() {
    # Retrieve the last command from history and trim leading/trailing whitespace
    local last_command=$(fc -ln -1 | xargs)
    
    # Check if the current input buffer is empty
    if [ -z "${BUFFER}" ]; then
        # Check if the last command exists (non-empty)
        if [ -n "$last_command" ]; then
            # If 'sudo' is not already part of the last command, prepend it
            if [[ $last_command != sudo* ]]; then
                BUFFER="sudo $last_command"
                CURSOR=$#BUFFER  # Move the cursor to the end of the buffer
            else
                BUFFER="$last_command"
                CURSOR=$#BUFFER  # Move the cursor to the end of the buffer
            fi
        else
            # If no previous command was found, print a message and accept the line
            echo "No previous command found."
            zle accept-line
        fi
    else
        # If the buffer is not empty and 'sudo' is not part of the current input, prepend 'sudo'
        if [[ $BUFFER != sudo* ]]; then
            BUFFER="sudo $BUFFER"
        fi
        zle accept-line  # Accept the line as if it was typed and execute it
    fi
}

# Load the function into ZLE (Zsh Line Editor) and bind it to Super + Enter
zle -N sudo-last-command
bindkey '^X@s^M' sudo-last-command
