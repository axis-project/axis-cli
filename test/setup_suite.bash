setup_suite() {
    DIR="$( cd "$( dirname "$AXIS_BINARY_PATH" )" >/dev/null 2>&1 && pwd )"
    PATH="$DIR:$PATH"
    AXIS_BINARY_NAME="axis-cli"
    export AXIS_HOME="$BATS_TEST_DIRNAME/.tmp"
    export AXIS_COMMAND=$AXIS_BINARY_NAME
}