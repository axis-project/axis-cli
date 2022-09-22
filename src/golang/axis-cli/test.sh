# !/usr/bin/sh

env AXIS_BINARY_PATH=$(pwd)/axis-cli $(pwd)/../../../test/bats/bin/bats $(pwd)/../../../test/*.bats
