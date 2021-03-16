title="Hello, world!"

template='
<html>
  <head>
    <title><%= $title %></title>
  </head>
  <body>
    <ul>
    <% for item in `ls $dir`; do %>
    <li><%= $item %></li>
    <% done %></ul>
  </body>
</html>'

@spec.helloWorld() {
expected='<html>
  <head>
    <title>Hello, world!</title>
  </head>
  <body>
    <ul>
        <li>barFile</li>
        <li>fooFile</li>
    </ul>
  </body>
</html>'

  local dir="$( mktemp -d )"
  touch "$dir/barFile"
  touch "$dir/fooFile"

  expect { shx render "$template" } toEqual "$expected"
}