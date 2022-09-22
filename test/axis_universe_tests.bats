# !/usr/bin/env bats

setup() {
    rm $AXIS_HOME/axis.db || true
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
}



@test "axis universe" {
    run $AXIS_COMMAND universe
}

@test "axis universe list" {
    run $AXIS_COMMAND universe list
    assert_success
    # refute_output --partial "Main Universe"
}

@test "axis universe create" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND universe list
    assert_success
    assert_output --partial "Main Universe"
}

@test "axis universe create with description" {
    run $AXIS_COMMAND universe create "Main Universe" --description "This is a description"
    assert_success
    run $AXIS_COMMAND universe list
    assert_success
    assert_output --partial "Main Universe"
    assert_output --partial "This is a description"
}

@test "axis universe create duplicate" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND universe create "Main Universe"
    assert_failure
}

@test "axis universe show non-existent" {
    run $AXIS_COMMAND universe show "Main Universe"
    assert_failure
}

@test "axis universe show" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND universe create "Alternate Universe"
    assert_success
    run $AXIS_COMMAND universe show "Main Universe"
    assert_success
    assert_output --partial "Main Universe"
    refute_output --partial "Alternate Universe"
}

@test "axis universe delete non-existent" {
    run $AXIS_COMMAND universe delete "Main Universe"
    assert_failure
}

@test "axis universe delete empty" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND universe delete "Main Universe"
    assert_success
    run $AXIS_COMMAND universe show "Main Universe"
    assert_failure
}

@test "axis universe delete non-empty" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND item create "Save the Universe" --universe "Main Universe"
    assert_success
    run $AXIS_COMMAND universe delete "Main Universe"
    assert_failure
    run $AXIS_COMMAND universe show "Main Universe"
    assert_success
}

@test "axis universe force delete non-empty" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND item create "Save the Universe" --universe "Main Universe"
    assert_success
    run $AXIS_COMMAND universe delete "Main Universe" --force
    assert_success
    run $AXIS_COMMAND universe show "Main Universe"
    assert_failure
}

@test "axis universe update non-existent" {
    run $AXIS_COMMAND universe update "Main Universe"
    assert_failure
}

@test "axis universe update name" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND universe update "Main Universe" --name "Alternate Universe"
    assert_success
    run $AXIS_COMMAND universe show "Main Universe"
    assert_failure
    run $AXIS_COMMAND universe show "Alternate Universe"
    assert_success
}

@test "axis universe update description" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND universe update "Main Universe" --description "This is a description"
    assert_success
    run $AXIS_COMMAND universe show "Main Universe"
    assert_success
    assert_output --partial "This is a description"
}