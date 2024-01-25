# Change working dir in shell to last dir in lf on exit (adapted from ranger).
#
# You need to either copy the content of this file to your shell rc file
# (e.g. ~/.bashrc) or source this file directly:
#
#     LFCD="/path/to/lfcd.sh"
#     if [ -f "$LFCD" ]; then
#         source "$LFCD"
#     fi
#
# You may also like to assign a key (Ctrl-O) to this command:
#
#     bind '"\C-o":"lfcd\C-m"'  # bash
#     bindkey -s '^o' 'lfcd\n'  # zsh
#

lfcd () {
    tmp="$(mktemp)"
    # `command` is needed in case `lfcd` is aliased to `lf`
    
    [ -z "$*" ] && command lf -last-dir-path="$tmp" "$@" || command lf -last-dir-path="$tmp" $(fd "$*" ~ -t d -H -1 -g)
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
    rm -f "$tmp" 2>/dev/null
}