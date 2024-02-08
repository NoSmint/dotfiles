# Custom advanced cd command.
# cd <folder> checks for existing folders before using z before doing a recursive search
# trough the entire filesystem. Results are displayed using fzf.


cd() {
    # Go to home without arguments
    [ -z "$*" ] && builtin cd && return
    # If directory exists, change to it
    setopt localoptions nocaseglob
    [ -d "$*" ] && builtin cd "$*" && return
    [ "$*" = "-" ] && builtin cd "$*" && return
    [ "$*" = "!" ] && builtin cd $(TEST=$(fd . '.' -t d -H -d 1); echo $TEST | fzf -i -e --exit-0 --select-1 --reverse --cycle --height=~20 || pwd ) && return
    [ "$*" = "?" ] && builtin cd $(TEST=$(fd . '.' -t d -d 1); echo $TEST | fzf -i -e --exit-0 --select-1 --reverse --cycle --height=~20 || pwd ) && return
    # Catch cd . and cd ..
    case "$*" in
        ..) builtin cd ..; return;;
        .) builtin cd .; return;;
    esac
    # Finally, call z -> cd -> cd spezial mit fdfind
    builtin cd $** 2>/dev/null && return || zshz "$*" && echo -e "\033[1;31mZ FOLDER CHANGE: \033[1;32m$(pwd)\033[0m" && return || builtin cd $(TEST=$(fd "$*" '.' -t d -H -d 3 --exclude 'NAS' --exclude 'DS220J'); echo $TEST | fzf -i -e --exit-0 --select-1 --reverse --cycle --height=~20 || pwd ) && return || builtin cd $(TEST=$(fd . '.' -t d -H -d 1); echo $TEST | fzf -i -e --exit-0 --select-1 --reverse --cycle --height=~20 || pwd ) && return
}

cdr() {
    # Go to home without arguments
    [ -z "$*" ] && builtin cd && return
    # If directory exists, change to it
    setopt localoptions nocaseglob
    [ -d "$*" ] && builtin cd "$*" && return
    [ "$*" = "-" ] && builtin cd "$*" && return
    builtin cd $(TEST=$(fd "$*" '.' -t d -H --exclude 'NAS' --exclude 'DS220J'); echo $TEST | fzf -i -e --exit-0 --select-1 --reverse --cycle --height=~20 || pwd ) && return
}

cd-fzf() {
    TEST=$(fd '.' -t d -H -d 1 | fzf -i -e --exit-0 --select-1 --reverse --cycle --height=~20)
    if [[ -z $TEST ]]; then
        zle reset-prompt
        return 1
    fi
    BUFFER="cd $TEST"
    CURSOR=$#BUFFER
    zle reset-prompt
    zle accept-line
}

zle -N cd-fzf
bindkey '^[OQ' cd-fzf


# Improve pwd. Echo pwd and copy result to clipboard
pwd() {
    builtin pwd; builtin pwd | clipcopy
}
