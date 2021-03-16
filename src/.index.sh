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
'