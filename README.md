# <% HTML in your Shell %>

> Classic HTML templating

```erb
<!-- index.shx -->
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

shx render index.shx
```

> Output HTML

```html
<html>
  <head>
    <title>Hello, world!</title>
  </head>
</html>
<body>
  <ul>
    <li>Item A</li>
    <li>Item B</li>
  </ul>
</body>
```

> Provide command-line arguments

```erb
<h1><%= $1 %><% shift %></h1>
<ul>
  <% for item in "$@"; do %>
  <li><%= $item %></li>
  <% done %>
</ul>
```

```sh
shx render index.shx "My Title" "Hello" "World"
```

```html
<h1>My Title</h1>
<ul>
  <li>Hello</li>
  <li>World</li>
</ul>
```

> Render simple strings

```sh
shx render '<h1><%= $1 %></h1>' "Hello, world!"
```

```html
<h1>Hello, world!</h1>
```

---
