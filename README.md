[![Mac (BASH 3.2)](<https://github.com/shellbox-sh/shx/workflows/Mac%20(BASH%203.2)/badge.svg>)](https://github.com/shellbox-sh/shx/actions?query=workflow%3A%22Mac+%28BASH+3.2%29%22) [![BASH 4.3](https://github.com/shellbox-sh/shx/workflows/BASH%204.3/badge.svg)](https://github.com/shellbox-sh/shx/actions?query=workflow%3A%22BASH+4.3%22) [![BASH 4.4](https://github.com/shellbox-sh/shx/workflows/BASH%204.4/badge.svg)](https://github.com/shellbox-sh/shx/actions?query=workflow%3A%22BASH+4.4%22) [![BASH 5.0](https://github.com/shellbox-sh/shx/workflows/BASH%205.0/badge.svg)](https://github.com/shellbox-sh/shx/actions?query=workflow%3A%22BASH+5.0%22)

---
# <% HTML in your Shell %>

> Simple, easy-to-use template rendering engine ( _written in BASH_ )

---

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
