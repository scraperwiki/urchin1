Urchin interface ideas
===========
* The regular expression in this file should match these things.
* A particular variable should be set to a particular thing in a particular file.
* After I do something, this file should exist, have the right permissions, &c.
* After I do something, this command should return a particular something.

## File-based
Since most of our files are of the `test "$?" = '0'` variety, how about we
make the directory, rather than the file, the atomic unit of testness. Test
suites, or whatever you call them, would just be recursive trees of files,
where the names of the files have special meanings.

    foo/
      setup
      bar/
        setup
        test_that_something_works
      teardown
      baz/
        jack-in-the-box/
          setup
          test_that_something_works
          teardown
        cat-in-the-box/

Directories are processed in a depth-first order. When a particular directory
is processed, `setup` is run before everything else in the directory, including
subdirectories. `teardown` is run after everything else in the directory. The
"everything else" actually only includes files whose names contain "test".

