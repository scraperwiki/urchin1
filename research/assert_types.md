How we use urchin
================
I'm looking at how we use urchin tests in order that we may improve urchin's interface.

## Sorts of tests
Here are some sorts of tests I see based on our urchin tests for lithium (16 August, 2012).

* The regular expression in this file should match these things.
* A particular variable should be set to a particular thing in a particular file.
* After I do something, this file should exist, have the right permissions, &c.
* After I do something, this command should return a particular something.

Most are accomplished by running an assert with the following test.

    [ "$?" = '0' ]

This is run right after some other command that contains the real test; if that
command exits 0, the test passes.

## Files of interest
I grouped the files of which the tests are subject into a few groups.
The relevant files are in parentheses.

* A non-executable configuration file (nginx configuration)
* Executable configuration files (a few daemons)
* A repository checkout (dumptruck-web)
