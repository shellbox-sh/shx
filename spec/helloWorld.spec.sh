template='
<html>
  <head>
    <title><%= $title %></title>
  </head>
</html>
<body>
  <ul>
  <% for item in "${items[@]}"; do %>
    <li><%= $item %></li>
  <% done %></ul>
</body>
'

@spec.helloWorld() {
  title="Hello, world!"
  items=("Item A" "Item B")

expected='<html>
  <head>
    <title>Hello, world!</title>
  </head>
</html>
<body>
  <ul>
      <li>Item A</li>
      <li>Item B</li>
  </ul>
</body>'

  shx render "$template"
  expect { shx render "$template" } toEqual "$expected"
}