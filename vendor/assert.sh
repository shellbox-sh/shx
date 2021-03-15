assert() {
  local ASSERT_VERSION=0.2.2
  [ $# -eq 1 ] && [ "$1" = "--version" ] && { echo "assert version $ASSERT_VERSION"; return 0; }
  local command="$1"
  shift
  "$command" "$@"
  if [ $? -ne 0 ]
  then
    echo "Expected to succeed, but failed: \$ $command $@" >&2
    exit 1
  fi
  return 0
}