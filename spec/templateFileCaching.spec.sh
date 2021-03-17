@spec.stores_compiled_templates() {
  expect "${#_SHX_TEMPLATE_FILE_CACHE[@]}" toEqual 1 # First one is an index lookup
  expect "${_SHX_TEMPLATE_FILE_CACHE[0]}" toBeEmpty

  shx render "${BASH_SOURCE[0]%/*}/helloWorld.shx" >/dev/null

  expect "${#_SHX_TEMPLATE_FILE_CACHE[@]}" toEqual 2
  expect "${_SHX_TEMPLATE_FILE_CACHE[0]}" toContain "helloWorld.shx"
  expect "${_SHX_TEMPLATE_FILE_CACHE[1]}" toContain "<title>"
  expect "${_SHX_TEMPLATE_FILE_CACHE[1]}" toEqual "$( shx compile "${BASH_SOURCE[0]%/*}/helloWorld.shx" )"
}

@spec.uses_compiled_templates_unless_local_mtime_is_greater_than_persisted() {
  local templateFile="$( mktemp )"
  echo 'Hello <%= $1 %>' > "$templateFile"

  # expect { shx render "$templateFile" "Rebecca" } toEqual "Hello Rebecca"
  shx render "$templateFile" "Rebecca" >/dev/null

  expect "${#_SHX_TEMPLATE_FILE_CACHE[@]}" toEqual 2
  expect "${_SHX_TEMPLATE_FILE_CACHE[0]}" toContain "$templateFile"
  expect "${_SHX_TEMPLATE_FILE_CACHE[1]}" toContain "Hello" '$1'
  expect "${_SHX_TEMPLATE_FILE_CACHE[1]}" not toContain "Rebecca" # Doesn't save the result of the eval

  # Ok.
  # We wanna check that it'll return from the cache and not the file.
  # Let's update the file
  # We should get the new result

  sleep 1
  echo 'Hello <%= $1 %>, template was updated' > "$templateFile"

  expect { shx render "$templateFile" "Rebecca" } toEqual "Hello Rebecca, template was updated"

  expect "${#_SHX_TEMPLATE_FILE_CACHE[@]}" toEqual 2
  expect "${_SHX_TEMPLATE_FILE_CACHE[0]}" toContain "$templateFile"
  expect "${_SHX_TEMPLATE_FILE_CACHE[1]}" toContain "Hello" '$1' "template was updated"
  expect "${_SHX_TEMPLATE_FILE_CACHE[1]}" not toContain "Rebecca" # Doesn't save the result of the eval

  # Simply do it again
  shx render "$templateFile" "Rebecca"
  expect { shx render "$templateFile" "Rebecca" } toEqual "Hello Rebecca, template was updated"

  expect "${#_SHX_TEMPLATE_FILE_CACHE[@]}" toEqual 2
  expect "${_SHX_TEMPLATE_FILE_CACHE[0]}" toContain "$templateFile"
  expect "${_SHX_TEMPLATE_FILE_CACHE[1]}" toContain "Hello" '$1' "template was updated"
  expect "${_SHX_TEMPLATE_FILE_CACHE[1]}" not toContain "Rebecca" # Doesn't save the result of the eval

  # NOW, let's update it. But trick the cache into thinking it's up-to-date

  local mtimeBeforeUpdate="$( date +%s -r "$templateFile" )"
  sleep 1
  echo 'Hello <%= $1 %>, template was updated AGAIN' > "$templateFile"
  local mtimeAfterUpdate="$( date +%s -r "$templateFile" )"

  # Go into the cache and update old to new
  _SHX_TEMPLATE_FILE_CACHE[0]="${_SHX_TEMPLATE_FILE_CACHE[0]/"$mtimeBeforeUpdate"/"$mtimeAfterUpdate"}"

  expect { shx render "$templateFile" "Rebecca" } toEqual "Hello Rebecca, template was updated"

  expect "${#_SHX_TEMPLATE_FILE_CACHE[@]}" toEqual 2
  expect "${_SHX_TEMPLATE_FILE_CACHE[0]}" toContain "$templateFile"
  expect "${_SHX_TEMPLATE_FILE_CACHE[1]}" toContain "Hello" '$1' "template was updated"
  expect "${_SHX_TEMPLATE_FILE_CACHE[1]}" not toContain "Rebecca" # Doesn't save the result of the eval
  expect "${_SHX_TEMPLATE_FILE_CACHE[1]}" not toContain "AGAIN" # didn't store this! we fooled it.

  # New file adds, doesn't update

  local anotherTemplate="$( mktemp )"
  echo "Goodnight, moon" > "$anotherTemplate"

  expect { shx render "$anotherTemplate" } toEqual "Goodnight, moon"

  expect "${#_SHX_TEMPLATE_FILE_CACHE[@]}" toEqual 3
  expect "${_SHX_TEMPLATE_FILE_CACHE[0]}" toContain "$templateFile"
  expect "${_SHX_TEMPLATE_FILE_CACHE[1]}" toContain "Hello" '$1' "template was updated"
  expect "${_SHX_TEMPLATE_FILE_CACHE[2]}" toContain "Goodnight, moon"
}