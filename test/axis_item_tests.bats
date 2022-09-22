# !/usr/bin/env bats

setup() {
    rm $AXIS_HOME/axis.db || true
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
}



@test "axis item" {
    run $AXIS_COMMAND item
}

@test "axis item list" {
    run $AXIS_COMMAND item list
    assert_success
    # refute_output --partial "Main Universe"
}

@test "axis item create with no universe" {
    run $AXIS_COMMAND item create "Save the universe"
    assert_failure
}

@test "axis item create with non-existent universe" {
    run $AXIS_COMMAND item create "Save the universe" --universe "Main Universe"
    assert_failure
}

@test "axis item create" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND item create "Save the universe" --universe "Main Universe"
    assert_success
    run $AXIS_COMMAND item list
    assert_success
    assert_output --partial "Save the universe"
}

@test "axis item create with options" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND item create "Save the universe" --universe "Main Universe" --description "This is a description" --priority 1 --due "2000-01-01 01:00:00 -0700"
    assert_success
    run $AXIS_COMMAND item list
    assert_success
    assert_output --partial "Save the universe"
    assert_output --partial "This is a description"
    assert_output --partial "2000-01-01 01:00:00 -0700"
}

@test "axis item create with invalid due format" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND item create "Save the universe" --universe "Main Universe" --due "aaaa"
    assert_failure
}

@test "axis item show non-existent" {
    run $AXIS_COMMAND universe show 1
    assert_failure
}

@test "axis item show" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND item create "Save the universe" --universe "Main Universe"
    assert_success
    run $AXIS_COMMAND item create "Make some coffee" --universe "Main Universe"
    assert_success
    run $AXIS_COMMAND item show 1
    assert_success
    assert_output --partial "Save the universe"
    refute_output --partial "Make some coffee"
}

@test "axis item search non-existent" {
    run $AXIS_COMMAND item search "the universe"
    assert_success
    refute_output --partial "Save the universe"
}

@test "axis item search" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND item create "Save the universe" --universe "Main Universe"
    assert_success
    run $AXIS_COMMAND item create "Make some coffee" --universe "Main Universe"
    assert_success
    run $AXIS_COMMAND item search "the universe"
    assert_success
    assert_output --partial "Save the universe"
    refute_output --partial "Make some coffee"
}

@test "axis item search description" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND item create "Save the universe" --universe "Main Universe" --description "This is a description"
    assert_success
    run $AXIS_COMMAND item search "a description" --search-description
    assert_success
    assert_output --partial "Save the universe"
    assert_output --partial "This is a description"
}

@test "axis item delete non-existent" {
    run $AXIS_COMMAND item delete 1
    assert_failure
}

@test "axis item delete" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND item create "Save the Universe" --universe "Main Universe"
    assert_success
    run $AXIS_COMMAND item delete 1
    assert_success
    run $AXIS_COMMAND item show 1
    assert_failure
}

@test "axis item update non-existent" {
    run $AXIS_COMMAND item update 1
    assert_failure
}

@test "axis item update title" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND item create "Save the Universe" --universe "Main Universe"
    assert_success
    run $AXIS_COMMAND item update 1 --title "Make some coffee"
    assert_success
    run $AXIS_COMMAND item show 1
    assert_success
    assert_output --partial "Make some coffee"
}

@test "axis item update with options" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND item create "Save the Universe" --universe "Main Universe"
    assert_success
    run $AXIS_COMMAND item update 1 --title "Make some coffee" --description "This is a description" --priority 1 --due "2000-01-01 01:00:00 -0700"
    assert_success
    run $AXIS_COMMAND item show 1
    assert_success
    assert_output --partial "Make some coffee"
    refute_output --partial "Save the universe"
    assert_output --partial "This is a description"
    assert_output --partial "2000-01-01 01:00:00 -0700"
}

@test "axis item move with no universe" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND item create "Save the Universe" --universe "Main Universe"
    assert_success
    run $AXIS_COMMAND item move 1
    assert_failure
}

@test "axis item move non-existent item" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND item move 1 --universe "Main Universe"
    assert_failure
}

@test "axis item move to non-existence universe" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND item create "Save the Universe" --universe "Main Universe"
    assert_success
    run $AXIS_COMMAND item move 1 --universe "Alternate Universe"
    assert_failure
}

@test "axis item move" {
    run $AXIS_COMMAND universe create "Main Universe"
    assert_success
    run $AXIS_COMMAND universe create "Alternate Universe"
    assert_success
    run $AXIS_COMMAND item create "Save the Universe" --universe "Main Universe"
    assert_success
    run $AXIS_COMMAND item move 1 --universe "Alternate Universe"
    assert_success
}