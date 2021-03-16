# Undocumented option, get the code for the template without evaluating it: --code
local __shx__printCodeOnly=false
[ "$1" = "--code" ] && { __shx__printCodeOnly=true; shift; }

# Shift so that templates can properly read in provided "$1" "$@" etc to the `render` function
local __shx__providedTemplate="$1"; shift

[ -f "$__shx__providedTemplate" ] && __shx__providedTemplate="$(<"$__shx__providedTemplate")"

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
    [ "$__shx__codeBlockDefinitionOpen" = true ] && { echo "FN [RenderError] <%= was started but there is a <% block already open with content: '$__shx__codeBlockDefinition'" >&2; return 1; }
    [ "$__shx__valueBlockOpen" = true ] && { echo "FN [RenderError] <%= was started but there is another <%= already open with content: '$__shx__valueBlock'" >&2; return 1; }
    __shx__valueBlockOpen=true
    __shx__stringBuilderComplete=true
    : "$(( __shx__cursor += 2 ))"
  elif [ "${__shx__providedTemplate:$__shx__cursor:2}" = "<%" ]
  then
    [ "$__shx__codeBlockDefinitionOpen" = true ] && { echo "FN [RenderError] %> block was closed but there is another <% currently open with content: '$__shx__codeBlockDefinition'" >&2; return 1; }
    [ "$__shx__valueBlockOpen" = true ] && { echo "FN [RenderError] %> block was closed but there is a <%= currently open with content: '$__shx__valueBlock'" >&2; return 1; }
    __shx__codeBlockDefinitionOpen=true
    __shx__stringBuilderComplete=true
    : "$(( __shx__cursor++ ))"
  elif [ "${__shx__providedTemplate:$__shx__cursor:3}" = "-%>" ]
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
      echo "FN [RenderError] unexpected %> encountered, no <% or <%= blocks are currently open" >&2
      return 1
    fi
    : "$(( __shx__cursor += 3 ))"
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
      echo "FN [RenderError] unexpected %> encountered, no <% or <%= blocks are currently open" >&2
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
    __shx__stringBuilderComplete=false
    if [ -n "$__shx__stringBuilder" ]
    then
      : "$(( __shx__heredocCount++ ))"
      __shx__outputScriptToEval+="\nIFS= read -r -d '' __SHX_HEREDOC_$__shx__heredocCount<< 'SHX_PRINT_BLOCK'\n"
      __shx__outputScriptToEval+="$__shx__stringBuilder"
      __shx__outputScriptToEval+="\nSHX_PRINT_BLOCK"
      __shx__outputScriptToEval+="\nprintf '%%s' \"\${__SHX_HEREDOC_$__shx__heredocCount%%\"\n\"}\""
      __shx__outputScriptToEval+="\nunset __SHX_HEREDOC_$__shx__heredocCount"
      __shx__stringBuilder=''
    fi
  fi

  : "$(( __shx__cursor++ ))"
done

if [ -n "$__shx__stringBuilder" ]
then
    __shx__outputScriptToEval+="\nIFS= read -r -d '' __SHX_HEREDOC_$__shx__heredocCount<< 'SHX_PRINT_BLOCK'\n"
  __shx__outputScriptToEval+="$__shx__stringBuilder"
  __shx__outputScriptToEval+="\nSHX_PRINT_BLOCK"
  __shx__outputScriptToEval+="\nprintf '%%s' \"\${__SHX_HEREDOC_$__shx__heredocCount%%\"\n\"}\""
  __shx__outputScriptToEval+="\nunset \__SHX_HEREDOC_$__shx__heredocCount"
  __shx__stringBuilder=''
fi

[ "$__shx__codeBlockDefinitionOpen" = true ] && { echo "FN [RenderError] <% block was not closed: '$__shx__codeBlockDefinition'" >&2; return 1; }
[ "$__shx__valueBlockOpen" = true ] && { echo "FN [RenderError] <%= was not closed: '$__shx__valueBlock'" >&2; return 1; }

local readyToEval="$( printf -- "$__shx__outputScriptToEval" )"

if [ "$__shx__printCodeOnly" = true ]
then
  echo "$readyToEval"
  return 0
fi

unset __shx__cursor
unset __shx__outputScriptToEval
unset __shx__stringBuilder
unset __shx__stringBuilderComplete
unset __shx__valueBlock
unset __shx__valueBlockOpen
unset __shx__codeBlockDefinition
unset __shx__codeBlockDefinitionOpen
unset __shx__heredocCount
unset __shx__printCodeOnly

eval "$readyToEval"