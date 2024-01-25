linfilter() {

    [ -e "linpeas.log" ] && [ -z "$*" ] && grep --color=never -A 1 -B 1 '\[1;31;103m' "linpeas.log" | grep --color=auto -E '(^--$|^[^-].*)' && return
    [ -z "$*" ] && echo "Usage: linfilter <file.log>" && return
    [ -z "$2" ] && grep --color=never -A 1 -B 1 '\[1;31;103m' $1 | grep --color=auto -E '(^--$|^[^-].*)' && return
    grep --color=never -A $2 -B $2 '\[1;31;103m' $1 | grep --color=auto -E '(^--$|^[^-].*)'
}