# configure key keybindings

bindkey -e                                     # emacs key bindings
bindkey ' ' magic-space                        # do history expansion on space
bindkey '^U' backward-kill-line                # ctrl + U
bindkey '^[[3~' delete-char                    # delete
bindkey '^[[1;5C' forward-word                 # ctrl + ->
bindkey '^[[1;5D' backward-word                # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history # page up
bindkey '^[[6~' end-of-buffer-or-history       # page down
bindkey '^[[H' beginning-of-line               # home
bindkey '^[[F' end-of-line                     # end
bindkey '^?' backward-kill-word                # ctrl + backspace delete word
bindkey '^H' backward-delete-char
bindkey '^W' backward-delete-char
bindkey '^[^H' kill-whole-line                    # alt + backspace delete line
bindkey "^[[A~" history-beginning-search-backward # up history search backward
bindkey "^[[B~" history-beginning-search-forward  # down history search forward
