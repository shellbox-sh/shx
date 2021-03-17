#! /usr/bin/env bash

DOCGEN_PARSERS=(
  "docgen -- parsers clearContextParser"
  "docgen -- parsers paramParser"
  "docgen -- parsers returnParser"
  "docgen -- parsers exampleParser"
  "docgen -- parsers commandParser"
  "docgen -- parsers descriptionParser"
  "docgen -- parsers sourceCodeParser"
)

DOCGEN_CONTEXT_PROVIDER_COMMANDS=(
  "commands"
)
DOCGEN_CONTEXT_PROVIDERS_FUNCTIONS=(
  "docgen x contextProviders commands"
)

DOCGEN_SILENCE=false

_DOCGEN_CONTEXT_NAMES=()
_DOCGEN_CONTEXT_PARSE_TREE_ROOTS=()
_DOCGEN_CONTEXT_CURRENT_DIRECTORIES=()

## @command docgen
docgen() {
  declare -a __docgen__mainCliCommands=("docgen")
  declare -a __docgen__originalCliCommands=("$@")

## Documentation
## hello

# Public rendering variables (TODO document)

# TODO move this down and turn it on only during pattern matching
shopt -s extglob

# Documentation
[ -z "${DOCGEN_DOCUMENTATION_PATTERN+x}" ] && DOCGEN_DOCUMENTATION_PATTERN='^[[:space:]]*\#\#([[:space:]]?)(.*)'
[ -z "${DOCGEN_DOCUMENTATION_PATTERN_CAPTURE_GROUP+x}" ] && DOCGEN_DOCUMENTATION_PATTERN_CAPTURE_GROUP=2

# Decorator Name
[ -z "${DOCGEN_DECORATOR_NAME_PATTERN+x}" ] && DOCGEN_DECORATOR_NAME_PATTERN='^[[:space:]]*\#\#[[:space:]]@([^ ]*)([[:space:]]?)(.*)'
[ -z "${DOCGEN_DECORATOR_NAME_PATTERN_CAPTURE_GROUP+x}" ] && DOCGEN_DECORATOR_NAME_PATTERN_CAPTURE_GROUP=1

# Decorator Value
[ -z "${DOCGEN_DECORATOR_VALUE_PATTERN+x}" ] && DOCGEN_DECORATOR_VALUE_PATTERN='^[[:space:]]*\#\#[[:space:]]@([^ ]*)([[:space:]]?)(.*)'
[ -z "${DOCGEN_DECORATOR_VALUE_PATTERN_CAPTURE_GROUP+x}" ] && DOCGEN_DECORATOR_VALUE_PATTERN_CAPTURE_GROUP=3

  local __docgen__mainCliCommandDepth="1"
  __docgen__mainCliCommands+=("$1")
  local __docgen__mainCliCommands_command1="$1"
  shift
  case "$__docgen__mainCliCommands_command1" in
    ## @command docgen --
    "--")
      local __docgen__mainCliCommandDepth="2"
      __docgen__mainCliCommands+=("$1")
      local __docgen__mainCliCommands_command2="$1"
      shift
      case "$__docgen__mainCliCommands_command2" in
        ## @command docgen -- errors
        "errors")
            local __docgen__mainCliCommandDepth="3"
            __docgen__mainCliCommands+=("$1")
            local __docgen__mainCliCommands_command3="$1"
            shift
            case "$__docgen__mainCliCommands_command3" in
              ## @command docgen -- errors extensionError
              "extensionError")
                if [ $# -gt 0 ]
                then
                  printf '`docgen.sh` [ExtensionError] ' >&2
                  printf "$@" >&2
                else
                  printf '`docgen.sh` [ExtensionError]' >&2
                fi
                docgen -- errors printStackTrace
              ## @
      
                  ;;
              ## @command docgen -- errors getFileLine
              "getFileLine")
                  ## ## `utils getFileLine`
                  ##
                  ## Get the specified line from the specified file.
                  ##
                  ## > ℹ️ Used by `mocks -- error` to print LOC in stacktrace.
                  ##
                  ## | | Parameter  |
                  ## |-|------------|
                  ## | `$1` | Path to the file |
                  ## | `$2` | Line to print |
                  ##
                  if [ "$2" = "0" ]
                  then
                    sed "1q;d" "$1" | sed 's/^ *//g'
                  else
                    sed "${2}q;d" "$1" | sed 's/^ *//g'
                  fi
              ## @
      
                  ;;
              ## @command docgen -- errors parserWarning
              "parserWarning")
                if [ $# -gt 0 ]
                then
                  printf '`docgen.sh` [Parser Warning] ' >&2
                  printf "$@" >&2
                else
                  printf '`docgen.sh` [Parser Warning]' >&2
                fi
                docgen -- errors printStackTrace
              ## @
      
                  ;;
              ## @command docgen -- errors printStackTrace
              "printStackTrace")
                ## | `$1` | (_Optional_) How many levels to skip (default: `2`) |
                ## | `$2` | (_Optional_) How many levels deep to show (default: `100`) |
                
                local __docgen__x_errors_printStackTrace_levelsToSkip="${1-3}"
                local __docgen__x_errors_printStackTrace_levelsToShow="${2-100}"
                
                if [ "$DOCGEN_SILENCE" != "true" ]
                then
                  echo >&2
                  echo >&2
                  echo "Stacktrace:" >&2
                  echo >&2
                  local __docgen__i=1
                  local __docgen__stackIndex="$__docgen__x_errors_printStackTrace_levelsToSkip"
                  while [ $__docgen__stackIndex -lt ${#BASH_SOURCE[@]} ] && [ $__docgen__i -lt $__docgen__x_errors_printStackTrace_levelsToShow ]
                  do
                    local __docgen__errors_printStackTrace_line=''
                    __docgen__errors_printStackTrace_line="$( echo "$(docgen -- errors getFileLine "${BASH_SOURCE[$__docgen__stackIndex]}" "${BASH_LINENO[$(( __docgen__stackIndex - 1 ))]}")" | sed 's/^/    /' 2>&1 )"
                    # Catches sed errors
                    if [ $? -eq 0 ]
                    then
                      echo "${BASH_SOURCE[$__docgen__stackIndex]}:${BASH_LINENO[$__docgen__stackIndex]} ${FUNCNAME[$__docgen__stackIndex]}():" >&2
                      echo "  $__docgen__errors_printStackTrace_line" >&2
                    else
                      echo "${BASH_SOURCE[$__docgen__stackIndex]}:${BASH_LINENO[$__docgen__stackIndex]} ${FUNCNAME[$__docgen__stackIndex]}()" >&2
                    fi
                    echo >&2
                    : "$(( __docgen__stackIndex++ ))"
                    : "$(( __docgen__i++ ))"
                  done
                fi
              ## @
      
                  ;;
              *)
                echo "Unknown 'docgen -- errors' command: $__docgen__mainCliCommands_command3" >&2
                return 1
                ;;
            esac
        ## @
  
            ;;
        ## @command docgen -- parsers
        "parsers")
            local __docgen__mainCliCommandDepth="3"
            __docgen__mainCliCommands+=("$1")
            local __docgen__mainCliCommands_command3="$1"
            shift
            case "$__docgen__mainCliCommands_command3" in
              ## @command docgen -- parsers clearContextParser
              "clearContextParser")
                # Check for '@end' '@:end' '@' '@@' and '@@@' to close command context
                local __docgen_parsers_commandParser_documentationText
                if docgen x lines current getDocumentation __docgen_parsers_commandParser_documentationText
                then
                  if [ "$__docgen_parsers_commandParser_documentationText" = "@end" ] || [ "$__docgen_parsers_commandParser_documentationText" = "@:end" ] || [ "$__docgen_parsers_commandParser_documentationText" = "@" ] || [ "$__docgen_parsers_commandParser_documentationText" = "@@" ] || [ "$__docgen_parsers_commandParser_documentationText" = "@@@" ]
                  then
                    docgen x context clear
                    return 0
                  fi
                fi
                return 1
              ## @
      
                  ;;
              ## @command docgen -- parsers commandParser
              "commandParser")
                # Note: this will catch @anything so make sure this parser comes _after_ the other parsers
                
                local __docgen_parsers_commandParser_decoratorName
                if docgen x lines current getDecoratorName __docgen_parsers_commandParser_decoratorName
                then
                  local __docgen_parsers_commandParser_decoratorValue
                  docgen x lines current getDecoratorValue __docgen_parsers_commandParser_decoratorValue
                  __docgen_parsers_commandParser_decoratorName="${__docgen_parsers_commandParser_decoratorName#:}"
                  
                  local __docgen_parsers_commandParser_fullCommandName="$__docgen_parsers_commandParser_decoratorName"
                  [ -n "$__docgen_parsers_commandParser_decoratorValue" ] && __docgen_parsers_commandParser_fullCommandName="$__docgen_parsers_commandParser_fullCommandName $__docgen_parsers_commandParser_decoratorValue"
                
                  # This'll cause problems with commands name 'command'
                  if [ "$__docgen_parsers_commandParser_decoratorName" = 'command' ]
                  then
                    __docgen_parsers_commandParser_fullCommandName="${__docgen_parsers_commandParser_fullCommandName#"command "}"
                  fi
                
                  local __docgen_parsers_commandParser_contextPath="${__docgen_parsers_commandParser_fullCommandName// //}"
                
                  docgen x context set "@commands/$__docgen_parsers_commandParser_contextPath"
                
                  docgen x context write ".docgen/fullName" "$__docgen_parsers_commandParser_fullCommandName"
                
                  return 0
                
                fi
                
                return 1
              ## @
      
                  ;;
              ## @command docgen -- parsers descriptionParser
              "descriptionParser")
                if docgen x context isSet && docgen x lines current isDocumentation && ! docgen x lines current getDecoratorName >/dev/null
                then
                  local __docgen_parsers_descriptionParser_contextDescription=''
                  local __docgen_parsers_descriptionParser_newLine=$'\n'
                
                  if docgen x lines current isDocumentation
                  then
                    local __docgen_parsers_descriptionParser_currentLineDocumentation=''
                    docgen x lines current getDocumentation __docgen_parsers_descriptionParser_currentLineDocumentation
                    # change to +=
                    __docgen_parsers_descriptionParser_contextDescription="${__docgen_parsers_descriptionParser_currentLineDocumentation}${__docgen_parsers_descriptionParser_newLine}"
                  fi
                
                  while docgen x lines gotoNext
                  do
                    if docgen x lines current getDecoratorName >/dev/null || ! docgen x lines current isDocumentation >/dev/null # add hasDecorator or similar
                    then 
                      docgen x lines gotoPrevious
                      break
                    fi
                
                    if docgen x lines current isDocumentation
                    then
                      local __docgen_parsers_descriptionParser_currentLineDocumentation=''
                      docgen x lines current getDocumentation __docgen_parsers_descriptionParser_currentLineDocumentation
                      # change to +=
                      __docgen_parsers_descriptionParser_contextDescription="${__docgen_parsers_descriptionParser_contextDescription}${__docgen_parsers_descriptionParser_currentLineDocumentation}${__docgen_parsers_descriptionParser_newLine}"
                    fi
                  done
                
                  if [ -n "$__docgen_parsers_descriptionParser_contextDescription" ]
                  then
                    docgen x context write ".docgen/description" "$__docgen_parsers_descriptionParser_contextDescription"
                  fi
                
                  return 0
                fi
                
                return 1
              ## @
      
                  ;;
              ## @command docgen -- parsers exampleParser
              "exampleParser")
                local __docgen_parsers_exampleParser_decoratorName
                local __docgen_parsers_exampleParser_newLine=$'\n'
                if docgen x lines current getDecoratorName __docgen_parsers_exampleParser_decoratorName
                then
                  if [ "$__docgen_parsers_exampleParser_decoratorName" = "example" ]
                  then
                
                    local __docgen_parsers_exampleParser_exampleName=''
                    docgen x lines current getDecoratorValue __docgen_parsers_exampleParser_exampleName
                    [ -z "$__docgen_parsers_exampleParser_exampleName" ] && __docgen_parsers_exampleParser_exampleName=default
                
                    local ____docgen_parsers_exampleParser_exampleIndent=''
                    docgen x lines next getDocumentation ____docgen_parsers_exampleParser_exampleIndent
                    ____docgen_parsers_exampleParser_exampleIndent="${____docgen_parsers_exampleParser_exampleIndent//[^ ]/X}"
                    ____docgen_parsers_exampleParser_exampleIndent="${____docgen_parsers_exampleParser_exampleIndent%%X*}"
                
                    local __docgen_parsers_exampleParser_exampleContent=''
                    local __docgen_parsers_exampleParser_currentLineDocumentation=''
                
                    __docgen_parsers_exampleParser_decoratorName=''
                    while [ "$__docgen_parsers_exampleParser_decoratorName" = "" ] && docgen x lines next isDocumentation && [[ "$( docgen x lines next getDocumentation )" = "$____docgen_parsers_exampleParser_exampleIndent"* ]]
                    do
                      docgen x lines gotoNext
                      if ! docgen x lines current getDecoratorName __docgen_parsers_exampleParser_decoratorName
                      then
                        docgen x lines current getDocumentation __docgen_parsers_exampleParser_currentLineDocumentation
                        __docgen_parsers_exampleParser_exampleContent="${__docgen_parsers_exampleParser_exampleContent}${__docgen_parsers_exampleParser_currentLineDocumentation#"$____docgen_parsers_exampleParser_exampleIndent"}${__docgen_parsers_exampleParser_newLine}"
                      fi
                    done
                
                    docgen x context write ".docgen/examples/$__docgen_parsers_exampleParser_exampleName" "$__docgen_parsers_exampleParser_exampleContent"
                
                    return 0
                  fi
                fi
                
                return 1
              ## @
      
                  ;;
              ## @command docgen -- parsers paramParser
              "paramParser")
                local __docgen_parsers_paramParser_decoratorName
                if docgen x lines current getDecoratorName __docgen_parsers_paramParser_decoratorName
                then
                  if [ "$__docgen_parsers_paramParser_decoratorName" = "param" ]
                  then
                    docgen x context isSet || { docgen -- errors parserWarning "@param found but no context set - '($(docgen x lines current getText))'"; return 1; }
                    local __docgen_parsers_paramParser_decoratorValue
                    if docgen x lines current getDecoratorValue __docgen_parsers_paramParser_decoratorValue
                    then
                      local __docgen_parsers_paramParser_paramName="${__docgen_parsers_paramParser_decoratorValue%% *}"
                      local __docgen_parsers_paramParser_paramDescription="${__docgen_parsers_paramParser_decoratorValue#* }"
                      if [ -n "$__docgen_parsers_paramParser_paramName" ]
                      then
                        docgen x context write ".docgen/parameters/$__docgen_parsers_paramParser_paramName" "$( printf '%s' "$__docgen_parsers_paramParser_paramDescription" )"
                        return 0
                      fi
                    fi
                  fi
                fi
                
                return 1
              ## @
      
                  ;;
              ## @command docgen -- parsers returnParser
              "returnParser")
                local __docgen_parsers_returnParser_decoratorName
                if docgen x lines current getDecoratorName __docgen_parsers_returnParser_decoratorName
                then
                  if [ "$__docgen_parsers_returnParser_decoratorName" = "return" ] || [ "$__docgen_parsers_returnParser_decoratorName" = "returns" ]
                  then
                    local __docgen_parsers_returnParser_decoratorValue
                    if docgen x lines current getDecoratorValue __docgen_parsers_returnParser_decoratorValue
                    then
                      local __docgen_parsers_returnParser_returnCode="${__docgen_parsers_returnParser_decoratorValue%% *}"
                      local __docgen_parsers_returnParser_returnDescription="${__docgen_parsers_returnParser_decoratorValue#* }"
                      if [ -n "$__docgen_parsers_returnParser_returnCode" ]
                      then
                        docgen x context write ".docgen/returnValues/$__docgen_parsers_returnParser_returnCode" "$( printf '%s' "$__docgen_parsers_returnParser_returnDescription" )"
                        return 0
                      fi
                    fi
                  fi
                fi
                
                return 1
              ## @
      
                  ;;
              ## @command docgen -- parsers sourceCodeParser
              "sourceCodeParser")
                if docgen x context isSet && ! docgen x lines current isDocumentation && ! docgen x lines current getDecoratorName >/dev/null
                then
                  local __docgen_parsers_sourceCodeParser_sourceCode=''
                  local __docgen_parsers_sourceCodeParser_contextDescription=''
                  local __docgen_parsers_sourceCodeParser_newLine=$'\n'
                  local __docgen_parsers_sourceCodeParser_indentation=''
                
                  if ! docgen x lines current isDocumentation
                  then
                    local __docgen_parsers_sourceCodeParser_currentLine=''
                    docgen x lines current getText __docgen_parsers_sourceCodeParser_currentLine
                
                    # get the spaces
                    __docgen_parsers_sourceCodeParser_indentation="${__docgen_parsers_sourceCodeParser_currentLine//[^ ]/X}"
                    __docgen_parsers_sourceCodeParser_indentation="${__docgen_parsers_sourceCodeParser_indentation%%X*}"
                
                    # change to +=
                    __docgen_parsers_sourceCodeParser_sourceCode="${__docgen_parsers_sourceCodeParser_currentLine#"$__docgen_parsers_sourceCodeParser_indentation"}${__docgen_parsers_sourceCodeParser_newLine}"
                  fi
                
                  while docgen x lines gotoNext
                  do
                    if docgen x lines current getDecoratorName >/dev/null || docgen x lines current isDocumentation >/dev/null # add hasDecorator or similar
                    then 
                      docgen x lines gotoPrevious
                      break
                    fi
                
                    if ! docgen x lines current isDocumentation
                    then
                      local __docgen_parsers_sourceCodeParser_currentLine=''
                      docgen x lines current getText __docgen_parsers_sourceCodeParser_currentLine
                      # change to +=
                      __docgen_parsers_sourceCodeParser_sourceCode="${__docgen_parsers_sourceCodeParser_sourceCode}${__docgen_parsers_sourceCodeParser_currentLine#"$__docgen_parsers_sourceCodeParser_indentation"}${__docgen_parsers_sourceCodeParser_newLine}"
                    fi
                  done
                
                  if [ -n "$__docgen_parsers_sourceCodeParser_sourceCode" ]
                  then
                    docgen x context write ".docgen/sourceCode.sh" "$__docgen_parsers_sourceCodeParser_sourceCode"
                  fi
                
                  return 0
                fi
                
                return 1
              ## @
      
                  ;;
              *)
                echo "Unknown 'docgen -- parsers' command: $__docgen__mainCliCommands_command3" >&2
                return 1
                ;;
            esac
        ## @
  
            ;;
        *)
          echo "Unknown 'docgen --' command: $__docgen__mainCliCommands_command2" >&2
          return 1
          ;;
      esac
    ## @

        ;;
    ## @command docgen context
    ## This just adds some docs, that's all.
    "context")
      local __docgen__mainCliCommandDepth="2"
      __docgen__mainCliCommands+=("$1")
      local __docgen__mainCliCommands_command2="$1"
      shift
      case "$__docgen__mainCliCommands_command2" in
        ## @command docgen context create
        ## This just adds some docs, that's all.
        "create")
            local __docgen__mainCliCommandDepth="3"
            __docgen__mainCliCommands+=("$1")
            local __docgen__mainCliCommands_command3="$1"
            shift
            case "$__docgen__mainCliCommands_command3" in
              ## @command docgen context create new
              "new")
                local __docgen_context_createNew_contextName="$1"
                [ $# -eq 0 ] && __docgen_context_createNew_contextName=":default"
                
                local __docgen_context_createNew_parseTreeRoot=''
                if docgen parseTree getRoot __docgen_context_createNew_parseTreeRoot
                then
                  # Register the new context (starts at the root)
                  _DOCGEN_CONTEXT_NAMES+=("$__docgen_context_createNew_contextName")
                  _DOCGEN_CONTEXT_CURRENT_DIRECTORIES+=("${__docgen_context_createNew_parseTreeRoot%/}")
                  _DOCGEN_CONTEXT_PARSE_TREE_ROOTS+=("${__docgen_context_createNew_parseTreeRoot%/}")
                  return 0
                else
                  docgen x errors contextError '%s\n%s' "Please use \`parseTree setRoot\` to configure tree root before using the \`context\` API" "Command: docgen ${__docgen__originalCliCommands[*]}"
                  return 1
                fi
              ## @
      
                  ;;
              *)
                echo "Unknown 'docgen context create' command: $__docgen__mainCliCommands_command3" >&2
                return 1
                ;;
            esac
        ## @
  
            ;;
        ## @command docgen context getAllChildren
        "getAllChildren")
          ## @param $1 something something
          ## @param $@ all the things
          ## Description
          
          # Determine context identifier
          local __docgen_context_getAllChildren_contextName=':default'
          [[ "$1" = ":"* ]] && { __docgen_context_getAllChildren_contextName="$1"; shift; }
          
          # Get context current directory (this has the side-effect of asserting the validity of the context identifier)
          local __docgen_context_getAllChildren_contextCurrentDirectory=''
          docgen context getDirectory "$__docgen_context_getAllChildren_contextName" __docgen_context_getAllChildren_contextCurrentDirectory || return $?
          
          local __docgen_context_getAllChildren_childNodeName=''
          while read -rd '' __docgen_context_getAllChildren_childNodeName
          do
            [ "$__docgen_context_getAllChildren_childNodeName" = "$__docgen_context_getAllChildren_contextCurrentDirectory" ] && continue
            if [ -n "$1" ]
            then
              eval "$1+=(\"\${__docgen_context_getAllChildren_childNodeName##*/}\")"
            else
              echo "${__docgen_context_getAllChildren_childNodeName##*/}"
            fi
          done < <( find "$__docgen_context_getAllChildren_contextCurrentDirectory" -type d -not -name .docgen -not -path "*/.docgen/*" -print0 )
        ## @
  
            ;;
        ## @command docgen context getChildren
        "getChildren")
          # Determine context identifier
          local __docgen_context_getChildren_contextName=':default'
          [[ "$1" = ":"* ]] && { __docgen_context_getChildren_contextName="$1"; shift; }
          
          # Get context current directory (this has the side-effect of asserting the validity of the context identifier)
          local __docgen_context_getChildren_contextCurrentDirectory=''
          docgen context getDirectory "$__docgen_context_getChildren_contextName" __docgen_context_getChildren_contextCurrentDirectory || return $?
          
          local __docgen_context_getChildren_childNodeName=''
          while read -rd '' __docgen_context_getChildren_childNodeName
          do
            [ "$__docgen_context_getChildren_childNodeName" = "$__docgen_context_getChildren_contextCurrentDirectory" ] && continue
            if [ -n "$1" ]
            then
              eval "$1+=(\"\${__docgen_context_getChildren_childNodeName##*/}\")"
            else
              echo "${__docgen_context_getChildren_childNodeName##*/}"
            fi
          done < <( find "$__docgen_context_getChildren_contextCurrentDirectory" -maxdepth 1 -type d -not -name .docgen -print0 )
        ## @
  
            ;;
        ## @command docgen context getDirectory
        "getDirectory")
          # Determine context identifier
          local __docgen_context_getDirectory_contextName=':default'
          [[ "$1" = ":"* ]] && { __docgen_context_getDirectory_contextName="$1"; shift; }
          
          # Find this context (asserting that it exists) - O(N) operation <-- which is done very frequently too. Please don't make many contexts!
          local __docgen_context_getDirectory_contextSearchIndex=0
          while [ "$__docgen_context_getDirectory_contextSearchIndex" -lt "${#_DOCGEN_CONTEXT_NAMES[@]}" ]
          do
            if [ "${_DOCGEN_CONTEXT_NAMES[$__docgen_context_getDirectory_contextSearchIndex]}" = "$__docgen_context_getDirectory_contextName" ]
            then
              if [ -n "$1" ]
              then
                printf -v "$1" '%s' "${_DOCGEN_CONTEXT_CURRENT_DIRECTORIES[$__docgen_context_getDirectory_contextSearchIndex]}"
              else
                printf '%s' "${_DOCGEN_CONTEXT_CURRENT_DIRECTORIES[$__docgen_context_getDirectory_contextSearchIndex]}"
              fi
              return 0
            fi
            : "$(( __docgen_context_getDirectory_contextSearchIndex++ ))"
          done
          
          # Handle edge-case:
          #
          # If :default is provided and is not in the array but a tree root is available,
          # this will add the :default item and return the root of the tree (registering :default)
          if [ "$__docgen_context_getDirectory_contextName" = ":default" ]
          then
            local __docgen_context_getDirectory_parseTreeRoot=''
            if docgen parseTree getRoot __docgen_context_getDirectory_parseTreeRoot
            then
              # Register :default
              _DOCGEN_CONTEXT_NAMES+=(":default")
              _DOCGEN_CONTEXT_CURRENT_DIRECTORIES+=("${__docgen_context_getDirectory_parseTreeRoot%/}")
              _DOCGEN_CONTEXT_PARSE_TREE_ROOTS+=("${__docgen_context_getDirectory_parseTreeRoot%/}")
              if [ -n "$1" ]
              then
                printf -v "$1" '%s' "$__docgen_context_getDirectory_parseTreeRoot"
              else
                printf '%s' "$__docgen_context_getDirectory_parseTreeRoot"
              fi
              return 0
            else
              docgen x errors contextError '%s\n%s' "Please use \`parseTree setRoot\` to configure tree root before using the \`context\` API" "Command: docgen ${__docgen__originalCliCommands[*]}"
              return 1
            fi
          fi
          
          docgen x errors contextError '%s\n%s' "Context not found: $__docgen_context_getDirectory_contextName" "Command: docgen ${__docgen__originalCliCommands[*]}"
          return 1
        ## @
  
            ;;
        ## @command docgen context getList
        "getList")
          # Determine context identifier
          local __docgen_context_getList_contextName=':default'
          [[ "$1" = ":"* ]] && { __docgen_context_getList_contextName="$1"; shift; }
          
          # Get context current directory (this has the side-effect of asserting the validity of the context identifier)
          local __docgen_context_getList_contextCurrentDirectory=''
          docgen context getDirectory "$__docgen_context_getList_contextName" __docgen_context_getList_contextCurrentDirectory || return $?
          
          [ -n "$2" ] && eval "$2=()"
          
          if [ -d "$__docgen_context_getList_contextCurrentDirectory/.docgen/$1" ]
          then
            local __docgen_context_getList_itemName
            while read -rd '' __docgen_context_getList_itemName
            do
              [ "$__docgen_context_getList_itemName" = "$__docgen_context_getList_contextCurrentDirectory/.docgen/$1" ] && continue
              if [ -n "$2" ]
              then
                eval "$2+=(\"\${__docgen_context_getList_itemName##*/}\")"
              else
                echo "${__docgen_context_getList_itemName##*/}"
              fi
            done < <( find "$__docgen_context_getList_contextCurrentDirectory/.docgen/$1" -maxdepth 1 -print0 | sort -z )
          elif [ -f "$__docgen_context_getList_contextCurrentDirectory/.docgen/$1" ]
          then
            docgen x errors contextError '%s\n%s\n%s' "Cannot use \`getList\` to read values, use \`getValue\` instead: $1" "Location: $__docgen_context_getList_contextCurrentDirectory" "Command: docgen ${__docgen__originalCliCommands[*]}"
            return 1
          else
            [ -z "$2" ] && docgen x errors contextError '%s\n%s\n%s' "item not found: $1" "Location: $__docgen_context_getList_contextCurrentDirectory" "Command: docgen ${__docgen__originalCliCommands[*]}"
            return 1
          fi
        ## @
  
            ;;
        ## @command docgen context getPath
        "getPath")
          
          # Determine context identifier
          local __docgen_context_getPath_contextName=':default'
          [[ "$1" = ":"* ]] && { __docgen_context_getPath_contextName="$1"; shift; }
          
          # Get context current directory (this has the side-effect of asserting the validity of the context identifier)
          local __docgen_context_getPath_contextCurrentDirectory=''
          docgen context getDirectory "$__docgen_context_getPath_contextName" __docgen_context_getPath_contextCurrentDirectory || return $?
          
          # Get original context parseTree root directory
          local __docgen_context_getPath_contextRootDirectory=''
          docgen context getRootDirectory "$__docgen_context_getPath_contextName" __docgen_context_getPath_contextRootDirectory || return $?
          
          local __docgen_context_getPath_contextPath="${__docgen_context_getPath_contextCurrentDirectory#"$__docgen_context_getPath_contextRootDirectory"}"
          
          if [ -n "$1" ]
          then
            printf -v "$1" '%s' "${__docgen_context_getPath_contextPath#/}"
          else
            printf '%s' "${__docgen_context_getPath_contextPath#/}"
          fi
        ## @
  
            ;;
        ## @command docgen context getRootDirectory
        "getRootDirectory")
          # Determine context identifier
          local __docgen_context_getRootDirectory_contextName=':default'
          [[ "$1" = ":"* ]] && { __docgen_context_getRootDirectory_contextName="$1"; shift; }
          
          # Find this context (asserting that it exists) - O(N) operation <-- which is done very frequently too. Please don't make many contexts!
          local __docgen_context_getRootDirectory_contextSearchIndex=0
          while [ "$__docgen_context_getRootDirectory_contextSearchIndex" -lt "${#_DOCGEN_CONTEXT_NAMES[@]}" ]
          do
            if [ "${_DOCGEN_CONTEXT_NAMES[$__docgen_context_getRootDirectory_contextSearchIndex]}" = "$__docgen_context_getRootDirectory_contextName" ]
            then
              if [ -n "$1" ]
              then
                printf -v "$1" '%s' "${_DOCGEN_CONTEXT_PARSE_TREE_ROOTS[$__docgen_context_getRootDirectory_contextSearchIndex]}"
              else
                printf '%s' "${_DOCGEN_CONTEXT_PARSE_TREE_ROOTS[$__docgen_context_getRootDirectory_contextSearchIndex]}"
              fi
              return 0
            fi
            : "$(( __docgen_context_getRootDirectory_contextSearchIndex++ ))"
          done
          
          # Handle edge-case:
          #
          # If :default is provided and is not in the array but a tree root is available,
          # this will add the :default item and return the root of the tree (registering :default)
          if [ "$__docgen_context_getRootDirectory_contextName" = ":default" ]
          then
            local __docgen_context_getRootDirectory_parseTreeRoot=''
            if docgen parseTree getRoot __docgen_context_getRootDirectory_parseTreeRoot
            then
              # Register :default
              _DOCGEN_CONTEXT_NAMES+=(":default")
              _DOCGEN_CONTEXT_CURRENT_DIRECTORIES+=("${__docgen_context_getRootDirectory_parseTreeRoot%/}")
              _DOCGEN_CONTEXT_PARSE_TREE_ROOTS+=("${__docgen_context_getRootDirectory_parseTreeRoot%/}")
              if [ -n "$1" ]
              then
                printf -v "$1" '%s' "$__docgen_context_getRootDirectory_parseTreeRoot"
              else
                printf '%s' "$__docgen_context_getRootDirectory_parseTreeRoot"
              fi
              return 0
            else
              docgen x errors contextError '%s\n%s' "Please use \`parseTree setRoot\` to configure tree root before using the \`context\` API" "Command: docgen ${__docgen__originalCliCommands[*]}"
              return 1
            fi
          fi
          
          docgen x errors contextError '%s\n%s' "Context not found: $__docgen_context_getRootDirectory_contextName" "Command: docgen ${__docgen__originalCliCommands[*]}"
          return 1
        ## @
  
            ;;
        ## @command docgen context getValue
        "getValue")
          # Determine context identifier
          local __docgen_context_getValue_contextName=':default'
          [[ "$1" = ":"* ]] && { __docgen_context_getValue_contextName="$1"; shift; }
          
          # Get context current directory (this has the side-effect of asserting the validity of the context identifier)
          local __docgen_context_getValue_contextCurrentDirectory=''
          docgen context getDirectory "$__docgen_context_getValue_contextName" __docgen_context_getValue_contextCurrentDirectory || return $?
          
          if [ -f "$__docgen_context_getValue_contextCurrentDirectory/.docgen/$1" ]
          then
            local __docgen_context_getValue_itemValue="$(<"$__docgen_context_getValue_contextCurrentDirectory/.docgen/$1")"
            if [ -n "$2" ]
            then
              printf -v "$2" '%s' "$__docgen_context_getValue_itemValue"
            else
              printf '%s' "$__docgen_context_getValue_itemValue"
            fi
          elif [ -d "$__docgen_context_getValue_contextCurrentDirectory/.docgen/$1" ]
          then
            docgen x errors contextError '%s\n%s\n%s' "Cannot use \`getValue\` to read collections, use \`getList\` instead: $1" "Location: $__docgen_context_getValue_contextCurrentDirectory" "Command: docgen ${__docgen__originalCliCommands[*]}"
            return 1
          else
            docgen x errors contextError '%s\n%s\n%s' "item not found: $1" "Location: $__docgen_context_getValue_contextCurrentDirectory" "Command: docgen ${__docgen__originalCliCommands[*]}"
            return 1
          fi
        ## @
  
            ;;
        ## @command docgen context goto
        "goto")
            local __docgen__mainCliCommandDepth="3"
            __docgen__mainCliCommands+=("$1")
            local __docgen__mainCliCommands_command3="$1"
            shift
            case "$__docgen__mainCliCommands_command3" in
              ## @command docgen context goto child
              "child")
                echo "GOTO CHILD $# [$*]"
                
                # Determine context identifier
                local __docgen_context_gotoChild_contextName=':default'
                [[ "$1" = ":"* ]] && { __docgen_context_gotoChild_contextName="$1"; shift; }
                
                # Get context current directory (this has the side-effect of asserting the validity of the context identifier)
                local __docgen_context_gotoChild_contextCurrentDirectory=''
                docgen context getDirectory "$__docgen_context_gotoChild_contextName" __docgen_context_gotoChild_contextCurrentDirectory || return $?
                
                # [ $# -eq 0 ] && { ... } # TODO
                
                if [ "$1" = ".docgen" ]
                then
                  docgen x errors contextError '%s\n%s\n\%s' "Cannot traverse into .docgen directories, use the available commands for reading .docgen files and folders" "Location: $__docgen_context_gotoChild_contextCurrentDirectory" "Command: docgen ${__docgen__originalCliCommands[*]}"
                  return 1
                fi
                
                if [ -d "$__docgen_context_gotoChild_contextCurrentDirectory/$1" ]
                then
                  # Find this context (asserting that it exists) - O(N) operation <-- which is done very frequently too. Please don't make many contexts!
                  local __docgen_context_gotoChild_contextSearchIndex=0
                  while [ "$__docgen_context_gotoChild_contextSearchIndex" -lt "${#_DOCGEN_CONTEXT_NAMES[@]}" ]
                  do
                    if [ "${_DOCGEN_CONTEXT_NAMES[$__docgen_context_gotoChild_contextSearchIndex]}" = "$__docgen_context_gotoChild_contextName" ]
                    then
                      _DOCGEN_CONTEXT_CURRENT_DIRECTORIES[$__docgen_context_gotoChild_contextSearchIndex]="$__docgen_context_gotoChild_contextCurrentDirectory/$1"
                      return 0
                    fi
                    : "$(( __docgen_context_gotoChild_contextSearchIndex++ ))"
                  done
                else
                  docgen x errors contextError '%s\n%s\n%s' "Child not found: $__docgen_context_gotoChild_contextCurrentDirectory/$1" "Location: $__docgen_context_gotoChild_contextCurrentDirectory" "Command: docgen ${__docgen__originalCliCommands[*]}"
                  return 1
                fi
              ## @
      
                  ;;
              ## @command docgen context goto parent
              "parent")
                # Determine context identifier
                local __docgen_context_gotoParent_contextName=':default'
                [[ "$1" = ":"* ]] && { __docgen_context_gotoParent_contextName="$1"; shift; }
                
                # Get context current directory (this has the side-effect of asserting the validity of the context identifier)
                local __docgen_context_gotoParent_contextCurrentDirectory=''
                docgen context getDirectory "$__docgen_context_gotoParent_contextName" __docgen_context_gotoParent_contextCurrentDirectory || return $?
                
                # [ $# -ne 0 ] && { ... } # TODO
              ## @
      
                  ;;
              ## @command docgen context goto path
              "path")
                # Determine context identifier
                local __docgen_context_gotoPath_contextName=':default'
                [[ "$1" = ":"* ]] && { __docgen_context_gotoPath_contextName="$1"; shift; }
                
                if [[ "$1" = *".docgen"* ]]
                then
                  docgen x errors contextError '%s\n%s\n\%s' "Cannot traverse into .docgen directories, use the available commands for reading .docgen files and folders" "Location: $__docgen_context_gotoChild_contextCurrentDirectory" "Command: docgen ${__docgen__originalCliCommands[*]}"
                  return 1
                fi
                
                # Find this context (asserting that it exists) - O(N) operation <-- which is done very frequently too. Please don't make many contexts!
                local __docgen_context_gotoPath_contextSearchIndex=0
                while [ "$__docgen_context_gotoPath_contextSearchIndex" -lt "${#_DOCGEN_CONTEXT_NAMES[@]}" ]
                do
                  if [ "${_DOCGEN_CONTEXT_NAMES[$__docgen_context_gotoPath_contextSearchIndex]}" = "$__docgen_context_gotoPath_contextName" ]
                  then
                    local __docgen_context_gotoPath_parseTreeRoot="${_DOCGEN_CONTEXT_PARSE_TREE_ROOTS[$__docgen_context_gotoPath_contextSearchIndex]}"
                    if [ -d "${__docgen_context_gotoPath_parseTreeRoot}/$1" ]
                    then
                      _DOCGEN_CONTEXT_CURRENT_DIRECTORIES[$__docgen_context_gotoPath_contextSearchIndex]="${__docgen_context_gotoPath_parseTreeRoot}/$1"
                      return 0
                    else
                      docgen x errors contextError '%s\n%s\n%s' "Path not found: ${__docgen_context_gotoPath_parseTreeRoot}/$1" "Location: $__docgen_context_gotoChild_contextCurrentDirectory" "Command: docgen ${__docgen__originalCliCommands[*]}"
                      return 1
                    fi
                  fi
                  : "$(( __docgen_context_gotoPath_contextSearchIndex++ ))"
                done
                
                return 1
              ## @
      
                  ;;
              ## @command docgen context goto root
              "root")
                # Determine context identifier
                local __docgen_context_gotoRoot_contextName=':default'
                [[ "$1" = ":"* ]] && { __docgen_context_gotoRoot_contextName="$1"; shift; }
                
                # Find this context (asserting that it exists) - O(N) operation <-- which is done very frequently too. Please don't make many contexts!
                local __docgen_context_gotoRoot_contextSearchIndex=0
                while [ "$__docgen_context_gotoRoot_contextSearchIndex" -lt "${#_DOCGEN_CONTEXT_NAMES[@]}" ]
                do
                  if [ "${_DOCGEN_CONTEXT_NAMES[$__docgen_context_gotoRoot_contextSearchIndex]}" = "$__docgen_context_gotoRoot_contextName" ]
                  then
                    _DOCGEN_CONTEXT_CURRENT_DIRECTORIES[$__docgen_context_gotoRoot_contextSearchIndex]="${_DOCGEN_CONTEXT_PARSE_TREE_ROOTS[$__docgen_context_gotoRoot_contextSearchIndex]}"
                    return 0
                  fi
                  : "$(( __docgen_context_gotoRoot_contextSearchIndex++ ))"
                done
                
                return 1
              ## @
      
                  ;;
              *)
                echo "Unknown 'docgen context goto' command: $__docgen__mainCliCommands_command3" >&2
                return 1
                ;;
            esac
        ## @
  
            ;;
        ## @command docgen context has
        "has")
          # Determine context identifier
          local __docgen_context_hasItem_contextName=':default'
          [[ "$1" = ":"* ]] && { __docgen_context_hasItem_contextName="$1"; shift; }
          
          # Get context current directory (this has the side-effect of asserting the validity of the context identifier)
          local __docgen_context_hasItem_contextCurrentDirectory=''
          docgen context getDirectory "$__docgen_context_hasItem_contextName" __docgen_context_hasItem_contextCurrentDirectory || return $?
          
          [ -e "$__docgen_context_hasItem_contextCurrentDirectory/.docgen/$1" ]
        ## @
  
            ;;
        *)
          if [ $# -eq 0 ]
          then
            docgen x errors argumentError '%s\n%s' "Context cannot be called with zero arguments" "Command: docgen ${__docgen__originalCliCommands[*]}"
            return 1
          fi
          
          local __docgen_context_root_availableProviderIndex=''
          for __docgen_context_root_availableProviderIndex in "${!DOCGEN_CONTEXT_PROVIDER_COMMANDS[@]}"
          do
            if [ "$__docgen__mainCliCommands_command2" = "${DOCGEN_CONTEXT_PROVIDER_COMMANDS[$__docgen_context_root_availableProviderIndex]}" ]
            then
              ${DOCGEN_CONTEXT_PROVIDERS_FUNCTIONS[$__docgen_context_root_availableProviderIndex]} "$@"
              return $?
            fi
          done
          
          docgen x errors contextError '%s\n%s' "Context provider not found: $1" "Command: docgen ${__docgen__originalCliCommands[*]}"
          return 1
          ;;
      esac
    ## @

        ;;
    ## @command docgen parseToTree
    "parseToTree")
      ## @param $@ Files and folders to extract documentation code comments from
      ##
      ## Some stuff
      ## - and whatnot
      ## - and things
      
      # TODO
      # $@ Files and folders to extract documentation code comments from
      
      # Public rendering variables (TODO document)
      [ -z "${_DOCGEN_PARSE_TREE_ROOT+x}" ] && _DOCGEN_PARSE_TREE_ROOT="$( mktemp -d )"
      
      [ "$DOCGEN_SILENCE" = false ] && echo "docgen.sh - Parsing Inputs to Output Directory Tree"
      [ "$DOCGEN_SILENCE" = false ] && echo "Output Directory: $_DOCGEN_PARSE_TREE_ROOT"
      
      while [ $# -gt 0 ]
      do
        if [ -f "$1" ]
        then
          local _DOCGEN_CURRENT_FILE="$1"
          [ "$DOCGEN_SILENCE" = false ] && echo "Input File: $_DOCGEN_CURRENT_FILE"
      
          # Get all of the file's lines
          local __docgen__fileLine
          declare -a _DOCGEN_CURRENT_FILE_LINES=()
          while IFS="" read -r __docgen__fileLine || [ -n "$__docgen__fileLine" ]
          do
            _DOCGEN_CURRENT_FILE_LINES+=("$__docgen__fileLine")
          done < "$1"
      
          # Loop through all of the file's lines
          _DOCGEN_CURRENT_CONTEXT=''
          _DOCGEN_CURRENT_FILE_LINES_CURSOR=0
          while [ "$_DOCGEN_CURRENT_FILE_LINES_CURSOR" -lt "${#_DOCGEN_CURRENT_FILE_LINES[@]}" ]
          do
            local __docgen__cursorBeforeRunningParsers="$_DOCGEN_CURRENT_FILE_LINES_CURSOR"
            local __docgen__parserReturnCode=''
      
            # Give each parser an opportunity to handle the current line
            local __docgen__parsingFunction=''
            for __docgen__parsingFunction in "${DOCGEN_PARSERS[@]}"
            do
              $__docgen__parsingFunction
              __docgen__parserReturnCode=$?
              if [ $__docgen__parserReturnCode -eq 0 ]
              then
                # A parser handled this and told us to proceed, skipping the others
                : "$(( _DOCGEN_CURRENT_FILE_LINES_CURSOR++ ))"
                break
              elif [ $__docgen__parserReturnCode -eq 2 ]
              then
                # Return code 2 from a parser means something broke, stop.
                [ "$DOCGEN_SILENCE" = false ] && echo "Parser Error, Stopping."
                return 2
              fi
            done
      
            # Skip this line if no parser handled it.
            if [ "$__docgen__cursorBeforeRunningParsers" = "$_DOCGEN_CURRENT_FILE_LINES_CURSOR" ]
            then
              : "$(( _DOCGEN_CURRENT_FILE_LINES_CURSOR++ ))"
            fi
          done
      
          unset _DOCGEN_CURRENT_FILE
          unset _DOCGEN_CURRENT_FILE_LINES
          unset _DOCGEN_CURRENT_FILE_LINES_CURSOR
          unset _DOCGEN_CURRENT_CONTEXT
      
        elif [ -d "$1" ]
        then
          local __docgen__file
          while read -rd '' __docgen__file
          do
            docgen parseToTree "$__docgen__file"
          done < <(find "$1" -type f -print0)
      
        else
          echo "docgen parseToTree error: expected all arguments to be files or folders, invalid argument: '$1'"
          return 1
        fi
      
        shift
      done
      
      [ "$DOCGEN_SILENCE" = false ] && echo "Completed."
    ## @

        ;;
    ## @command docgen parseTree
    ## This just adds some docs, that's all.
    "parseTree")
      local __docgen__mainCliCommandDepth="2"
      __docgen__mainCliCommands+=("$1")
      local __docgen__mainCliCommands_command2="$1"
      shift
      case "$__docgen__mainCliCommands_command2" in
        ## @command docgen parseTree getRoot
        "getRoot")
          if [ -n "$1" ]
          then
            printf -v "$1" "$_DOCGEN_PARSE_TREE_ROOT"
          else
            printf "$_DOCGEN_PARSE_TREE_ROOT"
          fi
        ## @
  
            ;;
        ## @command docgen parseTree setRoot
        "setRoot")
          ## $1 [String] Path to directory (must exist)
          ## @return 1 When the provided directory does not exist
          
          [ -d "$1" ] || { docgen x errors argumentError '%s\n%s' "Provided argument must be a directory that exists" "Command: docgen ${__docgen__originalCliCommands[*]}"; return 1; }
          
          _DOCGEN_PARSE_TREE_ROOT="$1"
        ## @
  
            ;;
        *)
          echo "Unknown 'docgen parseTree' command: $__docgen__mainCliCommands_command2" >&2
          return 1
          ;;
      esac
    ## @

        ;;
    ## @command docgen x
    "x")
      local __docgen__mainCliCommandDepth="2"
      __docgen__mainCliCommands+=("$1")
      local __docgen__mainCliCommands_command2="$1"
      shift
      case "$__docgen__mainCliCommands_command2" in
        ## @command docgen x context
        "context")
            local __docgen__mainCliCommandDepth="3"
            __docgen__mainCliCommands+=("$1")
            local __docgen__mainCliCommands_command3="$1"
            shift
            case "$__docgen__mainCliCommands_command3" in
              ## @command docgen x context clear
              "clear")
                _DOCGEN_CURRENT_CONTEXT=''
              ## @
      
                  ;;
              ## @command docgen x context DEPRECATED
              "DEPRECATED")
                > The `context` API is used by both templates and custom parsers
              ## @
      
                  ;;
              ## @command docgen x context get
              "get")
                [ -z "$_DOCGEN_CURRENT_CONTEXT" ] && return 1
                
                if [ -n "$1" ]
                then
                  printf -v "$1" "$_DOCGEN_CURRENT_CONTEXT"
                else
                  printf "$_DOCGEN_CURRENT_CONTEXT"
                fi
              ## @
      
                  ;;
              ## @command docgen x context isSet
              "isSet")
                [ -n "$_DOCGEN_CURRENT_CONTEXT" ]
              ## @
      
                  ;;
              ## @command docgen x context navigateTo
              "navigateTo")
                
              ## @
      
                  ;;
              ## @command docgen x context set
              "set")
                _DOCGEN_CURRENT_CONTEXT="$1"
              ## @
      
                  ;;
              ## @command docgen x context write
              "write")
                [ -z "$_DOCGEN_CURRENT_CONTEXT" ] && { docgen -- errors extensionError "'context write' failed, no current context set"; return 1; }
                
                local __docgen_x_context_write_contentDirectory="$_DOCGEN_PARSE_TREE_ROOT/$_DOCGEN_CURRENT_CONTEXT"
                
                mkdir -p "$__docgen_x_context_write_contentDirectory"
                
                if [ $# -eq 1 ]
                then
                  touch "$__docgen_x_context_write_contentDirectory/$1"
                else
                  local __docgen_x_context_write_subcontentName="$1"; shift
                  local __docgen_x_context_write_subcontentDirectory="${__docgen_x_context_write_subcontentName%/*}"
                  mkdir -p "$__docgen_x_context_write_contentDirectory/$__docgen_x_context_write_subcontentDirectory"
                  printf '%s' "$*" >> "$__docgen_x_context_write_contentDirectory/$__docgen_x_context_write_subcontentName"
                fi
              ## @
      
                  ;;
              *)
                echo "Unknown 'docgen x context' command: $__docgen__mainCliCommands_command3" >&2
                return 1
                ;;
            esac
        ## @
  
            ;;
        ## @command docgen x contextProviders
        "contextProviders")
            local __docgen__mainCliCommandDepth="3"
            __docgen__mainCliCommands+=("$1")
            local __docgen__mainCliCommands_command3="$1"
            shift
            case "$__docgen__mainCliCommands_command3" in
              ## @command docgen x contextProviders commands
              "commands")
                    local __docgen__mainCliCommandDepth="4"
                    __docgen__mainCliCommands+=("$1")
                    local __docgen__mainCliCommands_command4="$1"
                    shift
                    case "$__docgen__mainCliCommands_command4" in
                      ## @command docgen x contextProviders commands getDescription
                      "getDescription")
                        # Determine context identifier
                        local __docgen_x_contextProviders_commands_getDescription_contextName=':default'
                        [[ "$1" = ":"* ]] && { __docgen_x_contextProviders_commands_getDescription_contextName="$1"; shift; }
                        
                        # Get current path
                        local __docgen_x_contextProviders_commands_getDescription_currentPath=''
                        docgen context getPath "$__docgen_x_contextProviders_commands_getDescription_contextName" __docgen_x_contextProviders_commands_getDescription_currentPath
                        
                        # Get context current directory (this has the side-effect of asserting the validity of the context identifier)
                        local __docgen_x_contextProviders_commands_getDescription_currentDirectory=''
                        docgen context getDirectory "$__docgen_x_contextProviders_commands_getDescription_contextName" __docgen_x_contextProviders_commands_getDescription_currentDirectory || return $?
                        
                        # Does the existing path include commands? If so, print the children. They will be commands.
                        # And are we sitting in a directory that has an immediate .docgen child
                        if [[ "$__docgen_x_contextProviders_commands_getDescription_currentPath" = *"@commands"* ]] && [ -d "$__docgen_x_contextProviders_commands_getDescription_currentDirectory/.docgen" ]
                        then
                          docgen context getValue "description"
                        fi
                      ## @
            
                          ;;
                      ## @command docgen x contextProviders commands getName
                      "getName")
                        # Determine context identifier
                        local __docgen_x_contextProviders_commands_getName_contextName=':default'
                        [[ "$1" = ":"* ]] && { __docgen_x_contextProviders_commands_getName_contextName="$1"; shift; }
                        
                        # Get current path
                        local __docgen_x_contextProviders_commands_getName_currentPath=''
                        docgen context getPath "$__docgen_x_contextProviders_commands_getName_contextName" __docgen_x_contextProviders_commands_getName_currentPath
                        
                        # Get context current directory (this has the side-effect of asserting the validity of the context identifier)
                        local __docgen_x_contextProviders_commands_getName_currentDirectory=''
                        docgen context getDirectory "$__docgen_x_contextProviders_commands_getName_contextName" __docgen_x_contextProviders_commands_getName_currentDirectory || return $?
                        
                        # Does the existing path include commands? If so, print the children. They will be commands.
                        # And are we sitting in a directory that has an immediate .docgen child
                        if [[ "$__docgen_x_contextProviders_commands_getName_currentPath" = *"@commands"* ]] && [ -d "$__docgen_x_contextProviders_commands_getName_currentDirectory/.docgen" ]
                        then
                          docgen context getValue "fullName"
                        fi
                      ## @
            
                          ;;
                      ## @command docgen x contextProviders commands getParameterDescription
                      "getParameterDescription")
                        # Determine context identifier
                        local __docgen_x_contextProviders_commands_getParameterDescription_contextName=':default'
                        [[ "$1" = ":"* ]] && { __docgen_x_contextProviders_commands_getParameterDescription_contextName="$1"; shift; }
                        
                        if [ $# -eq 2 ]
                        then
                          docgen context getValue "$__docgen_x_contextProviders_commands_getParameterDescription_contextName" "parameters/$1" "$2"
                        else
                          docgen context getValue "$__docgen_x_contextProviders_commands_getParameterDescription_contextName" "parameters/$1"
                        fi
                      ## @
            
                          ;;
                      ## @command docgen x contextProviders commands getParameterNames
                      "getParameterNames")
                        # Determine context identifier
                        local __docgen_x_contextProviders_commands_getParameterNames_contextName=':default'
                        [[ "$1" = ":"* ]] && { __docgen_x_contextProviders_commands_getParameterNames_contextName="$1"; shift; }
                        
                        declare -a __docgen_x_contextProviders_commands_getParameterNames_parameterNameList=()
                        
                        docgen context getList "$__docgen_x_contextProviders_commands_getParameterNames_contextName" parameters __docgen_x_contextProviders_commands_getParameterNames_parameterNameList || return $?
                        
                        declare -a __docgen_x_contextProviders_commands_getParameterNames_positionalArguments=()
                        declare -a __docgen_x_contextProviders_commands_getParameterNames_specialArguments=()
                        
                        local __docgen_x_contextProviders_commands_getParameterNames_parameterName=''
                        for __docgen_x_contextProviders_commands_getParameterNames_parameterName in "${__docgen_x_contextProviders_commands_getParameterNames_parameterNameList[@]}"
                        do
                          if [ "$__docgen_x_contextProviders_commands_getParameterNames_parameterName" = '$@' ] || [ "$__docgen_x_contextProviders_commands_getParameterNames_parameterName" = '$*' ]
                          then
                            __docgen_x_contextProviders_commands_getParameterNames_specialArguments+=("$__docgen_x_contextProviders_commands_getParameterNames_parameterName")
                          else
                            __docgen_x_contextProviders_commands_getParameterNames_positionalArguments+=("$__docgen_x_contextProviders_commands_getParameterNames_parameterName")
                          fi
                        done
                        
                        [ -n "$1" ] && eval "$1=()"
                        
                        __docgen_x_contextProviders_commands_getParameterNames_parameterName=''
                        for __docgen_x_contextProviders_commands_getParameterNames_parameterName in "${__docgen_x_contextProviders_commands_getParameterNames_positionalArguments[@]}"
                        do
                          if [ -n "$1" ]
                          then
                            eval "$1+=(\"\$__docgen_x_contextProviders_commands_getParameterNames_parameterName\")"
                          else
                            echo "$__docgen_x_contextProviders_commands_getParameterNames_parameterName"
                          fi
                        done
                        
                        __docgen_x_contextProviders_commands_getParameterNames_parameterName=''
                        for __docgen_x_contextProviders_commands_getParameterNames_parameterName in "${__docgen_x_contextProviders_commands_getParameterNames_specialArguments[@]}"
                        do
                          if [ -n "$1" ]
                          then
                            eval "$1+=(\"\$__docgen_x_contextProviders_commands_getParameterNames_parameterName\")"
                          else
                            echo "$__docgen_x_contextProviders_commands_getParameterNames_parameterName"
                          fi
                        done
                      ## @
            
                          ;;
                      ## @command docgen x contextProviders commands listAll
                      "listAll")
                        # Determine context identifier
                        local __docgen_x_contextProviders_commands_listAll_contextName=':default'
                        [[ "$1" = ":"* ]] && { __docgen_x_contextProviders_commands_listAll_contextName="$1"; shift; }
                        
                        local __docgen_x_contextProviders_commands_listAll_currentPath=''
                        docgen context getPath "$__docgen_x_contextProviders_commands_listAll_contextName" __docgen_x_contextProviders_commands_listAll_currentPath
                        
                        # Get context current directory (this has the side-effect of asserting the validity of the context identifier)
                        local __docgen_x_contextProviders_commands_listAll_currentDirectory=''
                        docgen context getDirectory "$__docgen_x_contextProviders_commands_listAll_contextName" __docgen_x_contextProviders_commands_listAll_currentDirectory || return $?
                        
                        local __docgen_x_contextProviders_commands_listAll_anyCommands=false
                        
                        # Does the existing path include commands? If so, print the children. They will be commands.
                        # Does the existing path include commands? If so, print the children. They will be commands.
                        if [[ "$__docgen_x_contextProviders_commands_listAll_currentPath" = *"@commands"* ]]
                        then
                          local __docgen_x_contextProviders_commands_listAll_fullCommandNameFile=''
                          while read -rd '' __docgen_x_contextProviders_commands_listAll_fullCommandNameFile
                          do
                            __docgen_x_contextProviders_commands_listAll_anyCommands=true
                            local __docgen_x_contextProviders_commands_listAll_commandName="$(<"$__docgen_x_contextProviders_commands_listAll_fullCommandNameFile")"
                            if [ -n "$1" ]
                            then
                              eval "$1+=(\"\$__docgen_x_contextProviders_commands_listAll_commandName\")"
                            else
                              echo "$__docgen_x_contextProviders_commands_listAll_commandName"
                            fi
                          done < <( find "$__docgen_x_contextProviders_commands_listAll_currentDirectory" -type f -path "*/.docgen/fullName" -print0 | sort -z )
                        fi
                        
                        [ "$__docgen_x_contextProviders_commands_listAll_anyCommands" = true ]
                      ## @
            
                          ;;
                      ## @command docgen x contextProviders commands list
                      "list")
                        # Determine context identifier
                        local __docgen_x_contextProviders_commands_list_contextName=':default'
                        [[ "$1" = ":"* ]] && { __docgen_x_contextProviders_commands_list_contextName="$1"; shift; }
                        
                        # Get current path
                        local __docgen_x_contextProviders_commands_list_currentPath=''
                        docgen context getPath "$__docgen_x_contextProviders_commands_list_contextName" __docgen_x_contextProviders_commands_list_currentPath
                        
                        # Get context current directory (this has the side-effect of asserting the validity of the context identifier)
                        local __docgen_x_contextProviders_commands_list_currentDirectory=''
                        docgen context getDirectory "$__docgen_x_contextProviders_commands_list_contextName" __docgen_x_contextProviders_commands_list_currentDirectory || return $?
                        
                        local __docgen_x_contextProviders_commands_list_anyCommands=false
                        
                        # [ -n "$1" ] && eval "[ -z \"\${$1+x}\" ] && $1=()"
                        
                        # Does the existing path include commands? If so, print the children. They will be commands.
                        if [[ "$__docgen_x_contextProviders_commands_list_currentPath" = *"@commands"* ]]
                        then
                          local __docgen_x_contextProviders_commands_list_fullCommandNameFile=''
                          while read -rd '' __docgen_x_contextProviders_commands_list_fullCommandNameFile
                          do
                            [ "$__docgen_x_contextProviders_commands_list_currentDirectory/.docgen/fullName" = "$__docgen_x_contextProviders_commands_list_fullCommandNameFile" ] && continue
                            __docgen_x_contextProviders_commands_list_fullCommandNameFile="${__docgen_x_contextProviders_commands_list_fullCommandNameFile%/.docgen/fullName}"
                            __docgen_x_contextProviders_commands_list_anyCommands=true
                            # ... no, list the PATH of each one instead.
                            # local __docgen_x_contextProviders_commands_list_commandName="$(<"$__docgen_x_contextProviders_commands_list_fullCommandNameFile")"
                            local __docgen_x_contextProviders_commands_list_commandPath="$__docgen_x_contextProviders_commands_list_currentPath/${__docgen_x_contextProviders_commands_list_fullCommandNameFile##*/}"
                            if [ -n "$1" ]
                            then
                              eval "$1+=(\"\$__docgen_x_contextProviders_commands_list_commandPath\")"
                            else
                              echo "$__docgen_x_contextProviders_commands_list_commandPath"
                            fi
                          done < <( find "$__docgen_x_contextProviders_commands_list_currentDirectory" -maxdepth 3 -type f -path "*/.docgen/fullName" -print0 | sort -z )
                        fi
                        
                        [ "$__docgen_x_contextProviders_commands_list_anyCommands" = true ]
                      ## @
            
                          ;;
                      *)
                        echo "Unknown 'docgen x contextProviders commands' command: $__docgen__mainCliCommands_command4" >&2
                        return 1
                        ;;
                    esac
              ## @
      
                  ;;
              *)
                echo "Unknown 'docgen x contextProviders' command: $__docgen__mainCliCommands_command3" >&2
                return 1
                ;;
            esac
        ## @
  
            ;;
        ## @command docgen x errors
        "errors")
            local __docgen__mainCliCommandDepth="3"
            __docgen__mainCliCommands+=("$1")
            local __docgen__mainCliCommands_command3="$1"
            shift
            case "$__docgen__mainCliCommands_command3" in
              ## @command docgen x errors argumentError
              "argumentError")
                if [ $# -gt 0 ]
                then
                  printf '`docgen.sh` [ArgumentError] ' >&2
                  printf "$@" >&2
                else
                  printf '`docgen.sh` [ArgumentError]' >&2
                fi
                echo >&2
                docgen -- errors printStackTrace
              ## @
      
                  ;;
              ## @command docgen x errors contextError
              "contextError")
                if [ $# -gt 0 ]
                then
                  printf '`docgen.sh` [ContextError] ' >&2
                  printf "$@" >&2
                else
                  printf '`docgen.sh` [ContextError]' >&2
                fi
                echo >&2
                docgen -- errors printStackTrace
              ## @
      
                  ;;
              ## @command docgen x errors extensionError
              "extensionError")
                if [ $# -gt 0 ]
                then
                  printf '`docgen.sh` [ExtensionError] ' >&2
                  printf "$@" >&2
                else
                  printf '`docgen.sh` [ExtensionError]' >&2
                fi
                echo >&2
                docgen -- errors printStackTrace
              ## @
      
                  ;;
              ## @command docgen x errors getFileLine
              "getFileLine")
                  ## ## `utils getFileLine`
                  ##
                  ## Get the specified line from the specified file.
                  ##
                  ## > ℹ️ Used by `mocks -- error` to print LOC in stacktrace.
                  ##
                  ## | | Parameter  |
                  ## |-|------------|
                  ## | `$1` | Path to the file |
                  ## | `$2` | Line to print |
                  ##
                  if [ "$2" = "0" ]
                  then
                    sed "1q;d" "$1" | sed 's/^ *//g'
                  else
                    sed "${2}q;d" "$1" | sed 's/^ *//g'
                  fi
              ## @
      
                  ;;
              ## @command docgen x errors parserWarning
              "parserWarning")
                if [ $# -gt 0 ]
                then
                  printf '`docgen.sh` [Parser Warning] ' >&2
                  printf "$@" >&2
                else
                  printf '`docgen.sh` [Parser Warning]' >&2
                fi
                echo >&2
                docgen -- errors printStackTrace
              ## @
      
                  ;;
              ## @command docgen x errors printStackTrace
              "printStackTrace")
                ## | `$1` | (_Optional_) How many levels to skip (default: `2`) |
                ## | `$2` | (_Optional_) How many levels deep to show (default: `100`) |
                
                local __docgen__x_errors_printStackTrace_levelsToSkip="${1-3}"
                local __docgen__x_errors_printStackTrace_levelsToShow="${2-100}"
                
                if [ "$DOCGEN_SILENCE" != "true" ]
                then
                  echo >&2
                  echo >&2
                  echo "Stacktrace:" >&2
                  echo >&2
                  local __docgen__i=1
                  local __docgen__stackIndex="$__docgen__x_errors_printStackTrace_levelsToSkip"
                  while [ $__docgen__stackIndex -lt ${#BASH_SOURCE[@]} ] && [ $__docgen__i -lt $__docgen__x_errors_printStackTrace_levelsToShow ]
                  do
                    local __docgen__errors_printStackTrace_line=''
                    __docgen__errors_printStackTrace_line="$( echo "$(docgen -- errors getFileLine "${BASH_SOURCE[$__docgen__stackIndex]}" "${BASH_LINENO[$(( __docgen__stackIndex - 1 ))]}")" | sed 's/^/    /' 2>&1 )"
                    # Catches sed errors
                    if [ $? -eq 0 ]
                    then
                      echo "${BASH_SOURCE[$__docgen__stackIndex]}:${BASH_LINENO[$__docgen__stackIndex]} ${FUNCNAME[$__docgen__stackIndex]}():" >&2
                      echo "  $__docgen__errors_printStackTrace_line" >&2
                    else
                      echo "${BASH_SOURCE[$__docgen__stackIndex]}:${BASH_LINENO[$__docgen__stackIndex]} ${FUNCNAME[$__docgen__stackIndex]}()" >&2
                    fi
                    echo >&2
                    : "$(( __docgen__stackIndex++ ))"
                    : "$(( __docgen__i++ ))"
                  done
                fi
              ## @
      
                  ;;
              *)
                echo "Unknown 'docgen x errors' command: $__docgen__mainCliCommands_command3" >&2
                return 1
                ;;
            esac
        ## @
  
            ;;
        ## @command docgen x lines
        "lines")
            local __docgen__mainCliCommandDepth="3"
            __docgen__mainCliCommands+=("$1")
            local __docgen__mainCliCommands_command3="$1"
            shift
            case "$__docgen__mainCliCommands_command3" in
              ## @command docgen x lines current
              "current")
                    local __docgen__mainCliCommandDepth="4"
                    __docgen__mainCliCommands+=("$1")
                    local __docgen__mainCliCommands_command4="$1"
                    shift
                    case "$__docgen__mainCliCommands_command4" in
                      ## @command docgen x lines current getDecoratorName
                      "getDecoratorName")
                        [ "$_DOCGEN_CURRENT_FILE_LINES_CURSOR" -ge 0 ] || return 1
                        [ "$_DOCGEN_CURRENT_FILE_LINES_CURSOR" -lt "${#_DOCGEN_CURRENT_FILE_LINES[@]}" ] || return 1
                        
                        if [[ "${_DOCGEN_CURRENT_FILE_LINES[$_DOCGEN_CURRENT_FILE_LINES_CURSOR]}" =~ $DOCGEN_DECORATOR_NAME_PATTERN ]]
                        then
                          if [ -n "$1" ]
                          then
                            printf -v "$1" -- "${BASH_REMATCH[$DOCGEN_DECORATOR_NAME_PATTERN_CAPTURE_GROUP]}"
                          else
                            printf -- "${BASH_REMATCH[$DOCGEN_DECORATOR_NAME_PATTERN_CAPTURE_GROUP]}"
                          fi
                        else
                          return 1
                        fi
                      ## @
            
                          ;;
                      ## @command docgen x lines current getDecoratorValue
                      "getDecoratorValue")
                        [ "$_DOCGEN_CURRENT_FILE_LINES_CURSOR" -ge 0 ] || return 1
                        [ "$_DOCGEN_CURRENT_FILE_LINES_CURSOR" -lt "${#_DOCGEN_CURRENT_FILE_LINES[@]}" ] || return 1
                        
                        if [[ "${_DOCGEN_CURRENT_FILE_LINES[$_DOCGEN_CURRENT_FILE_LINES_CURSOR]}" =~ $DOCGEN_DECORATOR_VALUE_PATTERN ]]
                        then
                          if [ -n "$1" ]
                          then
                            printf -v "$1" -- "${BASH_REMATCH[$DOCGEN_DECORATOR_VALUE_PATTERN_CAPTURE_GROUP]}"
                          else
                            printf -- "${BASH_REMATCH[$DOCGEN_DECORATOR_VALUE_PATTERN_CAPTURE_GROUP]}"
                          fi
                        else
                          return 1
                        fi
                      ## @
            
                          ;;
                      ## @command docgen x lines current getDocumentation
                      "getDocumentation")
                        [ "$_DOCGEN_CURRENT_FILE_LINES_CURSOR" -ge 0 ] || return 1
                        [ "$_DOCGEN_CURRENT_FILE_LINES_CURSOR" -lt "${#_DOCGEN_CURRENT_FILE_LINES[@]}" ] || return 1
                        
                        if [[ "${_DOCGEN_CURRENT_FILE_LINES[$_DOCGEN_CURRENT_FILE_LINES_CURSOR]}" =~ $DOCGEN_DOCUMENTATION_PATTERN ]]
                        then
                          if [ -n "$1" ]
                          then
                            printf -v "$1" -- "${BASH_REMATCH[$DOCGEN_DOCUMENTATION_PATTERN_CAPTURE_GROUP]}"
                          else
                            printf -- "${BASH_REMATCH[$DOCGEN_DOCUMENTATION_PATTERN_CAPTURE_GROUP]}"
                          fi
                        else
                          return 1
                        fi
                      ## @
            
                          ;;
                      ## @command docgen x lines current getText
                      "getText")
                        [ "$_DOCGEN_CURRENT_FILE_LINES_CURSOR" -ge 0 ] || return 1
                        [ "$_DOCGEN_CURRENT_FILE_LINES_CURSOR" -lt "${#_DOCGEN_CURRENT_FILE_LINES[@]}" ] || return 1
                        
                        if [ -n "$1" ]
                        then
                          printf -v "$1" '%s' "${_DOCGEN_CURRENT_FILE_LINES[$_DOCGEN_CURRENT_FILE_LINES_CURSOR]}"
                        else
                          printf '%s' "${_DOCGEN_CURRENT_FILE_LINES[$_DOCGEN_CURRENT_FILE_LINES_CURSOR]}"
                        fi
                      ## @
            
                          ;;
                      ## @command docgen x lines current isDocumentation
                      "isDocumentation")
                        [ "$_DOCGEN_CURRENT_FILE_LINES_CURSOR" -ge 0 ] || return 1
                        [ "$_DOCGEN_CURRENT_FILE_LINES_CURSOR" -lt "${#_DOCGEN_CURRENT_FILE_LINES[@]}" ] || return 1
                        
                        [[ "${_DOCGEN_CURRENT_FILE_LINES[$_DOCGEN_CURRENT_FILE_LINES_CURSOR]}" =~ $DOCGEN_DOCUMENTATION_PATTERN ]]
                      ## @
            
                          ;;
                      *)
                        [ "$_DOCGEN_CURRENT_FILE_LINES_CURSOR" -ge 0 ] || return 1
                        [ "$_DOCGEN_CURRENT_FILE_LINES_CURSOR" -lt "${#_DOCGEN_CURRENT_FILE_LINES[@]}" ] || return 1
                        ;;
                    esac
              ## @
      
                  ;;
              ## @command docgen x lines getCursor
              "getCursor")
                printf "$_DOCGEN_CURRENT_FILE_LINES_CURSOR"
              ## @
      
                  ;;
              ## @command docgen x lines getFilePath
              "getFilePath")
                printf "$_DOCGEN_CURRENT_FILE"
              ## @
      
                  ;;
              ## @command docgen x lines gotoNext
              "gotoNext")
                [ "$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR + 1 ))" -lt "${#_DOCGEN_CURRENT_FILE_LINES[@]}" ] || return 1
                
                : "$(( _DOCGEN_CURRENT_FILE_LINES_CURSOR++ ))"
              ## @
      
                  ;;
              ## @command docgen x lines gotoPrevious
              "gotoPrevious")
                [ "$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR - 1 ))" -gt 0 ] || return 1
                
                : "$(( _DOCGEN_CURRENT_FILE_LINES_CURSOR-- ))"
              ## @
      
                  ;;
              ## @command docgen x lines next
              "next")
                    local __docgen__mainCliCommandDepth="4"
                    __docgen__mainCliCommands+=("$1")
                    local __docgen__mainCliCommands_command4="$1"
                    shift
                    case "$__docgen__mainCliCommands_command4" in
                      ## @command docgen x lines next getDecoratorName
                      "getDecoratorName")
                        [ "$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR + 1 ))" -lt "${#_DOCGEN_CURRENT_FILE_LINES[@]}" ] || return 1
                        
                        if [[ "${_DOCGEN_CURRENT_FILE_LINES["$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR + 1 ))"]}" =~ $DOCGEN_DECORATOR_NAME_PATTERN ]]
                        then
                          if [ -n "$1" ]
                          then
                            printf -v "$1" -- "${BASH_REMATCH[$DOCGEN_DECORATOR_NAME_PATTERN_CAPTURE_GROUP]}"
                          else
                            printf -- "${BASH_REMATCH[$DOCGEN_DECORATOR_NAME_PATTERN_CAPTURE_GROUP]}"
                          fi
                        else
                          return 1
                        fi
                      ## @
            
                          ;;
                      ## @command docgen x lines next getDecoratorValue
                      "getDecoratorValue")
                        [ "$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR + 1 ))" -lt "${#_DOCGEN_CURRENT_FILE_LINES[@]}" ] || return 1
                        
                        if [[ "${_DOCGEN_CURRENT_FILE_LINES["$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR + 1 ))"]}" =~ $DOCGEN_DECORATOR_VALUE_PATTERN ]]
                        then
                          printf -- "${BASH_REMATCH[$DOCGEN_DECORATOR_VALUE_PATTERN_CAPTURE_GROUP]}"
                        else
                          return 1
                        fi
                      ## @
            
                          ;;
                      ## @command docgen x lines next getDocumentation
                      "getDocumentation")
                        [ "$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR + 1 ))" -lt "${#_DOCGEN_CURRENT_FILE_LINES[@]}" ] || return 1
                        
                        if [[ "${_DOCGEN_CURRENT_FILE_LINES["$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR + 1 ))"]}" =~ $DOCGEN_DOCUMENTATION_PATTERN ]]
                        then
                          if [ -n "$1" ]
                          then
                            printf -v "$1" -- "${BASH_REMATCH[$DOCGEN_DOCUMENTATION_PATTERN_CAPTURE_GROUP]}"
                          else
                            printf -- "${BASH_REMATCH[$DOCGEN_DOCUMENTATION_PATTERN_CAPTURE_GROUP]}"
                          fi
                        else
                          return 1
                        fi
                      ## @
            
                          ;;
                      ## @command docgen x lines next getText
                      "getText")
                        [ "$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR + 1 ))" -lt "${#_DOCGEN_CURRENT_FILE_LINES[@]}" ] || return 1
                        
                        printf -- "${_DOCGEN_CURRENT_FILE_LINES["$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR + 1 ))"]}"
                      ## @
            
                          ;;
                      ## @command docgen x lines next isDocumentation
                      "isDocumentation")
                        [ "$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR + 1 ))" -lt "${#_DOCGEN_CURRENT_FILE_LINES[@]}" ] || return 1
                        
                        [[ "${_DOCGEN_CURRENT_FILE_LINES["$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR + 1 ))"]}" =~ $DOCGEN_DOCUMENTATION_PATTERN ]]
                      ## @
            
                          ;;
                      *)
                        [ "$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR + 1 ))" -lt "${#_DOCGEN_CURRENT_FILE_LINES[@]}" ] || return 1
                        ;;
                    esac
              ## @
      
                  ;;
              ## @command docgen x lines previous
              "previous")
                    local __docgen__mainCliCommandDepth="4"
                    __docgen__mainCliCommands+=("$1")
                    local __docgen__mainCliCommands_command4="$1"
                    shift
                    case "$__docgen__mainCliCommands_command4" in
                      ## @command docgen x lines previous getDecoratorName
                      "getDecoratorName")
                        [ "$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR - 1 ))" -ge 0 ] || return 1
                        
                        if [[ "${_DOCGEN_CURRENT_FILE_LINES["$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR - 1 ))"]}" =~ $DOCGEN_DECORATOR_NAME_PATTERN ]]
                        then
                          printf -- "${BASH_REMATCH[$DOCGEN_DECORATOR_NAME_PATTERN_CAPTURE_GROUP]}"
                        else
                          return 1
                        fi
                      ## @
            
                          ;;
                      ## @command docgen x lines previous getDecoratorValue
                      "getDecoratorValue")
                        [ "$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR - 1 ))" -ge 0 ] || return 1
                        
                        if [[ "${_DOCGEN_CURRENT_FILE_LINES["$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR - 1 ))"]}" =~ $DOCGEN_DECORATOR_VALUE_PATTERN ]]
                        then
                          printf -- "${BASH_REMATCH[$DOCGEN_DECORATOR_VALUE_PATTERN_CAPTURE_GROUP]}"
                        else
                          return 1
                        fi
                      ## @
            
                          ;;
                      ## @command docgen x lines previous getDocumentation
                      "getDocumentation")
                        [ "$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR - 1 ))" -ge 0 ] || return 1
                        
                        if [[ "${_DOCGEN_CURRENT_FILE_LINES["$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR - 1 ))"]}" =~ $DOCGEN_DOCUMENTATION_PATTERN ]]
                        then
                          printf -- "${BASH_REMATCH[$DOCGEN_DOCUMENTATION_PATTERN_CAPTURE_GROUP]}"
                        else
                          return 1
                        fi
                      ## @
            
                          ;;
                      ## @command docgen x lines previous getText
                      "getText")
                        [ "$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR - 1 ))" -ge 0 ] || return 1
                        
                        printf -- "${_DOCGEN_CURRENT_FILE_LINES["$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR - 1 ))"]}"
                      ## @
            
                          ;;
                      ## @command docgen x lines previous isDocumentation
                      "isDocumentation")
                        [ "$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR - 1 ))" -ge 0 ] || return 1
                        
                        [[ "${_DOCGEN_CURRENT_FILE_LINES["$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR - 1 ))"]}" =~ $DOCGEN_DOCUMENTATION_PATTERN ]]
                      ## @
            
                          ;;
                      *)
                        [ "$(( $_DOCGEN_CURRENT_FILE_LINES_CURSOR - 1 ))" -ge 0 ] || return 1
                        ;;
                    esac
              ## @
      
                  ;;
              *)
                echo "Unknown 'docgen x lines' command: $__docgen__mainCliCommands_command3" >&2
                return 1
                ;;
            esac
        ## @
  
            ;;
        *)
          echo "Unknown 'docgen x' command: $__docgen__mainCliCommands_command2" >&2
          return 1
          ;;
      esac
    ## @

        ;;
    *)
      echo "Unknown 'docgen' command: $__docgen__mainCliCommands_command1" >&2
      ;;
  esac

}

[ "${BASH_SOURCE[0]}" = "$0" ] && "docgen" "$@"

