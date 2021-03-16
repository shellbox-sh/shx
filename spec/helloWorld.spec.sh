title="Hello, world!"
items=("Item A" "Item B")

template='
<html>
  <head>
    <title><%= $title %></title>
  </head>
  <body>
    <ul>
    <% for item in "${items[@]}"; do %>
    <li><%= $item %></li>
    <% done %></ul>
  </body>
</html>
'

@spec.helloWorld() {
expected='<html>
  <head>
    <title>Hello, world!</title>
  </head>
  <body>
    <ul>
        <li>Item A</li>
        <li>Item B</li>
    </ul>
  </body>
</html>'

  expect { shx render "$template" } toEqual "$expected"
}