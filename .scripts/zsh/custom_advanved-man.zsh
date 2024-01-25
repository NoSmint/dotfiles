# Advanced man functionality. Important prerequisite: ln -s /usr/bin/command man /usr/bin/man

# F1 to open man on curent command in $BUFFER
function run-help {
    if [ ${#${(z)BUFFER}} -gt 0 ]; then
        ausgabe="${BUFFER%"${BUFFER##*[![:space:]]}"}"
        command man $ausgabe
    fi
}

zle -N run-help
bindkey '^[OP' run-help


# Advanced man functions.
# man man <command>
# man <command> <searchpattern>
# search pattern abbreviations:
#   o = OPTIONS
#   c = COMMAND
#   e = ENVIRONMENT
#   x = EXAMPLE
#   a = ARGUMENTS
# Anything else will be regarded as custom search pattern
man() {
    [ -z "$*" ] && command man -P "less -F" man && return
    [ -n "$1" ] && [ -z "$2" ] && command man -P "less -F" $1 && return
    [[ $2 == "o" || $2 == "O" ]] && echo OPTIONS && command man -P "less -F -p ^OPTIONS" $1 && return
    [[ $2 == "c" || $2 == "C" ]] && echo COMMAND && command man -P "less -F -p ^COMMAND" $1 && return
    [[ $2 == "e" || $2 == "E" ]] && echo ENVIRONMENT && command man -P "less -F -p ^ENVIRONMENT" $1 && return
    [[ $2 == "x" || $2 == "X" ]] && echo EXAMPLES && command man -P "less -F -p ^EXAMPLES" $1 && return
    [[ $2 == "a" || $2 == "A" ]] && echo ARGUMENTS && command man -P "less -F -p ^ARGUMENTS" $1 && return
    [ -n "$2" ] && command man -P "less -F -p \"^ *$2\"" $1
}