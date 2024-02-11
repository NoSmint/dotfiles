# Custom advanced cd command.
# cd <folder> checks for existing folders before using z before doing a recursive search
# trough the entire filesystem. Results are displayed using fzf.


cd() {
    if [ -z "$1" ]; then
        # Go to home without arguments
        builtin cd
    elif [ "$1" = "-" ] || [ "$1" = "." ] || [ "$1" = ".." ]; then
        # Handle special cases directly
        builtin cd "$1"
    else
        # Attempt to change directory with case insensitivity and fuzzy finding
        local target_dir
        # In zsh, set local case-insensitive option
        if [[ -n $ZSH_VERSION ]]; then
            setopt localoptions nocaseglob
        fi

        # In bash, set nocaseglob if not already set
        if [[ -n $BASH_VERSION ]]; then
            shopt -s nocaseglob 2>/dev/null
        fi

        builtin cd $** 2>/dev/null && return

        if [[ -n $ZSH_VERSION ]]; then
            zshz "$*" 2>/dev/null && echo -e "\033[1;31mZ FOLDER CHANGE: \033[1;32m$(pwd)\033[0m" && return
        fi

        if [[ -n $BASH_VERSION ]]; then
            z "$*" 2>/dev/null && echo -e "\033[1;31mBASH Z FOLDER CHANGE: \033[1;32m$(pwd)\033[0m" && return
        fi

        # Use fd and fzf to select directory, with fallback to current directory if none selected
        target_dir=$(fd "$1" '.' -t d -H -d 3 --exclude 'NAS' --exclude 'DS220J' 2>/dev/null | fzf -i -e --exit-0 --select-1 --reverse --cycle --height=~20)
        [[ -z $target_dir ]] && target_dir=$(fd . '.' -t d -H -d 1 2>/dev/null | fzf -i -e --exit-0 --select-1 --reverse --cycle --height=~20)

        if [ -d "$target_dir" ]; then
            builtin cd "$target_dir" 2>/dev/null
            return
        fi

    fi
}

cdr() {
    # Attempt to change directory with case insensitivity and fuzzy finding
    local target_dir

    # Use fd and fzf to select directory, with fallback to current directory if none selected
    target_dir=$(fd "$1" '.' -t d -H -d 4 --exclude 'NAS' --exclude 'DS220J' 2>/dev/null | fzf -i -e --exit-0 --select-1 --reverse --cycle --height=~20)
    [[ -z $target_dir ]] && target_dir=$(fd . '.' -t d -H -d 1 2>/dev/null | fzf -i -e --exit-0 --select-1 --reverse --cycle --height=~20)

    if [ -d "$target_dir" ]; then
        builtin cd "$target_dir"
        return
    fi
}

cd-fzf() {
    TEST=$(fd '.' -t d -H -d 1 | fzf -i -e --exit-0 --select-1 --reverse --cycle --height=~20)
    if [[ -z $TEST ]]; then
        zle reset-prompt
        return 1
    fi

    builtin cd $TEST
    zle reset-prompt
    zle accept-line
}

zle -N cd-fzf
bindkey '^[OQ' cd-fzf


# Improve pwd. Echo pwd and copy result to clipboard
pwd() {
    builtin pwd; builtin pwd | clipcopy
}
