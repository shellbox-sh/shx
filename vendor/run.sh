run() {
  local RUN_VERSION="0.4.0"
  [[ "$1" = "--version" ]] && { echo "run version $RUN_VERSION"; return 0; }
  local ___run___RunInSubshell=false
  declare -a ___run___CommandToRun=()
  if [ "$1" = "{" ]; then
    shift
    while [ "$1" != "}" ] && [ $# -gt 0 ]; do
      ___run___CommandToRun+=("$1")
      shift
    done
    if [ "$1" = "}" ]; then
      shift
      if [ $# -ne 0 ]; then
        echo "'run' called with '{ ... }' block but unexpected argument found after block: '$1'" >&2
        return 1
      fi
    else
      echo "'run' called with '{' block but no closing '}' found" >&2
      return 1
    fi
  elif [ "$1" = "{{" ]; then
    ___run___RunInSubshell=true
    shift
    while [ "$1" != "}}" ] && [ $# -gt 0 ]; do
      ___run___CommandToRun+=("$1")
      shift
    done
    if [ "$1" = "}}" ]; then
      shift
      if [ $# -ne 0 ]; then
        echo "'run' called with '{{ ... }}' block but unexpected argument found after block: '$1'" >&2
        return 1
      fi
    else
      echo "'run' called with '{{' block but no closing '}}' found" >&2
      return 1
    fi
  elif [ "$1" = "[" ]; then
    shift
    while [ "$1" != "]" ] && [ $# -gt 0 ]; do
      ___run___CommandToRun+=("$1")
      shift
    done
    if [ "$1" = "]" ]; then
      shift
      if [ $# -ne 0 ]; then
        echo "'run' called with '[ ... ]' block but unexpected argument found after block: '$1'" >&2
        return 1
      fi
    else
      echo "'run' called with '[' block but no closing ']' found" >&2
      return 1
    fi
  elif [ "$1" = "[[" ]
  then
    ___run___RunInSubshell=true
    shift
    while [ "$1" != "]]" ] && [ $# -gt 0 ]; do
      ___run___CommandToRun+=("$1")
      shift
    done
    if [ "$1" = "]]" ]; then
      shift
      if [ $# -ne 0 ]; then
        echo "'run' called with '[[ ... ]]' block but unexpected argument found after block: '$1'" >&2
        return 1
      fi
    else
      echo "'run' called with '[[' block but no closing ']]' found" >&2
      return 1
    fi
  else
    while [ $# -gt 0 ]; do
      ___run___CommandToRun+=("$1")
      shift
    done
  fi
  local ___run___STDOUT_TempFile="$( mktemp )"
  local ___run___STDERR_TempFile="$( mktemp )"
  local ___run___UnusedOutput
  if [ "$___run___RunInSubshell" = "true" ]; then
    ___run___UnusedOutput="$( "${___run___CommandToRun[@]}" 1>"$___run___STDOUT_TempFile" 2>"$___run___STDERR_TempFile" )"
    EXITCODE=$?
  else
    "${___run___CommandToRun[@]}" 1>"$___run___STDOUT_TempFile" 2>"$___run___STDERR_TempFile"
    EXITCODE=$?
  fi
  STDOUT="$( < "$___run___STDOUT_TempFile" )"
  STDERR="$( < "$___run___STDERR_TempFile" )"
  rm -f "$___run___STDOUT_TempFile"
  rm -f "$___run___STDERR_TempFile"
  return $EXITCODE
}