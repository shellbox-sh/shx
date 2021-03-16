title="Hello, world!"
items=("Item A" "Item B")

@spec.unclosed_code_block.encounters_another_code_block() {
template='
<html>
  <head>
    <title> %></title>
  </head>
</html>
<body>
  <ul>
  <% for item in "${items[@]}"; do
  <% done %></ul>
</body>
'

  expect { shx render "$template" } toFail "shx [RenderError]" "unexpected %> encountered" "no <%"
}