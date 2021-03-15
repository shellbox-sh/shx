##
# These variables are already defined by the specHarness binary and available for use:
##

# SPEC_DIR
# SPEC_FILE
# SPEC_NAME_PATTERN
# SPEC_CONFIG

##
# Public variables for extensibility
##

SPEC_CURRENT_FUNCTION=""
SPEC_FUNCTION=""
SPEC_NAME=""

declare -a SPEC_FUNCTION_NAMES=()
declare -a SPEC_DISPLAY_NAMES=()
declare -a SPEC_PENDING_FUNCTION_NAMES=()
declare -a SPEC_PENDING_DISPLAY_NAMES=()
declare -a SPEC_SETUP_FUNCTION_NAMES=()
declare -a SPEC_TEARDOWN_FUNCTION_NAMES=()
declare -a SPEC_SETUP_FIXTURE_FUNCTION_NAMES=()
declare -a SPEC_TEARDOWN_FIXTURE_FUNCTION_NAMES=()

##
# Placeholders for user customization / point to default implementations
##

spec.getSpecDisplayName() {
  ___spec___.getSpecDisplayName "$@"
}

spec.specNameMatchesPattern() {
  ___spec___.specNameMatchesPattern "$@"
}

spec.specFunctionPrefixes() {
  ___spec___.specFunctionPrefixes "$@"
}

spec.pendingFunctionPrefixes() {
  ___spec___.pendingFunctionPrefixes "$@"
}

spec.setupFunctionNames() {
  ___spec___.setupFunctionNames "$@"
}

spec.teardownFunctionNames() {
  ___spec___.teardownFunctionNames "$@"
}

spec.setupFixtureFunctionNames() {
  ___spec___.setupFixtureFunctionNames "$@"
}

spec.teardownFixtureFunctionNames() {
  ___spec___.teardownFixtureFunctionNames "$@"
}

spec.beforeFile() {
  ___spec___.beforeFile "$@"
}

spec.afterFile() {
  ___spec___.afterFile "$@"
}

spec.loadHelpers() {
  ___spec___.loadHelpers "$@"
}

spec.loadConfigs() {
  ___spec___.loadConfigs "$@"
}

spec.helperFilenames() {
  ___spec___.helperFilenames "$@"
}

spec.configFilenames() {
  ___spec___.configFilenames "$@"
}

spec.displaySpecBanner() {
  ___spec___.displaySpecBanner "$@"
}

spec.displayRunningSpec() {
  ___spec___.displayRunningSpec "$@"
}

spec.loadSpecs() {
  ___spec___.loadSpecs "$@"
}

spec.loadSpecFunctions() {
  ___spec___.loadSpecFunctions "$@"
}

spec.loadPendingFunctions() {
  ___spec___.loadPendingFunctions "$@"
}

spec.loadSetupFunctions() {
  ___spec___.loadSetupFunctions "$@"
}

spec.loadSetupFixtureFunctions() {
  ___spec___.loadSetupFixtureFunctions "$@"
}

spec.loadTeardownFunctions() {
  ___spec___.loadTeardownFunctions "$@"
}

spec.loadTeardownFixtureFunctions() {
  ___spec___.loadTeardownFixtureFunctions "$@"
}

spec.listSpecs() {
  ___spec___.listSpecs "$@"
}

spec.runSpecs() {
  ___spec___.runSpecs "$@"
}

spec.runSpecWithSetupAndTeardown() {
  ___spec___.runSpecWithSetupAndTeardown "$@"
}

spec.runSetup() {
  ___spec___.runSetup "$@"
}

spec.runSetupFixture() {
  ___spec___.runSetupFixture "$@"
}

spec.runSpec() {
  ___spec___.runSpec "$@"
}

spec.runTeardown() {
  ___spec___.runTeardown "$@"
}

spec.runTeardownFixture() {
  ___spec___.runTeardownFixture "$@"
}

spec.runFunction() {
  ___spec___.runFunction "$@"
}

spec.displaySpecResult() {
  ___spec___.displaySpecResult "$@"
}

spec.displaySpecSummary() {
  ___spec___.displaySpecSummary "$@"
}

##
# Private API
##

___spec___.specNameMatchesPattern() {
  local specFunctionName="$1"
  local specFunctionNameWithoutPrefix="$2"
  local specDisplayName="$3"
  local pattern="$4"
  pattern="${pattern// /[[:space:]]}"
  pattern="${pattern//\*/.*}"
  [[ "$specDisplayName" =~ $pattern ]]
}

___spec___.runFunction() {
  "$1"
}

___spec___.runSetup() {
  spec.runFunction "$1"
}

___spec___.runTeardown() {
  spec.runFunction "$1"
}

___spec___.runSetupFixture() {
  set -e
  spec.runFunction "$1"
  set +e
}

___spec___.runTeardownFixture() {
  set -e
  spec.runFunction "$1"
  set +e
}

___spec___.runSpec() {
  spec.runFunction "$1"
}

___spec___.getSpecDisplayName() {
  printf "${1//_/ }"
}

___spec___.specFunctionPrefixes() {
  echo @spec. @test. @it. @example.
}

___spec___.pendingFunctionPrefixes() {
  echo @pending. @xtest. @xit. @xexample. @xspec.
}

___spec___.setupFunctionNames() {
  echo @globalSetup @globalBefore @setup @before
}

___spec___.teardownFunctionNames() {
  echo @teardown @after @globalTeardown @globalAfter
}

___spec___.setupFixtureFunctionNames() {
  echo @globalBeforeAll @globalSetupFixture @beforeAll @setupFixture
}

___spec___.teardownFixtureFunctionNames() {
  echo @afterAll @teardownFixture @globalAfterAll @globalTeardownFixture
}

___spec___.helperFilenames() {
  echo specHelper.sh testHelper.sh helper.spec.sh helper.test.sh
}

___spec___.configFilenames() {
  echo spec.config.sh test.config.sh
}

___spec___.loadConfigs() {
  local dirpath="$1"
  declare -a specConfigPathsToSource=()

  local configFilename
  for configFilename in $( spec.configFilenames )
  do
    specConfigPathsToSource+=("$dirpath/$configFilename")
  done
  while [ "$dirpath" != "/" ] && [ "$dirpath" != "." ]
  do
    dirpath="$( dirname "$dirpath" )"
    for configFilename in $( spec.configFilenames )
    do
      specConfigPathsToSource+=("$dirpath/$configFilename")
    done
  done
  
  local i="${#specConfigPathsToSource[@]}"
  (( i -= 1 ))
  while [ $i -gt -1 ]
  do
    [ -f "${specConfigPathsToSource[$i]}" ] && source "${specConfigPathsToSource[$i]}"
    (( i -= 1 ))
  done
}

___spec___.loadHelpers() {
  local dirpath="$1"
  declare -a specHelperPathsToSource=()

  local helperFilename
  for helperFilename in $( spec.helperFilenames )
  do
    specHelperPathsToSource+=("$dirpath/$helperFilename")
  done
  while [ "$dirpath" != "/" ] && [ "$dirpath" != "." ]
  do
    dirpath="$( dirname "$dirpath" )"
    for helperFilename in $( spec.helperFilenames )
    do
      specHelperPathsToSource+=("$dirpath/$helperFilename")
    done
  done
  
  local i="${#specHelperPathsToSource[@]}"
  (( i -= 1 ))
  while [ $i -gt -1 ]
  do
    [ -f "${specHelperPathsToSource[$i]}" ] && source "${specHelperPathsToSource[$i]}"
    (( i -= 1 ))
  done
}

# Resposible for populating array(s):
# declare -a SPEC_FUNCTION_NAMES=()
# declare -a SPEC_DISPLAY_NAMES=()
___spec___.loadSpecFunctions() {
  local specPrefix
  for specPrefix in $( spec.specFunctionPrefixes )
  do
    [ -z "$specPrefix" ] && continue
    local specFunctionNames
    read -rd '' -a specFunctionNames <<<"$( declare -F | grep "declare -f $specPrefix" | sed 's/declare -f //' )"
    local specFunctionName
    for specFunctionName in "${specFunctionNames[@]}"
    do
      local withoutPrefix="${specFunctionName#"$specPrefix"}"
      local specDisplayName="$( spec.getSpecDisplayName "$withoutPrefix" "$specFunctionName" )"
      if [ -n "$SPEC_NAME_PATTERN" ]
      then
        if ! spec.specNameMatchesPattern "$specFunctionName" "$withoutPrefix" "$specDisplayName" "$SPEC_NAME_PATTERN"
        then
          continue
        fi
      fi
      local alreadyAdded=""
      local existingFunctionName
      for existingFunctionName in "${SPEC_FUNCTION_NAMES[@]}"
      do
        if [ "$existingFunctionName" = "$specFunctionName" ]
        then
          alreadyAdded=true
          break
        fi
      done
      if [ -z "$alreadyAdded" ]
      then
        SPEC_FUNCTION_NAMES+=("$specFunctionName")
        SPEC_DISPLAY_NAMES+=("$specDisplayName")
      fi
    done
  done
  unset specPrefix
  unset specFunctionName
  unset specFunctionNames
  unset specDisplayName
  unset withoutPrefix
  unset alreadyAdded
  unset existingFunctionName
}

# Resposible for populating array(s):
# declare -a SPEC_PENDING_FUNCTION_NAMES=()
# declare -a SPEC_PENDING_DISPLAY_NAMES=()
___spec___.loadPendingFunctions() {
  local pendingPrefix
  for pendingPrefix in $( spec.pendingFunctionPrefixes )
  do
    [ -z "$pendingPrefix" ] && continue
    local pendingFunctionNames
    read -rd '' -a pendingFunctionNames <<<"$( declare -F | grep "declare -f $pendingPrefix" | sed 's/declare -f //' )"
    local pendingFunctionName
    for pendingFunctionName in "${pendingFunctionNames[@]}"
    do
      local withoutPrefix="${pendingFunctionName#"$pendingPrefix"}"
      local pendingDisplayName="$( spec.getSpecDisplayName "$withoutPrefix" )"
      if [ -n "$SPEC_NAME_PATTERN" ]
      then
        if ! spec.specNameMatchesPattern "$pendingFunctionName" "$withoutPrefix" "$pendingDisplayName" "$SPEC_NAME_PATTERN"
        then
          continue
        fi
      fi
      local alreadyAdded=""
      local existingFunctionName
      for existingFunctionName in "${SPEC_PENDING_FUNCTION_NAMES[@]}"
      do
        if [ "$existingFunctionName" = "$pendingFunctionName" ]
        then
          alreadyAdded=true
          break
        fi
      done
      if [ -z "$alreadyAdded" ]
      then
        SPEC_PENDING_FUNCTION_NAMES+=("$pendingFunctionName")
        SPEC_PENDING_DISPLAY_NAMES+=("$pendingDisplayName")
      fi
    done
  done
  unset pendingPrefix
  unset pendingFunctionName
  unset pendingFunctionNames
  unset pendingDisplayName
  unset withoutPrefix
  unset alreadyAdded
  unset existingFunctionName
}

# Resposible for populating array(s):
# declare -a SPEC_SETUP_FUNCTION_NAMES=()
___spec___.loadSetupFunctions() {
  local setupFunctionName
  for setupFunctionName in $( spec.setupFunctionNames )
  do
    [ -z "$setupFunctionName" ] && continue
    if declare -F | grep "declare -f $setupFunctionName$" >/dev/null
    then
      SPEC_SETUP_FUNCTION_NAMES+=("$setupFunctionName")
    fi
  done
  unset setupFunctionName
}

# Resposible for populating array(s):
# declare -a SPEC_SETUP_FIXTURE_FUNCTION_NAMES=()
___spec___.loadSetupFixtureFunctions() {
  local setupFixtureFunctionName
  for setupFixtureFunctionName in $( spec.setupFixtureFunctionNames )
  do
    [ -z "$setupFixtureFunctionName" ] && continue
    if declare -F | grep "declare -f $setupFixtureFunctionName$" >/dev/null
    then
      SPEC_SETUP_FIXTURE_FUNCTION_NAMES+=("$setupFixtureFunctionName")
    fi
  done
  unset setupFixtureFunctionName
}

# Resposible for populating array(s):
# declare -a SPEC_TEARDOWN_FUNCTION_NAMES=()
___spec___.loadTeardownFunctions() {
  local teardownFunctionName
  for teardownFunctionName in $( spec.teardownFunctionNames )
  do
    [ -z "$teardownFunctionName" ] && continue
    if declare -F | grep "declare -f $teardownFunctionName$" >/dev/null
    then
      SPEC_TEARDOWN_FUNCTION_NAMES+=("$teardownFunctionName")
    fi
  done
  unset teardownFunctionName
}

# Resposible for populating array(s):
# declare -a SPEC_TEARDOWN_FIXTURE_FUNCTION_NAMES=()
___spec___.loadTeardownFixtureFunctions() {
  local teardownFixtureFunctionName
  for teardownFixtureFunctionName in $( spec.teardownFixtureFunctionNames )
  do
    [ -z "$teardownFixtureFunctionName" ] && continue
    if declare -F | grep "declare -f $teardownFixtureFunctionName$" >/dev/null
    then
      SPEC_TEARDOWN_FIXTURE_FUNCTION_NAMES+=("$teardownFixtureFunctionName")
    fi
  done
  unset teardownFixtureFunctionName
}

___spec___.beforeFile() {
  :
}

___spec___.afterFile() {
  :
}

___spec___.displaySpecBanner() {
  echo
  printf "["
  printf "\033[34m" >&2
  printf "$SPEC_FILE"
  printf "\033[0m" >&2
  printf "]\n"
}

___spec___.displayRunningSpec() {
  :
}

___spec___.displaySpecResult() {
  local functionName="$3"
  local name="$2"
  local status="$3"
  local stdout="$4"
  local stderr="$5"

  if [ "$status" = "PASS" ]
  then
    printf "["
    printf "\033[32m" >&2
    printf OK
    printf "\033[0m" >&2
    printf "] $name\n"
  elif [ "$status" = "FAIL" ]
  then
    printf "["
    printf "\033[31m" >&2
    printf FAIL
    printf "\033[0m" >&2
    printf "] $name\n"
  elif [ "$status" = "PENDING" ]
  then
    printf "["
    printf "\033[33m" >&2
    printf PENDING
    printf "\033[0m" >&2
    printf "] $name\n"
  elif [ "$status" = "NOT RUN" ]
  then
    echo "$name"
  fi

  if [ "$status" = "FAIL" ] || [ -n "$VERBOSE" ]
  then
    if [ -n "$stderr" ]
    then
      echo
      printf "\t["
      printf "\033[31;1m" >&2
      printf "Standard Error"
      printf "\033[0m" >&2
      printf "]\n"
      echo -e "$stderr" | sed $'s/\(.*\)/\t\\1/'
      echo
    fi
    if [ -n "$stdout" ]
    then
      echo
      printf "\t["
      printf "\033[34;1m" >&2
      printf "Output"
      printf "\033[0m" >&2
      printf "]\n"
      echo -e "$stdout" | sed $'s/\(.*\)/\t\\1/'
      echo
    fi
  fi
}

___spec___.displaySpecSummary() {
  local status="$1"
  local total="$2"
  local passed="$3"
  local failed="$4"
  local pending="$5"

  if [ $total -eq 0 ]
  then
    echo "No tests to run."
  elif [ "$failed" -eq 0 ]
  then
    printf "Specs passed."
  else
    printf "Specs failed."
  fi
  [ $passed  -gt 0 ] && printf " $passed passed."
  [ $failed  -gt 0 ] && printf " $failed failed."
  [ $pending -gt 0 ] && printf " $pending pending."
  printf "\n"
}

___spec___.loadSpecs() {
  spec.loadSpecFunctions
  spec.loadPendingFunctions
  spec.loadSetupFunctions
  spec.loadSetupFixtureFunctions
  spec.loadTeardownFunctions
  spec.loadTeardownFixtureFunctions
}

___spec___.listSpecs() {
  local specIndex=0
  while [ $specIndex -lt "${#SPEC_FUNCTION_NAMES[@]}" ]
  do
    specFunction="${SPEC_FUNCTION_NAMES[$specIndex]}"
    specName="${SPEC_DISPLAY_NAMES[$specIndex]}"
    echo -e "$specName\t$specFunction"
    (( specIndex++ ))
  done
  specIndex=0
  while [ $specIndex -lt "${#SPEC_PENDING_FUNCTION_NAMES[@]}" ]
  do
    specFunction="${SPEC_PENDING_FUNCTION_NAMES[$specIndex]}"
    specName="${SPEC_PENDING_DISPLAY_NAMES[$specIndex]}"
    echo -e "$specName\t$specFunction"
    (( specIndex++ ))
  done
}

___spec___.runSpecWithSetupAndTeardown() {
  local ___spec___unusedOutput
  local ___spec___specFailed=false

  # Run setup function(s)
  #
  # These are NOT un in a subshell, they need to load the environment.
  #
  # If one of these exits, the entire spec will exit.
  #
  local ___spec___SetupFunctionName
  for ___spec___SetupFunctionName in "${SPEC_SETUP_FUNCTION_NAMES[@]}"
  do
    SPEC_CURRENT_FUNCTION="$___spec___SetupFunctionName"
    spec.runSetup "$___spec___SetupFunctionName" 1>>"$SPEC_TEMP_STDOUT_FILE" 2>>"$SPEC_TEMP_STDERR_FILE"
    if [ $? -ne 0 ]
    then
      ___spec___specFailed=true
      break
    fi
  done

  # Run spec (unless setup failed)
  #
  # Run in subshell so that teardowns can be run afterwards even if the test fails
  #
  if [ "$___spec___specFailed" = "false" ]
  then
    SPEC_CURRENT_FUNCTION="$SPEC_FUNCTION"
    ___spec___unusedOutput="$( spec.runSpec "$SPEC_FUNCTION" 1>>"$SPEC_TEMP_STDOUT_FILE" 2>>"$SPEC_TEMP_STDERR_FILE" )"
    [ $? -ne 0 ] && ___spec___specFailed=true
  fi

  # Run teardown function(s) (even if setup or test failed)
  local ___spec___TeardownFunctionName
  for ___spec___TeardownFunctionName in "${SPEC_TEARDOWN_FUNCTION_NAMES[@]}"
  do
    SPEC_CURRENT_FUNCTION="$___spec___TeardownFunctionName"
    ___spec___unusedOutput="$( spec.runTeardown "$___spec___TeardownFunctionName" 1>>"$SPEC_TEMP_STDOUT_FILE" 2>>"$SPEC_TEMP_STDERR_FILE" )"
    [ $? -ne 0 ] && ___spec___specFailed=true
  done

  [ "$___spec___specFailed" = "false" ]
}

___spec___.runSpecs() {
  SPEC_TOTAL_COUNT="${#SPEC_FUNCTION_NAMES[@]}"
  SPEC_PENDING_COUNT="${#SPEC_PENDING_FUNCTION_NAMES[@]}"
  SPEC_FAILED_COUNT=0
  SPEC_PASSED_COUNT=0

  spec.displaySpecBanner

  #######################################################################################
  # Run Setup Fixtures, if any (note: unlike setup/teardown these are not in a subshell)
  ##
  local ___spec___SetupFixtureFunction
  for ___spec___SetupFixtureFunction in "${SPEC_SETUP_FIXTURE_FUNCTION_NAMES[@]}"
  do
    SPEC_CURRENT_FUNCTION="$___spec___SetupFixtureFunction"
    spec.runSetupFixture "$___spec___SetupFixtureFunction"
  done
  #######################################################################################

  local ___spec___CurrentSpecIndex=0
  while [ $___spec___CurrentSpecIndex -lt "${#SPEC_FUNCTION_NAMES[@]}" ]
  do
    SPEC_FUNCTION="${SPEC_FUNCTION_NAMES[$___spec___CurrentSpecIndex]}"
    SPEC_NAME="${SPEC_DISPLAY_NAMES[$___spec___CurrentSpecIndex]}"
    SPEC_RESULT_CODE=""

    (( ___spec___CurrentSpecIndex++ ))

    spec.displayRunningSpec "$SPEC_NAME"

    local ___spec___unusedOutput # needed to get correct $? while also running in subshell
    local SPEC_TEMP_STDOUT_FILE="$( mktemp )"
    local SPEC_TEMP_STDERR_FILE="$( mktemp )"

    #######################################################################################
    # Run spec
    ___spec___unusedOutput="$( spec.runSpecWithSetupAndTeardown )"
    SPEC_RESULT_CODE=$?
    #######################################################################################

    SPEC_STDOUT="$( cat "$SPEC_TEMP_STDOUT_FILE" )"
    SPEC_STDERR="$( cat "$SPEC_TEMP_STDERR_FILE" )"

    if [ $SPEC_RESULT_CODE -eq 0 ]
    then
      (( SPEC_PASSED_COUNT++ ))
      SPEC_STATUS="PASS"
      spec.displaySpecResult "$SPEC_FUNCTION" "$SPEC_NAME" "$SPEC_STATUS" "$SPEC_STDOUT" "$SPEC_STDERR"
    else
      SPEC_STATUS="FAIL"
      (( SPEC_FAILED_COUNT++ ))
      spec.displaySpecResult "$SPEC_FUNCTION" "$SPEC_NAME" "$SPEC_STATUS" "$SPEC_STDOUT" "$SPEC_STDERR"
    fi
  done

  #######################################################################################
  # Run Teardown Fixtures, if any (note: unlike setup/teardown these are not in a subshell)
  ##
  local ___spec___TeardownFixtureFunction
  for ___spec___TeardownFixtureFunction in "${SPEC_TEARDOWN_FIXTURE_FUNCTION_NAMES[@]}"
  do
    SPEC_CURRENT_FUNCTION="$___spec___TeardownFixtureFunction"
    spec.runTeardownFixture "$___spec___TeardownFixtureFunction"
  done
  #######################################################################################

  ##
  # Print Pending Specs
  ##
  local ___spec___CurrentPendingIndex=0
  while [ $___spec___CurrentPendingIndex -lt "${#SPEC_PENDING_FUNCTION_NAMES[@]}" ]
  do
    SPEC_FUNCTION="${SPEC_PENDING_FUNCTION_NAMES[$___spec___CurrentPendingIndex]}"
    SPEC_NAME="${SPEC_PENDING_DISPLAY_NAMES[$___spec___CurrentPendingIndex]}"
    (( ___spec___CurrentPendingIndex++ ))
    SPEC_STATUS="PENDING"
    spec.displayRunningSpec "$SPEC_NAME"
    spec.displaySpecResult "$SPEC_FUNCTION" "$SPEC_NAME" "$SPEC_STATUS"
  done

  if [ $SPEC_TOTAL_COUNT -gt 0 ] && [ $SPEC_FAILED_COUNT -gt 0 ]
  then
    SPEC_SUITE_STATUS="FAIL"
    spec.displaySpecSummary "$SPEC_STATUS" $SPEC_TOTAL_COUNT $SPEC_PASSED_COUNT $SPEC_FAILED_COUNT $SPEC_PENDING_COUNT
  else
    SPEC_SUITE_STATUS="PASS"
    spec.displaySpecSummary "$SPEC_STATUS" $SPEC_TOTAL_COUNT $SPEC_PASSED_COUNT $SPEC_FAILED_COUNT $SPEC_PENDING_COUNT
  fi

  [ $SPEC_FAILED_COUNT -eq 0 ]
}

[ -n "$SPEC_CONFIG" ] && [ -f "$SPEC_CONFIG" ] && source "$SPEC_CONFIG"