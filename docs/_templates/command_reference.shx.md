<% if command list commandPaths; then %>

# 📓 Command Reference

<% for commandPath in "${commandPaths[@]}"; do %>
<% context goto path "$commandPath" %>

## `<%= $(command getName) %>`

<% if context has sourceCode.sh; then %>

<details>
  <summary>View Source</summary>

{% endraw %}
{% highlight sh %}
<%= $(context getValue sourceCode.sh) %>
{% endhighlight %}
{% raw %}

</details>
<% fi %>

<% if context has description; then %>
<%= $(command getDescription) %>
<% fi %>

<% if command getParameterNames parameterNames; then -%>
| | Description |
|-|-------------|
<% for parameterName in "${parameterNames[@]}"; do -%>
| `<%= $parameterName %>` | <%= $(command getParameterDescription "$parameterName" ) %> |
<% done %>
<% fi %>

<% if context getList examples exampleNames; then %>
<% for exampleName in "${exampleNames[@]}"; do %>

<% if [ "$exampleName" = default ]; then %>

#### Example

<% else %>

#### <%= $exampleName %>

<% fi %>

{% endraw %}
{% highlight sh %}
<%= $(context getValue "examples/$exampleName") %>
{% endhighlight %}
{% raw %}

<% done %>
<% fi %>

<% done %>
<% fi %>

{% endraw %}
