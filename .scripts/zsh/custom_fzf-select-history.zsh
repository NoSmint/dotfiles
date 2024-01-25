# Custom History Fuzzy-Find with Ctrl + R or F3

function exists { which $1 &> /dev/null }

if exists fzf; then    

    function fzf-select-history() {
        local height_param=$1
        local height_option=""
        local tac

        # Check if height parameter is provided and not empty
        if [[ -n "$height_param" ]]; then
            [[ "$height_param" =~ ^[0-9]+%?$ ]] && height_option="--height=~$height_param"
        fi

        exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
        BUFFER=$(fc -l 1 | eval $tac | fzf -q "$LBUFFER" --cycle --bind backward-eof:abort --scheme=history --reverse -e -i $height_option | sed 's/^\s*\w*\s*//')
        CURSOR=$#BUFFER                 # move cursor
        zle reset-prompt                # refresh
    }

    function fzf-select-history-20() {
        fzf-select-history 20
    }

    zle -N fzf-select-history-20
    bindkey '^R' fzf-select-history-20
    zle -N fzf-select-history
    bindkey '^[OR' fzf-select-history
    
  
    function browse_aliases() {
        BUFFER=$(alias | fzf -q "$LBUFFER" --cycle --bind backward-eof:abort --scheme=history --reverse -i -e | sed "s/=.*$//")
        CURSOR=$#BUFFER
        zle reset-prompt
    }
    
    zle -N browse_aliases
    bindkey '^A' browse_aliases
fi