Urchin: A Skeleton for Shell Tests
=====

### Install

??

### Overview

Urchin lets you write *assertions* to make *test cases*, which are
organized into *test suites*.

A test case is a file, and a test suite is a directory of test cases.
You can run a lone test case, but if you have several in one directory,
you can run them all automatically.

### Assertions

An assertion looks like this.

    assert "/home/bob exists" [ -e /home/bob ]

More specifically, it takes a natural-language version of the
assertion ("/home/bob exists") and something that evaluates to
`true` or `false`. Urchin reports whether the assertion passed
(`true`), failed (`false`) or raised an error.

### Test cases

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

### Test suites

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
    
    Test case: ssh_to_localhost
      Error: can ssh to joe
    ---
    ssh: connect to host localhost port 22: Connection refused
    ---
      Passed: cannot ssh to root

    Test case: go_to_local_webserver
      Failed: can access localhost:80/index.html

You can also run any of the test cases individually with
something like this.

    sh tests/ssh_to_localhost

(They're just shell scripts.)
