#!/bin/zsh

# ANSI color codes
GREEN='\033[1;32m' # Bold green
BLUE='\033[1;34m'  # Bold blue
RED='\033[1;31m'   # Bold red
NC='\033[0m'       # No color
local snapshots=()

# List all snapshot numbers
snapshots=("${(@f)$(snapper list | awk 'NR > 2 && !/--+--/ && !/Pre # \| Date/ && !/important=yes/ && !/current/ {print $1}')}")

.ask.yes() {
  print -nPr - "%B$1%b"
  read -q '? [yn] '
  local ret=$?
  
  return ret
}

if (( ${#snapshots[@]} < 2 )); then
  echo "Nothing to delete"
else
  snapper list | grep -v 'important=yes' | grep -v 'current'
  echo
  if .ask.yes "%F{1}Delete all listed snapshots?%f"; then

    for snapshot in $snapshots; do
      if [[ $snapshot > 0 ]]; then
        echo "\n[${GREEN}*${NC}] ${BLUE}Deleting snapshot $snapshot ... ${NC}"
        snapper delete $snapshot
      fi
    done

  fi
fi