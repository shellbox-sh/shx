title="Hello, world!"
items=("Item A" "Item B")

@spec.unclosed_code_block.encounters_another_code_block() {
template='
<html>
  <head>
    <title><%= $title %></title>
  </head>
</html>
<body>
  <ul>
  <% for item in "${items[@]}"; do
  <% done %></ul>
</body>
'

  expect { shx render "$template" } toFail "shx [RenderError]" "%> block was closed" "another <% currently open" 'for item in "${items[@]}'
}

@spec.unclosed_code_block.encounters_a_value_block() {
template='
<html>
  <head>
    <title><%= $title %></title>
  </head>
</html>
<body>
  <ul>
  <% for item in "${items[@]}"; do
  <li><%= $item %></li>
  <% done %></ul>
</body>
'

  expect { shx render "$template" } toFail "shx [RenderError]" "<%= was started" "a <% block" 'for item in "${items[@]}'
}

@spec.unclosed_code_block.encounters_end_of_template() {
template='
<html>
  <head>
    <title><%= $title %></title>
  </head>
</html>
<body>
  <ul>
  <% for item in "${items[@]}"; do
'

  expect { shx render "$template" } toFail "shx [RenderError]" "<% block was not closed" 'for item in "${items[@]}'
}