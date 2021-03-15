[ -z "$EXPECT_BLOCK_PAIRS" ] && EXPECT_BLOCK_PAIRS="{\n}\n{{\n}}\n[\n]\n[[\n]]\n"
EXPECT_BLOCK_SUBSHELL_TYPES="{{\n[[\n"

expect() {
  [ $# -eq 0 ] && { echo "Missing required argument for 'expect': actual value or { code block } or {{ subshell code block }}" >&2; return 1; }
  EXPECT_VERSION=0.5.0
  [ $# -eq 1 ] && [ "$1" = "--version" ] && { echo "expect version $EXPECT_VERSION"; return 0; }
  local ___expect___BlockPairsArray
  IFS=$'\n' read -d '' -ra ___expect___BlockPairsArray < <(printf "$EXPECT_BLOCK_PAIRS")
  local ___expect___BlockSymbolIndex=0
  while [ $___expect___BlockSymbolIndex -lt "${#___expect___BlockPairsArray[@]}" ]
  do
    local ___expect___StartSymbol="${___expect___BlockPairsArray[$___expect___BlockSymbolIndex]}"
    (( ___expect___BlockSymbolIndex += 1 ))
    local ___expect___EndSymbol="${___expect___BlockPairsArray[$___expect___BlockSymbolIndex]}"
    (( ___expect___BlockSymbolIndex += 1 ))
    if [ -n "$___expect___StartSymbol" ] && [ -n "$___expect___EndSymbol" ]
    then
      if [ "$1" = "$___expect___StartSymbol" ]
      then
        local EXPECT_BLOCK_OPEN="$___expect___StartSymbol"
        local EXPECT_BLOCK_CLOSE="$___expect___EndSymbol"
        break
      fi
    fi
  done
  local EXPECT_BLOCK_TYPE="$EXPECT_BLOCK_OPEN"
  local EXPECT_ACTUAL_RESULT=""
  declare -a EXPECT_BLOCK=()
  if [ -n "$EXPECT_BLOCK_TYPE" ]
  then
    shift    
    while [ "$1" != "$EXPECT_BLOCK_CLOSE" ] && [ $# -gt 0 ]
    do
      EXPECT_BLOCK+=("$1")
      shift
    done
    [ "$1" != "$EXPECT_BLOCK_CLOSE" ] && { echo "Expected '$EXPECT_BLOCK_OPEN' block to be closed with '$EXPECT_BLOCK_CLOSE' but no '$EXPECT_BLOCK_CLOSE' provided" >&2; return 1; }
    shift
  else
    EXPECT_ACTUAL_RESULT="$1"
    shift
  fi
  local EXPECT_NOT=""
  [ "$1" = "not" ] && { EXPECT_NOT=true; shift; }
  local EXPECT_MATCHER_NAME="$1"
  shift
  if [ -n "$EXPECT_MATCHER_FUNCTION" ]
  then
    "$EXPECT_MATCHER_FUNCTION" "$@"
  else
    "expect.matcher.$EXPECT_MATCHER_NAME" "$@"
  fi
}

EXPECT_FAIL="exit 1"

expect.fail() { echo -e "$*" >&2; $EXPECT_FAIL; }

# TODO move this into expect under -- to note add another function into the scope!
expect.execute_block() {
  local ___expect___allowFailure=""
  [ "$1" = allowFailure ] && { ___expect___allowFailure=true; shift; }
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    local ___expect___RunInSubshell=""
    local ___expect___SubshellBlockTypes
    IFS=$'\n' read -d '' -ra ___expect___SubshellBlockTypes < <(printf "$EXPECT_BLOCK_SUBSHELL_TYPES")
    local ___expect___SubshellBlockType
    for ___expect___SubshellBlockType in "${___expect___SubshellBlockTypes[@]}"
    do
      if [ "$EXPECT_BLOCK_TYPE" = "$___expect___SubshellBlockType" ]
      then
        ___expect___RunInSubshell=true
        break
      fi
    done
    local ___expect___stdout_file="$( mktemp )"
    local ___expect___stderr_file="$( mktemp )"
    if [ "$___expect___RunInSubshell" = "true" ]
    then
      # TODO pipe aliases instead of temporary files
      local ___expect___UnusedVariable
      ___expect___UnusedVariable="$( "${EXPECT_BLOCK[@]}" 1>"$___expect___stdout_file" 2>"$___expect___stderr_file" )"
      EXPECT_EXITCODE=$?
    else
      if [[ "$SHELLOPTS" = *"errexit"* ]]
      then
        set +e
        "${EXPECT_BLOCK[@]}" 1>"$___expect___stdout_file" 2>"$___expect___stderr_file"
        EXPECT_EXITCODE=$?
        set -e
      else
        "${EXPECT_BLOCK[@]}" 1>"$___expect___stdout_file" 2>"$___expect___stderr_file"
        EXPECT_EXITCODE=$?
      fi
    fi
    EXPECT_STDOUT="$( < "$___expect___stdout_file" )"
    EXPECT_STDERR="$( < "$___expect___stderr_file" )"
    rm -rf "$___expect___stdout_file"
    rm -rf "$___expect___stderr_file"
    if [ $EXPECT_EXITCODE -ne 0 ]  && [ -z "$___expect___allowFailure" ]
    then
      echo "'expect' command failed unexpectedly: ${EXPECT_BLOCK[*]}" >&2
      [ -n "$EXPECT_STDOUT" ] && echo " Output:  $EXPECT_STDOUT" >&2
      if shopt -q extglob
      then
        [ -n "$EXPECT_STDERR" ] && echo "Command output: ${EXPECT_STDERR/expect.sh: line +([[:digit:]]): }" >&2
      else
        shopt -s extglob
        [ -n "$EXPECT_STDERR" ] && echo "Command error: ${EXPECT_STDERR/expect.sh: line +([[:digit:]]): }" >&2
        shopt -u extglob
      fi
      return 1
    else
      return 0
    fi
  fi
}
expect.matcher.toBeEmpty() {
  [ $# -gt 0 ] && { echo "toBeEmpty expects 0 arguments, received $# [$*]" >&2; exit 1; }

  local ___expect___actualResult
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    expect.execute_block || return 1
    ___expect___actualResult="${EXPECT_STDOUT}${EXPECT_STDERR}"
  else
    ___expect___actualResult="$EXPECT_ACTUAL_RESULT"
  fi

  local actualResultOutput="$( echo -ne "$___expect___actualResult" | cat -vet )"

  if [ -z "$EXPECT_NOT" ]
  then
    if [ -n "$___expect___actualResult" ]
    then
      expect.fail "Expected result to be empty\nActual: '$actualResultOutput'"
    fi
  else
    if [ -z "$___expect___actualResult" ]
    then
      expect.fail "Expected result not to be empty\nActual: '$actualResultOutput'"
    fi
  fi

  return 0
}
expect.matcher.toContain() {
  [ "${#EXPECT_BLOCK[@]}" -eq 0 ] && [ $# -eq 0 ] && { echo "toContain expects 1 or more arguments, received $# [$*]" >&2; exit 1; }

  local ___expect___actualResult
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    expect.execute_block || return 1
    ___expect___actualResult="${EXPECT_STDOUT}${EXPECT_STDERR}"
  else
    ___expect___actualResult="$EXPECT_ACTUAL_RESULT"
  fi

  local actualResultOutput="$( echo -ne "$___expect___actualResult" | cat -vet )"

  local expected
  for expected in "$@"
  do
    local expectedResultOutput="$( echo -ne "$expected" | cat -vet )"

    if [ -z "$EXPECT_NOT" ]
    then
      if [[ "$___expect___actualResult" != *"$expected"* ]]
      then
        expect.fail "Expected result to contain text\nActual text: '$actualResultOutput'\nExpected text: '$expectedResultOutput'"
      fi
    else
      if [[ "$___expect___actualResult" = *"$expected"* ]]
      then
        expect.fail "Expected result not to contain text\nActual text: '$actualResultOutput'\nUnexpected text: '$expectedResultOutput'"
      fi
    fi
  done

  return 0
}
expect.matcher.toEqual() {
  [ "${#EXPECT_BLOCK[@]}" -eq 0 ] && [ $# -ne 1 ] && { echo "toEqual expects 1 argument (expected result), received $# [$*]" >&2; exit 1; }

  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    expect.execute_block || return 1
    local actualResult="${EXPECT_STDOUT}${EXPECT_STDERR}"
  else
    local actualResult="$EXPECT_ACTUAL_RESULT"
  fi

  local actualResultOutput="$( echo -ne "$actualResult" | cat -vet )"
  local expectedResultOutput="$( echo -ne "$1" | cat -vet )"

  if [ -z "$EXPECT_NOT" ]
  then
    if [ "$actualResultOutput" != "$expectedResultOutput" ]
    then
      expect.fail "Expected result to equal\nActual: '$actualResultOutput'\nExpected: '$expectedResultOutput'"
    fi
  else
    if [ "$actualResultOutput" = "$expectedResultOutput" ]
    then
      expect.fail "Expected result not to equal\nActual: '$actualResultOutput'\nExpected: '$expectedResultOutput'"
    fi
  fi

  return 0
}
expect.matcher.toFail() {
  [ "${#EXPECT_BLOCK[@]}" -lt 1 ] && { echo "toFail requires a block" >&2; exit 1; }

  expect.execute_block allowFailure

  if [ -z "$EXPECT_NOT" ]
  then
    if [ $EXPECT_EXITCODE -eq 0 ]
    then
      expect.fail "Expected to fail, but passed\nCommand: ${EXPECT_BLOCK[@]}\nSTDOUT: $EXPECT_STDOUT\nSTDERR: $EXPECT_STDERR"
    fi
  else
    if [ $EXPECT_EXITCODE -ne 0 ]
    then
      expect.fail "Expected to pass, but failed\nCommand: ${EXPECT_BLOCK[@]}\nSTDOUT: $EXPECT_STDOUT\nSTDERR: $EXPECT_STDERR"
    fi
  fi

  local actualResultOutput="$( echo -ne "$EXPECT_STDERR" | cat -vet )"

  local expectedOutputItem
  for expectedOutputItem in "$@"
  do
    local expectedResultOutput="$( echo -ne "$expectedOutputItem" | cat -vet )"
    if [ -z "$EXPECT_NOT" ]
    then
      if [[ "$EXPECT_STDERR" != *"$expectedOutputItem"* ]]
      then
        expect.fail "Expected STDERR to contain text\nCommand: ${EXPECT_BLOCK[@]}\nSTDERR: '$actualResultOutput'\nExpected text: '$expectedResultOutput'"
      fi
    else
      if [[ "$EXPECT_STDERR" = *"$expectedOutputItem"* ]]
      then
        expect.fail "Expected STDERR not to contain text\nCommand: ${EXPECT_BLOCK[@]}\nSTDERR: '$actualResultOutput'\nUnexpected text: '$expectedResultOutput'"
      fi
    fi
  done

  return 0
}
expect.matcher.toMatch() {
  [ "${#EXPECT_BLOCK[@]}" -eq 0 ] && [ $# -eq 0 ] && { echo "toMatch expects at least 1 argument (BASH regex patterns), received $# [$*]" >&2; exit 1; }

  local actualResult
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    expect.execute_block || return 1
    actualResult="${EXPECT_STDOUT}${EXPECT_STDERR}"
  else
    actualResult="$EXPECT_ACTUAL_RESULT"
  fi

  local actualResultOutput="$( echo -ne "$actualResult" | cat -vet )"

  local pattern
  for pattern in "$@"
  do
    # echo "DOES [$actualResult] =~ [$pattern]"
    if [ -z "$EXPECT_NOT" ]
    then
      if [[ ! "$actualResult" =~ $pattern ]]
      then
        expect.fail "Expected result to match\nActual text: '$actualResultOutput'\nPattern: '$pattern'"
      fi
    else
      if [[ "$actualResult" =~ $pattern ]]
      then
        expect.fail "Expected result not to match\nActual text: '$actualResultOutput'\nPattern: '$pattern'"
      fi
    fi
  done

  return 0
}
expect.matcher.toOutput() {
  local ___expect___ShouldCheckSTDOUT=""
  local ___expect___ShouldCheckSTDERR=""

  [ "${#EXPECT_BLOCK[@]}" -lt 1 ] && { echo "toOutput requires a block" >&2; exit 1; }
  [ "$1" = "toStdout" ] || [ "$1" = "toSTDOUT" ] && { ___expect___ShouldCheckSTDOUT=true; shift; }
  [ "$1" = "toStderr" ] || [ "$1" = "toSTDERR" ] && { ___expect___ShouldCheckSTDERR=true; shift; }
  [ $# -lt 1 ] && { echo "toOutput expects 1 or more arguments, received $#" >&2; exit 1; }

  expect.execute_block || return 1

  local EXPECT_STDOUT_actual="$( echo -e "$EXPECT_STDOUT" | cat -vet )"
  local EXPECT_STDERR_actual="$( echo -e "$EXPECT_STDERR" | cat -vet )"
  local OUTPUT_actual="$( echo -e "${EXPECT_STDOUT}${EXPECT_STDERR}" | cat -vet )"

  local expectedOutputItem
  for expectedOutputItem in "$@"
  do
    local ___expect___ExpectedResult="$( echo -e "$expectedOutputItem" | cat -vet )"
    # STDOUT
    if [ -n "$___expect___ShouldCheckSTDOUT" ]
    then
      if [ -z "$EXPECT_NOT" ]
      then
        if [[ "$EXPECT_STDOUT" != *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected STDOUT to contain text\nSTDOUT: '$EXPECT_STDOUT_actual'\nExpected text: '$___expect___ExpectedResult'"
        fi
      else
        if [[ "$EXPECT_STDOUT" = *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected STDOUT not to contain text\nSTDOUT: '$EXPECT_STDOUT_actual'\nUnexpected text: '$___expect___ExpectedResult'"
        fi
      fi
    # STDERR:
    elif [ -n "$___expect___ShouldCheckSTDERR" ]
    then
      if [ -z "$EXPECT_NOT" ]
      then
        if [[ "$EXPECT_STDERR" != *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected STDERR to contain text\nSTDERR: '$EXPECT_STDERR_actual'\nExpected text: '$___expect___ExpectedResult'"
        fi
      else
        if [[ "$EXPECT_STDERR" = *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected STDERR not to contain text\nSTDERR: '$EXPECT_STDERR_actual'\nUnexpected text: '$___expect___ExpectedResult'"
        fi
      fi
    # OUTPUT
    else
      if [ -z "$EXPECT_NOT" ]
      then
        if [[ "${EXPECT_STDOUT}${EXPECT_STDERR}" != *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected output to contain text\nOutput: '$OUTPUT_actual'\nExpected text: '$___expect___ExpectedResult'"
        fi
      else
        if [[ "${EXPECT_STDOUT}${EXPECT_STDERR}" = *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected output not to contain text\nOutput: '$OUTPUT_actual'\nUnexpected text: '$___expect___ExpectedResult'"
        fi
      fi
    fi
  done

  return 0
}
