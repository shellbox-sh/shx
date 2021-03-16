@spec.verify_that_no_shx_variables_are_visible_to_the_template_when_rendered() {
  local result="$( shx render "<% ( set -o posix; set ) | grep -i shx | grep -v BASH | grep -v PWD | grep -vi SPEC | grep -v mainCliCommand %>"  )"
  # mainCliCommand is for the currently used version of caseEsacCompiler (will not be present in future version)

  expect "$result" not toContain "shx"
}