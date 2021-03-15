refute() {
  local REFUTE_VERSION=0.2.2
  [ $# -eq 1 ] && [ "$1" = "--version" ] && { echo "refute version $REFUTE_VERSION"; return 0; }
  local command="$1"
  shift
  "$command" "$@"
  if [ $? -eq 0 ]
  then
    echo "Expected to fail, but succeeded: \$ $command $@" >&2
    exit 1
  fi
  return 0
}