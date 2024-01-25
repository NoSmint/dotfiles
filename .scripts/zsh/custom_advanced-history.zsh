function omz_history {
  local clear list
  zparseopts -E c=clear l=list d=delete

  if [[ -n "$clear" ]]; then
    # if -c provided, clobber the history file
    if read -q "choice?Are you sure to delete the complete History [y/n]?"; then
      echo -n >| "$HISTFILE"
      fc -p "$HISTFILE"
      echo && echo && echo >&2 History file deleted.
    fi
  elif [[ -n "$delete" ]]; then
    ARGS=$(echo $@ | sed "s/\s*-d\s*//")
    EVAL_LINES=$(grep "-i" "$ARGS" "$HISTFILE")
    echo $EVAL_LINES | grep -i "$ARGS"
    if read -q "choice?Are you sure to delete $(echo $EVAL_LINES | wc -l) lines from History [y/n]?"; then
      grep -iv $ARGS $HISTFILE > "/tmp/history" && rm "$HISTFILE" && mv "/tmp/history" "$HISTFILE" && rm -f "/tmp/history"
      echo && echo && echo >&2 $(echo $EVAL_LINES | wc -l) lines deleted from History.
      # hist -f -s reload
      builtin fc -p $HISTFILE $HISTSIZE $SAVEHIST
    fi
  elif [[ -n "$list" ]]; then
    # if -l provided, run as if calling `fc' directly
    builtin fc "$@"
  else
    # unless a number is provided, show all history events (starting from 1)
    [[ ${@[-1]-} = *[0-9]* ]] && builtin fc -l "$@" || builtin fc -l "$@" 1
  fi
}


function del-hist {
    if [ $#BUFFER -gt 0 ]; then
      EVAL_LINES=$(grep ";$BUFFER\$" "$HISTFILE")
      if [ $#EVAL_LINES -eq 0 ]; then
        return 2
      fi
      grep -v ";$BUFFER\$" "$HISTFILE" > "/tmp/history" && rm "$HISTFILE" && mv "/tmp/history" "$HISTFILE" && rm -f "/tmp/history"
      builtin fc -p $HISTFILE $HISTSIZE $SAVEHIST
      echo && echo >&2 $BUFFER deleted from History.
      BUFFER=
      zle accept-line
    fi
}

zle -N del-hist
bindkey '^[[20~' del-hist
