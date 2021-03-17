template='<html>
  <head>
    <title><%= $title %></title>
  </head>
  <body>
    <ul>
    <% for item in "$@"; do -%>
    <li><%= $item %></li>
    <% done -%>
    </ul>
  </body>
</html>
'

@spec.render_arguments() {
  title="Render arguments!"

expected='<html>
  <head>
    <title>Render arguments!</title>
  </head>
  <body>
    <ul>
        <li>Hello</li>
        <li>World</li>
        </ul>
  </body>
</html>'


  expect { shx render "$template" "Hello" "World" } toEqual "$expected"

expected='<html>
  <head>
    <title>Render arguments!</title>
  </head>
  <body>
    <ul>
        <li>Foo</li>
        <li>Bar</li>
        <li>Baz</li>
        </ul>
  </body>
</html>'

  expect { shx render "$template" "Foo" "Bar" "Baz" } toEqual "$expected"
}

@spec.another_example() {

template='<%= $# %> arguments provided:
<% for argument in "$@"; do %>- <%= $argument %>
<% done %>'

expected='3 arguments provided:
- First
- Second
- Third'

  expect { shx render "$template" "First" "Second" "Third" } toEqual "$expected"

template='<%= $# %> arguments provided:
<% for argument in "$@"; do %>
- <%= $argument %>
<% done %>'

expected='3 arguments provided:

- First

- Second

- Third'

  shx render --code "$template" "First" "Second" "Third" | cat -A

  expect { shx render "$template" "First" "Second" "Third" } toEqual "$expected"

template='<%= $# %> arguments provided:
<% for argument in "$@"; do -%>
- <%= $argument %>
<% done %>'

expected='3 arguments provided:
- First
- Second
- Third'

  expect { shx render "$template" "First" "Second" "Third" } toEqual "$expected"
}