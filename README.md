# HTML in your Shell

> Classic HTML templating

```erb
<!-- index.html -->
<html>
  <head>
    <%= $title %>
  </head>
</html>
<body>
  <ul>
    <% for item in "${items[@]}"; do %>
      <li><%= $item %></li>
    <% done %>
  </ul>
</body>
```

> Simple rendering

```sh
source shx.sh

title="My Website"
declare -a items=("Item A" "Item B")

shx render index.html
```

> Output preview

 - Item A
 - Item B

---
