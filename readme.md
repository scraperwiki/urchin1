Urchin: A Skeleton for Shell Tests
=====

## Install

??

## Overview

Urchin lets you write *assertions* to make *test cases*, which are
organized into *test suites*.

A test case is a file, and a test suite is a directory of test cases.
You can run a lone test case, but if you have several in one directory,
you can run them all automatically.

## Assertions

An assertion looks like this.

    assert "/home/bob exists" [ -e /home/bob ]

More specifically, it takes a natural-language version of the
assertion ("/home/bob exists") and something that evaluates to
`true` or `false`. Urchin reports whether the assertion passed
(`true`), failed (`false`) or raised an error.

## Test cases

A test case is a file that defines a `runtest` function. For example

    #!/bin/sh

    runtests() {
      assert "/home/bob exists" [ -e /home/bob ]
      assert "bob cannot destroy the system" ! su bob rm -rf / 
    }

You may also define a `setup` function and a `teardown` function.
These are run before and after the `runtests` function, respectively.

    setup() {
      useradd bob
      mkdir /home/bob
      chown bob: /home/bob
    }
    teardown() {
      userdel bob
    }

Call urchin at the bottom of your script (after all those function
definitions) like so.

    urchin case

## Test suites

Make a directory called `test` or `tests`, put a bunch of test cases
in there, and you can automatically run them all with urchin. You might
set up a project like this

    ./
      bin
        create_user
        configure_system
      tests
        create_bob
        ssh_to_localhost
        go_to_local_webserver

and then go to the root of the project (`./`) and run this.

    urchin suite

Urchin will return something like this.

    Test case: create_bob
      Passed: /home/bob exists
      Passed: bob cannot destroy the system
    Test case passed
      2 tests passed
      0 tests failed
      0 tests errored

    Test case: ssh_to_localhost
      Error: can ssh to joe
    ---
    ssh: connect to host localhost port 22: Connection refused
    ---
      Passed: cannot ssh to root
    Test case failed 
      0 tests passed
      0 tests failed
      1 test errored

    Test Case: go_to_local_webserver
    ===
    sh: /etc/init.g/apache2: No such file or directory
    ===
      Failed: can access localhost:80/index.html
    Test case failed 
      0 tests passed
      1 test failed
      0 tests errored

Note that stderr is hidden if an error inside of an assertions
is caught, like in "bob can destroy the system".
Otherwise, stderr is printed as it appears, inside of a pair
of `---`s for errors within assertions and inside of a pair of
`===`s for errors outside assertions but within test cases.

You can also run any of the test cases individually with
something like this. (They're just shell scripts.)

    sh tests/ssh_to_localhost

In this situation, the output will only contain the
test case that was called.
