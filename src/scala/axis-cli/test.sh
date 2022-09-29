# !/usr/bin/sh

fwd=$(dirname "$0")
env AXIS_BINARY_PATH=$fwd/axis-cli $fwd/../../../test/bats/bin/bats $fwd/../../../test/*.bats
