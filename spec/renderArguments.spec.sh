template='
<html>
  <head>
    <title><%= $title %></title>
  </head>
  <body>
    <ul>
    <% for item in "$@"; do %>
    <li><%= $item %></li>
    <% done %></ul>
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