#! /usr/bin/env bash

shx() {
  declare -a __shx__mainCliCommands=("shx")
  declare -a __shx__originalCliCommands=("$@")

  local __shx__mainCliCommandDepth="1"
  __shx__mainCliCommands+=("$1")
  local __shx__mainCliCommands_command1="$1"
  shift
  case "$__shx__mainCliCommands_command1" in
    "--")
      local __shx__mainCliCommandDepth="2"
      __shx__mainCliCommands+=("$1")
      local __shx__mainCliCommands_command2="$1"
      shift
      case "$__shx__mainCliCommands_command2" in
        "getCodeToEval")
          # Shift so that templates can properly read in provided "$1" "$@" etc to the `render` function
          local __shx__providedTemplate="$1"; shift
          
          # Like most similar implementations across programming languages,
          # the template render process builds up a script with lots of printf
          # statements alongside the <% shell source %> code to run and
          # then the result is created by evaluating the script.
          #
          # This is _not_ a side-effect-free/safe templating engine a la Liquid and friends
          #
          local __shx__outputScriptToEval=''
          
          local __shx__stringBuilder=''
          local __shx__stringBuilderComplete=false
          
          local __shx__valueBlock=''
          local __shx__valueBlockOpen=false
          
          local __shx__codeBlockDefinition=''
          local __shx__codeBlockDefinitionOpen=false
          
          local __shx__heredocCount=0
          
          # We legit loop thru all the characters.
          local __shx__cursor=0
          while [ "$__shx__cursor" -lt "${#__shx__providedTemplate}" ]
          do
            if [ "${__shx__providedTemplate:$__shx__cursor:3}" = "<%=" ]
            then
              __shx__valueBlockOpen=true
              __shx__stringBuilderComplete=true
              : "$(( __shx__cursor += 2 ))"
            elif [ "${__shx__providedTemplate:$__shx__cursor:2}" = "<%" ]
            then
              __shx__codeBlockDefinitionOpen=true
              __shx__stringBuilderComplete=true
              : "$(( __shx__cursor++ ))"
            elif [ "${__shx__providedTemplate:$__shx__cursor:2}" = "%>" ]
            then
              if [ "$__shx__valueBlockOpen" = true ]
              then
                __shx__valueBlockOpen=false
                __shx__valueBlock="${__shx__valueBlock# }"
                __shx__outputScriptToEval+="\nprintf '%%s' \"${__shx__valueBlock% }\"\n"
                __shx__valueBlock=''
              elif [ "$__shx__codeBlockDefinitionOpen" = true ]
              then
                __shx__codeBlockDefinitionOpen=false
                __shx__codeBlockDefinition="${__shx__codeBlockDefinition# }"
                __shx__outputScriptToEval+="\n${__shx__codeBlockDefinition% }\n"
                __shx__codeBlockDefinition=''
              else
                echo "Unexpected %>"
                return 1
              fi
              : "$(( __shx__cursor++ ))"
            elif [ "$__shx__valueBlockOpen" = true ]
            then
              __shx__valueBlock+="${__shx__providedTemplate:$__shx__cursor:1}"
            elif [ "$__shx__codeBlockDefinitionOpen" = true ]
            then
              __shx__codeBlockDefinition+="${__shx__providedTemplate:$__shx__cursor:1}"
            else 
              __shx__stringBuilder+="${__shx__providedTemplate:$__shx__cursor:1}"
            fi
          
            if [ "$__shx__stringBuilderComplete" = true ]
            then
              : "$(( __shx__heredocCount++ ))"
              __shx__outputScriptToEval+="\nIFS=\$'\\n' read -r -d '' __SHX_HEREDOC_$__shx__heredocCount<< 'SHX_PRINT_BLOCK'\n"
              __shx__outputScriptToEval+="$__shx__stringBuilder"
              __shx__outputScriptToEval+="\nSHX_PRINT_BLOCK"
              __shx__outputScriptToEval+="\nprintf '%%s' \"\$__SHX_HEREDOC_$__shx__heredocCount\""
              __shx__stringBuilder=''
              __shx__stringBuilderComplete=false
            fi
          
            : "$(( __shx__cursor++ ))"
          done
          
          if [ -n "$__shx__stringBuilder" ]
          then
              __shx__outputScriptToEval+="\nIFS=\$'\\n' read -r -d '' __SHX_HEREDOC_$__shx__heredocCount<< 'SHX_PRINT_BLOCK'\n"
            __shx__outputScriptToEval+="$__shx__stringBuilder"
            __shx__outputScriptToEval+="\nSHX_PRINT_BLOCK"
            __shx__outputScriptToEval+="\nprintf '%%s' \"\$__SHX_HEREDOC_$__shx__heredocCount\""
          fi
          
          printf "$__shx__outputScriptToEval"
  
            ;;
        *)
          echo "Unknown 'shx --' command: $__shx__mainCliCommands_command2" >&2
          return 1
          ;;
      esac

        ;;
    "render")
      # Shift so that templates can properly read in provided "$1" "$@" etc to the `render` function
      local __shx__providedTemplate="$1"; shift
      
      # Like most similar implementations across programming languages,
      # the template render process builds up a script with lots of printf
      # statements alongside the <% shell source %> code to run and
      # then the result is created by evaluating the script.
      #
      # This is _not_ a side-effect-free/safe templating engine a la Liquid and friends
      #
      local __shx__outputScriptToEval=''
      
      local __shx__stringBuilder=''
      local __shx__stringBuilderComplete=false
      
      local __shx__valueBlock=''
      local __shx__valueBlockOpen=false
      
      local __shx__codeBlockDefinition=''
      local __shx__codeBlockDefinitionOpen=false
      
      local __shx__heredocCount=0
      
      local __shx__newline=$'\n'
      
      # We legit loop thru all the characters.
      local __shx__cursor=0
      while [ "$__shx__cursor" -lt "${#__shx__providedTemplate}" ]
      do
        if [ "${__shx__providedTemplate:$__shx__cursor:3}" = "<%=" ]
        then
          __shx__valueBlockOpen=true
          __shx__stringBuilderComplete=true
          : "$(( __shx__cursor += 2 ))"
        elif [ "${__shx__providedTemplate:$__shx__cursor:2}" = "<%" ]
        then
          __shx__codeBlockDefinitionOpen=true
          __shx__stringBuilderComplete=true
          : "$(( __shx__cursor++ ))"
        elif [ "${__shx__providedTemplate:$__shx__cursor:2}" = "%>" ]
        then
          if [ "$__shx__valueBlockOpen" = true ]
          then
            __shx__valueBlockOpen=false
            __shx__valueBlock="${__shx__valueBlock# }"
            __shx__outputScriptToEval+="printf '%s' \"${__shx__valueBlock% }\"${__shx__newline}"
            __shx__valueBlock=''
          elif [ "$__shx__codeBlockDefinitionOpen" = true ]
          then
            __shx__codeBlockDefinitionOpen=false
            __shx__codeBlockDefinition="${__shx__codeBlockDefinition# }"
            __shx__outputScriptToEval+="${__shx__newline}${__shx__codeBlockDefinition% }${__shx__newline}"
            __shx__codeBlockDefinition=''
          else
            echo "Unexpected %>"
            return 1
          fi
          : "$(( __shx__cursor++ ))"
        elif [ "$__shx__valueBlockOpen" = true ]
        then
          __shx__valueBlock+="${__shx__providedTemplate:$__shx__cursor:1}"
        elif [ "$__shx__codeBlockDefinitionOpen" = true ]
        then
          __shx__codeBlockDefinition+="${__shx__providedTemplate:$__shx__cursor:1}"
        else 
          __shx__stringBuilder+="${__shx__providedTemplate:$__shx__cursor:1}"
        fi
      
        if [ "$__shx__stringBuilderComplete" = true ]
        then
          : "$(( __shx__heredocCount++ ))"
          __shx__outputScriptToEval+="IFS='${__shx__newline}' read -r -d '' __SHX_HEREDOC_$__shx__heredocCount << 'SHX_PRINT_BLOCK'$__shx__newline"
          __shx__outputScriptToEval+="$__shx__stringBuilder"
          __shx__outputScriptToEval+="${__shx__newline}SHX_PRINT_BLOCK${__shx__newline}"
          __shx__outputScriptToEval+="printf '%s' \"\$__SHX_HEREDOC_$__shx__heredocCount\"${__shx__newline}"
          __shx__stringBuilder=''
          __shx__stringBuilderComplete=false
        fi
      
        : "$(( __shx__cursor++ ))"
      done
      
      if [ -n "$__shx__stringBuilder" ]
      then
          __shx__outputScriptToEval+="IFS='${__shx__newline}' read -r -d '' __SHX_HEREDOC_$__shx__heredocCount << 'SHX_PRINT_BLOCK'$__shx__newline"
        __shx__outputScriptToEval+="$__shx__stringBuilder${__shx__newline}"
        __shx__outputScriptToEval+="${__shx__newline}SHX_PRINT_BLOCK${__shx__newline}"
        __shx__outputScriptToEval+="printf '%s' \"\$__SHX_HEREDOC_$__shx__heredocCount\"${__shx__newline}"
      fi
      
      eval "$__shx__outputScriptToEval"
      
      # cat -A -n <<< "$__shx__outputScriptToEval"

        ;;
    *)
      echo "Unknown 'shx' command: $__shx__mainCliCommands_command1" >&2
      ;;
  esac

}

[ "${BASH_SOURCE[0]}" = "$0" ] && "shx" "$@"

