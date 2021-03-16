title="Hello, world!"
items=("Item A" "Item B")

template='<html>
  <head>
    $title is not evaluated
    <title><%= $title %></title>
  </head>
  <body>
    <ul>
    <% for item in "${items[@]}"; do -%>
    <li><%= $item %></li>
    <% done -%>
    </ul>
  </body>
  Also $# and $@ and $items and ${items[@]}
</html>
'

@spec.hello_world() {
expected='<html>
  <head>
    $title is not evaluated
    <title>Hello, world!</title>
  </head>
  <body>
    <ul>
        <li>Item A</li>
        <li>Item B</li>
        </ul>
  </body>
  Also $# and $@ and $items and ${items[@]}
</html>'

  expect { shx render "$template" } toEqual "$expected"
}
