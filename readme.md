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
assertion ("/home/bob exists") and a value of `true` or `false`.
(`[ -e /home/bob ]` will evaluate to `true` or `false` unless
something else is wrong and it raises an error.) Urchin reports
whether the assertion passed (`true`), failed (`false`) or
raised an error.

### Test cases

A test case is a file that defines a `runtest` function. For example

    #!/bin/sh

    runtests() {
      assert "/home/bob exists" [ -e /home/bob ]
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

