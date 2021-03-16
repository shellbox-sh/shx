#! /usr/bin/env bash

shx() {
  declare -a __shx__mainCliCommands=("shx")
  declare -a __shx__originalCliCommands=("$@")

  local __shx__mainCliCommandDepth="1"
  __shx__mainCliCommands+=("$1")
  local __shx__mainCliCommands_command1="$1"
  shift
  case "$__shx__mainCliCommands_command1" in
    "render")
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
          : "$(( __shx__heredocCount++ ))"
          __shx__outputScriptToEval+="\nIFS=\$'\\n' read -r -d '' __SHX_HEREDOC_$__shx__heredocCount<< 'SHX_PRINT_BLOCK'\n"
          __shx__outputScriptToEval+="$__shx__stringBuilder"
          __shx__outputScriptToEval+="\nSHX_PRINT_BLOCK"
          __shx__outputScriptToEval+="\nprintf '%%s' \"\$__SHX_HEREDOC_$__shx__heredocCount\""
          __shx__stringBuilder=''
        fi
      
        : "$(( __shx__cursor++ ))"
      done
      
      if [ -n "$__shx__stringBuilder" ]
      then
          __shx__outputScriptToEval+="\nIFS=\$'\\n' read -r -d '' __SHX_HEREDOC_$__shx__heredocCount<< 'SHX_PRINT_BLOCK'\n"
        __shx__outputScriptToEval+="$__shx__stringBuilder"
        __shx__outputScriptToEval+="\nSHX_PRINT_BLOCK"
        __shx__outputScriptToEval+="\nprintf '%%s' \"\$__SHX_HEREDOC_$__shx__heredocCount\""
        __shx__stringBuilder=''
      fi
      
      [ "$__shx__codeBlockDefinitionOpen" = true ] && { echo "shx [RenderError] <% block was not closed: '$__shx__codeBlockDefinition'" >&2; return 1; }
      [ "$__shx__valueBlockOpen" = true ] && { echo "shx [RenderError] <%= was not closed: '$__shx__valueBlock'" >&2; return 1; }
      
      local __shx__readyToEval="$( printf -- "$__shx__outputScriptToEval" )"
      
      eval "$__shx__readyToEval"

        ;;
    "--version")
      echo "shx version 1.0.0"

        ;;
    *)
echo 'shx version 1.0.0

HTML in your Shell!
https://shx.shellbox.sh

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

View https://shx.shellbox.sh for more details

GitHub: https://github.com/shellbox-sh/shx
'
      ;;
  esac

}

[ "${BASH_SOURCE[0]}" = "$0" ] && "shx" "$@"

