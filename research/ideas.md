Urchin interface ideas
===========
## Helpers
Here are some things we could document or add functions for.

### Evaluating files
Since many of the tests are about configuration files, we could evaluate them.
For example, configuration files written in shell can be evaluated like so.

    #!/bin/sh
    . /etc/init.d/fcgiwrap
    test "${FCGI_CHILDREN}" = '20' || exit 1

You could use a different language/library for files written in other languages
(like perl, XML or make).

In case the language is a non-parsable abomination like Nginx configuration
files, it might make sense to write our own parser in proper sed, awk, python,
&c. rather than trying to fit it into a shell script.

### Testing globs
Testing regular expressions seems to be handled quite well as is, but I suspect
that some documentation on how to do this would help. Maybe something like this,
just to give an idea of how to do it.

    #!/bin/sh
    regex="$(sed -n 's_^[^/]+__'|cut -d\  -f1)"
    echo '/box/httP/'|grep -E "${regex}" > /dev/null || exit 1

Also, I think this would be more natural in separate files; see "Organizing
tests in files".

We can test regular expressions, but I don't know how to test globs. I mean
things like `$HOME/*/*.pdf`. I think it would make sense to document how to test
globs.

## Organizing tests in files
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
subdirectories. We'd need to come up with some way to pass variables from the
setup function to the others without cluttering the namespace by passing all
of the variables.

`teardown` is run after everything else in the directory. The "everything else"
actually only includes files whose names contain "test". The test passes if the
file exits 0; otherwise, it fails.

I say that this is a bit more straightforward. Secondarily, it removes the
hassle of sourcing libraries and facilitates languages other than shell.
Tertiarily, it makes fixtures easier to handle. Fixtures are annoying in shell
tests because you don't know where the tests are running. In this case, let's
make the tests run in their directory, and you can put the fixtures in that
directory; maybe name them something like `fixture_foo_api_request`.
