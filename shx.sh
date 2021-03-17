#! /usr/bin/env bash

SHX_VERSION="1.0.0"

SHX_CACHE=true

_SHX_COMPILED_TEMPLATE_CACHE=("")

## @command shx
shx() {
  declare -a __shx__mainCliCommands=("shx")
  declare -a __shx__originalCliCommands=("$@")

  local __shx__mainCliCommandDepth="1"
  __shx__mainCliCommands+=("$1")
  local __shx__mainCliCommands_command1="$1"
  shift
  case "$__shx__mainCliCommands_command1" in
    "compile")
    ## @command shx compile
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
          [ "$__shx__codeBlockDefinitionOpen" = true ] && { echo "shx [RenderError] <%= was started but there is a <% block already open with content: '$__shx__codeBlockDefinition'" >&2; return 1; }
          [ "$__shx__valueBlockOpen" = true ] && { echo "shx [RenderError] <%= was started but there is another <%= already open with content: '$__shx__valueBlock'" >&2; return 1; }
          __shx__valueBlockOpen=true
          __shx__stringBuilderComplete=true
          : "$(( __shx__cursor += 2 ))"
        elif [ "${__shx__providedTemplate:$__shx__cursor:2}" = "<%" ]
        then
          [ "$__shx__codeBlockDefinitionOpen" = true ] && { echo "shx [RenderError] %> block was closed but there is another <% currently open with content: '$__shx__codeBlockDefinition'" >&2; return 1; }
          [ "$__shx__valueBlockOpen" = true ] && { echo "shx [RenderError] %> block was closed but there is a <%= currently open with content: '$__shx__valueBlock'" >&2; return 1; }
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
            echo "shx [RenderError] unexpected %> encountered, no <% or <%= blocks are currently open" >&2
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
            echo "shx [RenderError] unexpected %> encountered, no <% or <%= blocks are currently open" >&2
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
      
      [ "$__shx__codeBlockDefinitionOpen" = true ] && { echo "shx [RenderError] <% block was not closed: '$__shx__codeBlockDefinition'" >&2; return 1; }
      [ "$__shx__valueBlockOpen" = true ] && { echo "shx [RenderError] <%= was not closed: '$__shx__valueBlock'" >&2; return 1; }
      
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
    ## @

        ;;
    "evaluate")
    ## @command shx evaluate
      ## @param $1 Compiled template provided via [`shx compile`](#shx-compile)
      ##
      ## Evaluates a previously compiled template.
      
      local __shx__COMPILED_TEMPLATE="$1"; shift
      eval "$__shx__COMPILED_TEMPLATE"
    ## @

        ;;
    "render")
    ## @command shx render
      ## @param $1 Template to compile (_string or path to file_)
      ## @param $@ Any number of arguments.<br>Arguments which will be available to the evaluated template,<br>e.g. `$1` or `$*` or `$@`
      ##
      ## Render the provided template and evaluate the result, printing the template result to `STDOUT`.
      ##
      ## @example Simple String
      ##   template='<%% for arg in "$@"; do %%>Arg:<%%= $arg %%> <%% done %%>'
      ##   shx render "$template" "Hello" "World!"
      ##   # => "Arg: Hello Arg: World!"
      ##
      
      # Undocumented option, get the code for the template without evaluating it: --code
      local __shx__printCodeOnly=false
      [ "$1" = "--code" ] && { __shx__printCodeOnly=true; shift; }
      
      # Shift so that templates can properly read in provided "$1" "$@" etc to the `render` function
      local __shx__originalTemplateArgument="$1"; shift
      local __shx__providedTemplate="$__shx__originalTemplateArgument"
      
      #
      # Begin Cache Lookup
      #
      local __shx__cacheEncodedItem_indexOfCompiledTemplate=''
      if [ -f "$__shx__providedTemplate" ] && [ "$SHX_CACHE" = true ]
      then
        # Build up the new cache lookup field (may have MTIME file changes)
        declare -a __shx__cacheLookupIndex=()
      
        # Loop Thru Every Item in the Cache, including it's Filename, Mtime,
        # and index to compiled template in the cache
        local __shx__cacheEncodedItem=''
        while IFS="" read -r __shx__cacheEncodedItem
        do
          local __shx__cacheUpdatedEncodedItem=''
          local __shx__cacheEncodedItem_filename="${__shx__cacheEncodedItem##*|}"
      
          # Found the item
          if [ "$__shx__cacheEncodedItem_filename" = "$__shx__providedTemplate" ]
          then
            # Get and check the mtime
            local __shx__currentTemplateFileMtime="$( date +"%s" -r "$__shx__providedTemplate" 2>/dev/null || stat -x "$__shx__providedTemplate" | grep "Modify" )"
      
            # MTIME
            local __shx__cacheEncodedItem_mtime="${__shx__cacheEncodedItem#*>}"
            __shx__cacheEncodedItem_mtime="${__shx__cacheEncodedItem_mtime%%|*}"
      
            # Index
            __shx__cacheEncodedItem_indexOfCompiledTemplate="${__shx__cacheEncodedItem%%*<}"
            __shx__cacheEncodedItem_indexOfCompiledTemplate="${__shx__cacheEncodedItem_indexOfCompiledTemplate%>*}"
      
            if [ "$__shx__currentTemplateFileMtime" = "$__shx__cacheEncodedItem_mtime" ]
            then
              # Equal! Just eval the previously compiled template
              eval "${_SHX_COMPILED_TEMPLATE_CACHE[$__shx__cacheEncodedItem_indexOfCompiledTemplate]}" && return $?
            else
              # Present but not equal, note to update it via its index
              # Update the item with the new MTIME
              local __shx__cacheUpdatedEncodedItem="$__shx__cacheEncodedItem_indexOfCompiledTemplate>$__shx__currentTemplateFileMtime|$__shx__cacheEncodedItem_filename"
            fi
          fi
      
          if [ -n "$__shx__cacheUpdatedEncodedItem" ]
          then
            __shx__cacheLookupIndex+=("$__shx__cacheUpdatedEncodedItem\n")
          else
            __shx__cacheLookupIndex+=("$__shx__cacheEncodedItem\n")
          fi
        done < <( printf "${_SHX_COMPILED_TEMPLATE_CACHE[0]}" )
      
        # Update the cache index
        _SHX_COMPILED_TEMPLATE_CACHE[0]="${__shx__cacheLookupIndex[*]}"
      
        # If no template was found and eval'd and returned from the cache, grab a new one from the filesystem
        __shx__providedTemplate="$(<"$__shx__providedTemplate")"
      fi
      #
      # End Cache Lookup
      #
      
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
          [ "$__shx__codeBlockDefinitionOpen" = true ] && { echo "shx [RenderError] <%= was started but there is a <% block already open with content: '$__shx__codeBlockDefinition'" >&2; return 1; }
          [ "$__shx__valueBlockOpen" = true ] && { echo "shx [RenderError] <%= was started but there is another <%= already open with content: '$__shx__valueBlock'" >&2; return 1; }
          __shx__valueBlockOpen=true
          __shx__stringBuilderComplete=true
          : "$(( __shx__cursor += 2 ))"
        elif [ "${__shx__providedTemplate:$__shx__cursor:2}" = "<%" ]
        then
          [ "$__shx__codeBlockDefinitionOpen" = true ] && { echo "shx [RenderError] %> block was closed but there is another <% currently open with content: '$__shx__codeBlockDefinition'" >&2; return 1; }
          [ "$__shx__valueBlockOpen" = true ] && { echo "shx [RenderError] %> block was closed but there is a <%= currently open with content: '$__shx__valueBlock'" >&2; return 1; }
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
            echo "shx [RenderError] unexpected %> encountered, no <% or <%= blocks are currently open" >&2
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
            echo "shx [RenderError] unexpected %> encountered, no <% or <%= blocks are currently open" >&2
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
      
      [ "$__shx__codeBlockDefinitionOpen" = true ] && { echo "shx [RenderError] <% block was not closed: '$__shx__codeBlockDefinition'" >&2; return 1; }
      [ "$__shx__valueBlockOpen" = true ] && { echo "shx [RenderError] <%= was not closed: '$__shx__valueBlock'" >&2; return 1; }
      
      # local __shx__COMPILED_TEMPLATE="$( printf '%s' "$__shx__outputScriptToEval" )"
      local __shx__COMPILED_TEMPLATE="$__shx__outputScriptToEval"
      
      if [ "$__shx__printCodeOnly" = true ]
      then
        echo "$__shx__COMPILED_TEMPLATE"
        return 0
      fi
      
      if [ -f "$__shx__originalTemplateArgument" ] && [ "$SHX_CACHE" = true ]
      then
        if [ -n "$__shx__cacheEncodedItem_indexOfCompiledTemplate" ] # Existing item in the cache to update
        then
          _SHX_COMPILED_TEMPLATE_CACHE[$__shx__cacheEncodedItem_indexOfCompiledTemplate]="$__shx__COMPILED_TEMPLATE"
        else
          # Add a new item
          local __shx__actualMtime="$( date +"%s" -r "$__shx__originalTemplateArgument" 2>/dev/null || stat -x "$__shx__originalTemplateArgument" | grep "Modify" )"
          local __shx__itemIndexLine="${#_SHX_COMPILED_TEMPLATE_CACHE[@]}>$__shx__actualMtime|$__shx__originalTemplateArgument"
          _SHX_COMPILED_TEMPLATE_CACHE[0]+="$__shx__itemIndexLine\n"
          _SHX_COMPILED_TEMPLATE_CACHE+=("$__shx__COMPILED_TEMPLATE")
        fi
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
      unset __shx__originalTemplateArgument
      unset __shx__providedTemplate
      unset __shx__cacheEncodedItem_indexOfCompiledTemplate
      unset __shx__cacheLookupIndex
      unset __shx__cacheEncodedItem
      unset __shx__cacheUpdatedEncodedItem
      unset __shx__cacheEncodedItem_filename
      unset __shx__currentTemplateFileMtime
      unset __shx__cacheEncodedItem_mtime
      unset __shx__cacheUpdatedEncodedItem
      
      eval "$__shx__COMPILED_TEMPLATE"
    ## @

        ;;
    "--version")
    ## @command shx --version
      ## Displays the current version of `shx.sh`
      
      echo "shx version $SHX_VERSION"
    ## @

        ;;
    *)
      echo "shx version $SHX_VERSION"
      echo '
      Shell Script Templates
      > https://shx.shellbox.sh
      
      `shx` is a minimal BASH template renderer:
      
      Example template:
      
          <html>
            <head>
              <title><%= $title %></title>
            </head>
            <body>
              <ul>
                <% for item in "${items[@]}"; do %>
                  <li><%= $item %></li>
                <% done %>
              </ul>
            </body>
          </html>
      
      To render a template, provide a file path to `shx render`:
      
          $ shx render file.shx
      
          # => <html> ...
      
      You can optionally pass command-line arguments to `shx render`
      
          Example template using command-line arguments:
      
          <html>
            <head>
              <title><%= $1 %><% shift %></title>
            </head>
            <body>
              <ul>
                <% for item in "$@"; do %>
                  <li><%= $item %></li>
                <% done %>
              </ul>
            </body>
          </html>
      
          Call `shx render` with arguments:
      
            $ shx render file.shx "My Title" "Hello" "World"
      
            # => <h1>My Title</h1>
            # => ...
            # => <li>Hello</li>
            # => <li>World</li>
      
      You can also provide a simple text string without a file:
      
         $ shx render ''<h1><%= $1 %></h1>'' "Hello"
      
         # => "<h1>Hello</h1>"
      
      Note: If you run `shx` as a binary, only exported variables
         will be available.
      
      If you use `shx` as a library, all variables in the
      current scope (including `local` variables) will
      be available for use:
      
          source shx.sh
      
          myFunction() {
            local answer=42
            shx render "<h1>The answer is: <%= $answer %></h1>
          }
      
          myFunction
      
          # => "<h1>The answer is 42</h1>
      
      Syntax Highlighting:
      
        Name shx templates using a .erb or .asp or similar file extension
        for best syntax highlighting experience in your preferred text editor
        -or- configure .shx to use one of these syntax highlighers.
      '
      ;;
  esac

}

[ "${BASH_SOURCE[0]}" = "$0" ] && "shx" "$@"

