title="Hello, world!"
items=("Item A" "Item B")

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

@spec.unclosed_code_block.encounters_another_code_block() {

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

  expect { shx render "$template" } toFail "shx [RenderError]" "%> block was closed" "another <% currently open" 'for item in "${items[@]}'
}

@pending.unclosed_code_block.encounters_a_value_block() {
  :
}

@pending.unclosed_code_block.encounters_end_of_template() {
  :
}