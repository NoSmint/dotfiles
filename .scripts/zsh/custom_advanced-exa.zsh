# Custom functions to replace or improve default zsh behaviour


# Custom exa --header functions

function exists { which $1 &> /dev/null }

if exists exa; then
    x() {
        [ -z "$*" ] && exa --header --icons --long --group-directories-first --color=always --tree --level=1 | less -R -F -X --header 1 && return
        [[ $1 =~ "^[0-9]+$" ]] && exa --header --icons --long --group-directories-first --color=always --tree --level="$1" | less -R -F -X --header 1 && return
        exa --header --icons --long --group-directories-first --color=always $** 2>/dev/null | less -R -F -X --header 1 2>/dev/null
    }

    xa() {
        [ -z "$*" ] && exa --header -a --icons --long --group-directories-first --color=always --tree --level=1 | less -R -F -X --header 1 && return
        [[ $1 =~ "^[0-9]+$" ]] && exa --header -a --icons --long --group-directories-first --color=always --tree --level="$1" | less -R -F -X --header 1 && return
        exa --header -a --icons --long --group-directories-first --color=always $** 2>/dev/null | less -R -F -X --header 1
    }

    xs() {
        [ -z "$*" ] && exa --header --sort=size --icons --long --group-directories-first --color=always --tree --level=1 | less -R -F -X --header 1 && return
        [[ $1 =~ "^[0-9]+$" ]] && exa --header --sort=size --icons --long --group-directories-first --color=always --tree --level="$1" | less -R -F -X --header 1 && return
        exa --header --sort=size --icons --long --group-directories-first --color=always $** 2>/dev/null | less -R -F -X --header 1
    }

    xas() {
        [ -z "$*" ] && exa --header --sort=size -a --icons --long --group-directories-first --color=always --tree --level=1 | less -R -F -X --header 1 && return
        [[ $1 =~ "^[0-9]+$" ]] && exa --header --sort=size -a --icons --long --group-directories-first --color=always --tree --level="$1" | less -R -F -X --header 1 && return
        exa --header --sort=size -a --icons --long --group-directories-first --color=always $** 2>/dev/null | less -R -F -X --header 1
    }
fi