title="Hello, world!"
items=("Item A" "Item B")

template='<html>
  <head>
    <title><%= $title %></title>
  </head>
  <body>
    <ul>
    <% for item in "${items[@]}"; do -%>
    <li><%= $item %></li>
    <% done -%>
    </ul>
  </body>
</html>
'

@spec.hello_world() {
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

@spec.hello_world.fromFile() {
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

  expect { shx render "${BASH_SOURCE[0]%/*}/helloWorld.shx" } toEqual "$expected"
}

@spec.hello_world.simple_string() {
  expect { shx render '<h1><%= $1 %></h1>' "Hello" } toEqual "<h1>Hello</h1>"
}