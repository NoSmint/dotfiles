function urldecode() {

  if [ "$#" -gt 0 ]; then
    # concatenated arguments fed via a pipe.
    printf %s "$@" | python3 -c "import sys; from urllib.parse import unquote; print(unquote(sys.stdin.read()));"
  else
    python3 -c "import sys; from urllib.parse import unquote; print(unquote(sys.stdin.read()));" < /dev/stdin  # read from stdin
  fi

}


function urlencode() {

  if [ "$#" -gt 0 ]; then
    # concatenated arguments fed via a pipe.
    printf %s "$@" | python3 -c "import sys; from urllib.parse import quote; print(quote(sys.stdin.read()));"
  else
    python3 -c "import sys; from urllib.parse import quote; print(quote(sys.stdin.read()));" < /dev/stdin  # read from stdin
  fi

}