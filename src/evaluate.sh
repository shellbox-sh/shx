## @param $1 Compiled template provided via [`shx compile`](#shx-compile)
##
## Evaluates a previously compiled template.

local __shx__COMPILED_TEMPLATE="$1"; shift
eval "$__shx__COMPILED_TEMPLATE"