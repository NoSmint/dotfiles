# Custom accept-line with several checks before execution.
# Empty Line: Do Nothing
# Empty Line within Git Folder: Git Status

my-accept-line () {
    # check if the buffer does not contain any words
    if [ ${#${(z)BUFFER}} -eq 0 ]; then
        # put newline so that the output does not start next
        # to the prompt
        # check if inside git repository
        if git rev-parse --git-dir > /dev/null 2>&1 ; then
            # if so, execute `git status'
            echo
            git status
            zle accept-line
        else
            # else run `ls'
            # ls
            # zle accept-line
        fi
    fi
    
    # run the `accept-line' widget in case $BUFFER contains input
    if [ ${#${(z)BUFFER}} -gt 0 ]; then
        zle accept-line
    fi
}

zle -N my-accept-line
bindkey '^M' my-accept-line
