source vendor/assert.sh
source vendor/refute.sh
source vendor/expect.sh
source vendor/run.sh

source shx.sh

dumpShxVariables() {
  ( set -o posix; set ) | grep SHX
}