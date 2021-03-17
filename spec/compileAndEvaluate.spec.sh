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

@pending.compile_and_evaluate.hello_world() {
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

  local compiled="$( shx compile "$template" )"
  expect "$compiled" toContain "printf"
  expect "$compiled" not toContain "Item A"
  expect "$compiled" not toContain "Hello, world!"

  local var
  shx compile "$template" var
  expect "$var" toEqual "$compiled"

  expect { shx evaluate "$compiled" } toEqual "$expected"
  expect { shx evaluate "$var" } toEqual "$expected"
}

@pending.compile_and_evaluate.hello_world.fromFile() {
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