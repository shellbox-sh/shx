title="Hello, world!"
items=("Item A" "Item B")

@spec.unclosed_value.encounters_a_code_block() {
template='
<html>
  <head>
    <title><%= $title
  </head>
</html>
<body>
  <ul>
  <% for item in "${items[@]}"; do
  <% done %></ul>
</body>
'

  expect { shx render "$template" } toFail "shx [RenderError]" "%> block was closed" "a <%= currently open" '$title'
}

@spec.unclosed_value.encounters_another_value_block() {
template='
<html>
  <head>
    <title><%= $title
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

  expect { shx render "$template" } toFail "shx [RenderError]" "<%= was started" "another <%=" '$title'
}

@spec.unclosed_value.encounters_end_of_template() {
template='
<html>
  <head>
    <title><%= $title %></title>
  </head>
</html>
<body>
  <ul>
    <title><%= $title 
'

  expect { shx render "$template" } toFail "shx [RenderError]" "<%= was not closed" '$title'
}