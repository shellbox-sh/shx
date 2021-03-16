@spec.can_get_version_number() {
  expect { shx --version } toContain "shx version"
}