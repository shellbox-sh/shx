@spec.verify_that_no_shx_variables_are_visible_to_the_template_when_rendered() {
  local result="$( shx render "<% ( set -o posix; set ) | grep -i shx | grep -v BASH | grep -v PWD | grep -vi SPEC | grep -v mainCliCommand | grep -v WORKSPACE | grep -v GITHUB | grep -v __shx__COMPILED_TEMPLATE %>"  )"
  # mainCliCommand is for the currently used version of caseEsacCompiler (will not be present in future version)
  # WORKSPACE and GITHUB are for when this is run via GitHub Actions
  # __shx__COMPILED_TEMPLATE is the one exception

  expect "$result" not toContain "shx"
}