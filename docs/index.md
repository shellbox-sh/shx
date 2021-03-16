---
---

{% raw %}

# <%= "shell script templates" %>

> Simple, easy-to-use template rendering engine ( _written in BASH_ )

Download the [latest version](https://github.com/shellbox-sh/shx/archive/v0.1.0.tar.gz) by clicking one of the download links above or:

```sh
curl -o- https://shx.shellbox.sh/installer.sh | bash
```

---

## 🏛️ Classic syntax

`shx` provides a well-known, friendly `<%`-style syntax:

```erb
<!-- index.shx -->
<html>
  <head>
    <%= $title %>
  </head>
  <body>
    <h1><%= $header %></h1>
    <ul>
      <% for item in "${items[@]}"; do %>
        <li><%= $item %></li>
      <% done %>
    </ul>
  </body>
</html>
```

## 💬 Render a string

Provide a simple string to `shx render "[my template]"`:

```sh
$ export text="Hello, world!"

$ ./shx render "<h1><%= $text %></h1>"
```

```html
<h1>Hello, world!</h1>
```

## 💾 Render a file

Provide a file path to `shx render "[path to file]"`:

```erb
<!-- index.shx -->
<h1><%= $title %></h1>
```

```sh
$ export title="My Website"

$ ./shx render index.shx
```

```html
<h1>Hello, world!</h1>
```

## 📚 Use as a library

Give `shx` visibility into your script's variables without `export`:

```sh
source shx.sh

title="Regular variable"

shx render "Title: <%= $title %>"
```

```
Title: Regular variable
```

Including access to function `local` variables:

```sh
source shx.sh

renderTemplate() {
  local greeting="$1"
  local name="$2"
  shx render "<%= $greeting %>, <%= $name %>!"
}

renderTemplate "Hello" "Rebecca"
```

```
Hello, Rebecca!
```

## 📎 Accepts argument list

You can provide arguments after `shx render [template]` which become available via the usual means, e.g. `$*` `$@` `$#` `$1` `$2` `$3` etc

```erb
<!-- template.shx -->
<%= $# %> arguments provided:
<% for argument in "$@"; do -%>
- <%= $argument %>
<% done %>
```

```sh
./shx render template.shx "First" "Second" "Third"
```

```
3 arguments provided:
- First
- Second
- Third
```

> ℹ️ Using `-%>` prevents the character following `-%>` from being output (_e.g. in this case a newline character_)

---


{% endraw %}
