## @param $1 Template to compile (_string or path to file_)<br><br>
## @param $1 The first wo arguments may be `--out` `[variableName]`,
## @param $1 in which case the compiled result will _not_ be
## @param $1 printed and will instead be assigned to the provided variable.
## @param $3 Template to compile (_string or path to file_)<br>if `$1` and `$2` are `--out` `[variableName]` respectively
##
## Compiles a provided template to a result which can be stored and
## later evaluated via [`shx evaluate`](#shx-evaluate).
##
## This allows you to perform template parsing only once and
## evaluate templates without the computational penalty of parsing.
##
## > Note: alternatively you may want to consider [Template caching](#template-caching)
##
## @example Compile Template
##   template="<h1><%%= $1 %%></h1>"
##   compiledTemplate="$( shx compile "$template" )"
##   
##   # Later ...
##   
##   shx evaluate "$compiledTemplate" "My Title"
##   # => "<h1>My Title</h1>"
##
## @example Store in Variable
##   template="<h1><%%= $1 %%></h1>"
##   shx compile "$template" compiledTemplate
##   # ^--- the compilated template is stored in $compiledTemplate
##   
##   # Later ...
##   
##   shx evaluate "$compiledTemplate" "My Title"
##   # => "<h1>My Title</h1>"
##

local __shx__outVariableName=''
[ "$1" = "--out" ] && { shift; __shx__outVariableName="$1"; shift; }

# Undocumented option, get the code for the template without evaluating it: --code
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
local __shx__newLine=$'\n'

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
      __shx__outputScriptToEval+="${__shx__newLine}printf '%s' \"${__shx__valueBlock% }\"${__shx__newLine}"
      __shx__valueBlock=''
    elif [ "$__shx__codeBlockDefinitionOpen" = true ]
    then
      __shx__codeBlockDefinitionOpen=false
      __shx__codeBlockDefinition="${__shx__codeBlockDefinition# }"
      __shx__outputScriptToEval+="${__shx__newLine}${__shx__codeBlockDefinition% }${__shx__newLine}"
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
      __shx__outputScriptToEval+="${__shx__newLine}printf '%s' \"${__shx__valueBlock% }\"${__shx__newLine}"
      __shx__valueBlock=''
    elif [ "$__shx__codeBlockDefinitionOpen" = true ]
    then
      __shx__codeBlockDefinitionOpen=false
      __shx__codeBlockDefinition="${__shx__codeBlockDefinition# }"
      __shx__outputScriptToEval+="${__shx__newLine}${__shx__codeBlockDefinition% }${__shx__newLine}"
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
      __shx__outputScriptToEval+="${__shx__newLine}IFS= read -r -d '' __SHX_HEREDOC_$__shx__heredocCount << 'SHX_PRINT_BLOCK'${__shx__newLine}"
      __shx__outputScriptToEval+="$__shx__stringBuilder"
      __shx__outputScriptToEval+="${__shx__newLine}SHX_PRINT_BLOCK"
      __shx__outputScriptToEval+="${__shx__newLine}printf '%s' \"\${__SHX_HEREDOC_$__shx__heredocCount%$'\\n'}\""
      __shx__outputScriptToEval+="${__shx__newLine}unset __SHX_HEREDOC_$__shx__heredocCount"
      __shx__stringBuilder=''
    fi
  fi

  : "$(( __shx__cursor++ ))"
done

if [ -n "$__shx__stringBuilder" ]
then
    __shx__outputScriptToEval+="${__shx__newLine}IFS= read -r -d '' __SHX_HEREDOC_$__shx__heredocCount << 'SHX_PRINT_BLOCK'${__shx__newLine}"
  __shx__outputScriptToEval+="$__shx__stringBuilder"
  __shx__outputScriptToEval+="${__shx__newLine}SHX_PRINT_BLOCK"
  __shx__outputScriptToEval+="${__shx__newLine}printf '%s' \"\${__SHX_HEREDOC_$__shx__heredocCount%$'\\\n'}\""
  __shx__outputScriptToEval+="${__shx__newLine}unset __SHX_HEREDOC_$__shx__heredocCount"
  __shx__stringBuilder=''
fi

[ "$__shx__codeBlockDefinitionOpen" = true ] && { echo "FN [RenderError] <% block was not closed: '$__shx__codeBlockDefinition'" >&2; return 1; }
[ "$__shx__valueBlockOpen" = true ] && { echo "FN [RenderError] <%= was not closed: '$__shx__valueBlock'" >&2; return 1; }

# local __shx__COMPILED_TEMPLATE="$( printf '%s' "$__shx__outputScriptToEval" )"
local __shx__COMPILED_TEMPLATE="$__shx__outputScriptToEval"

if [ "$__shx__printCodeOnly" = true ]
then
  echo "$__shx__COMPILED_TEMPLATE"
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
unset __shx__newLine

if [ -n "$__shx__outVariableName" ]
then
  printf -v "$__shx__outVariableName" '%s' "$__shx__COMPILED_TEMPLATE"
else
  printf '%s' "$__shx__COMPILED_TEMPLATE"
fi