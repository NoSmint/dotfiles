#Custom Aliases to Impport into ~/.zshrc
export WL=/usr/share/wordlists

alias cdr='builtin cd $(command ls -td -- ~/TryHackMe/*/ | head -n 1)'
alias dt='dutree -s'
alias http='python3 -m http.server 80'
alias room='lf room'
alias lf=lfcd
alias -g CC='| clipcopy'
alias -g strato='nosmint@81.169.181.217'
alias -g vip='81.169.181.217'
#alias history="history 0"
alias fd=fdfind
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias 'cd..'='cd ..'
alias ll='ls --group-directories-first -lha'
alias l='ls --group-directories-first -lh'
alias la='ls --group-directories-first -lha'
alias cls=clear
alias dir='ls -l'
alias snl='snapper list -a'
alias snaps='snapper list -a'
alias vscode='code'
alias zz='z -xR'
alias -g L="| less -R -F -X --header 1 2>/dev/null"
alias -g G='| grep --color=auto -i '
alias ls='exa --header --color=always --icons --group-directories-first'
alias stress='for i in $(seq $(getconf _NPROCESSORS_ONLN)); do yes > /dev/null & done'
alias mc='LANG=en_EN.UTF-8 source /usr/lib/mc/mc-wrapper.sh --nosubshell'
alias bat=batcat
alias cat='batcat -P'
alias cleanup='hist delete "(cd|hist|ls|pwd|mkdir|rmdir|rm|touch|cp|mv|cat|more|less|head|tail|echo|grep|top|ps|kill|df|du|chmod|chown|ping|ifconfig|ip|netstat|(apt-get|apt)|yum|dnf|zypper|pacman)*"'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotfile='config add -f'
