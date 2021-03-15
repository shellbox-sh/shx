---
---

{% raw %}

---

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

Download the [latest version](https://github.com/shellbox-sh/shx/archive/v0.1.0.tar.gz) by clicking one of the download links above or:

```sh
curl -o- https://shx.shellbox.sh/installer.sh | bash
```


---


{% endraw %}
