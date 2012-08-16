     ,  ,  ,_     _,  , ,   ___, ,  , 
     |  |  |_)   /    |_|, ' |   |\ | 
    '\__| '| \  '\_  '| |   _|_, |'\| 
        `  '  `    `  ' `  '     '  ` 

Urchin is a language-agnostic lightweight cross-platform test skeleton written
in POSIX-compliant shell designed for test-driven server deployment.

## Dependencies
Urchin should work on any GNU/Linux distribution, any OS X verison and on
Windows through Cygwin. It should also work on any of
[these](http://en.wikipedia.org/wiki/POSIX#POSIX-oriented_operating_systems).

## Install
Install Urchin like so

     wget -O - https://raw.github.com/scraperwiki/urchin/master/urchin | sh

Now you can run it with `urchin`.

## A basic test
Tests are stored in directories. You can go as many directories deep as you
want, but let's start with one. Urchin was designed for testing server
deployment scripts, so let's test an apt-get script.

    mkdir test_apt-get
    cd test_apt-get

The setup file within a directory runs before everything else in the directory.
If you're testing
server deployment scripts, this file is often a good place to put the things
you're testing. Let's say we want to test that apt-get behaves how we think it
does. Let's say we're testing a script that installs a few shells.

    ln -s ../install_shells setup

We haven't written `../install_shells` yet; we'll write that it later. First,
let's write some tests.

    echo '#!/bin/sh' > test_dash_should_be_installed
    echo 'which dash > /dev/null' >> test_dash_should_be_installed
    
    echo '#!/bin/sh' > test_csh_should_be_installed
    echo 'which csh > /dev/null' >> test_csh_should_be_installed

That says that we want the commands `dash` and `csh` to be available after we
run  `../install_shells`. So now let's write `../install_shells`.

    echo '#!/bin/sh' > ../install_shells
    echo 'apt-get install bash zsh csh dash' >> ../install_shells

Now our directory looks like this

    $ ls -l
    total 8
    lrwxrwxrwx 1 tlevine users 17 Aug 16 13:01 setup -> ../install_shells
    -rw-r--r-- 1 tlevine users 32 Aug 16 13:01 test_csh_should_be_installed
    -rw-r--r-- 1 tlevine users 33 Aug 16 13:02 test_dash_should_be_installed

And now we can run the tests.

    `urchin .`

The `.` indicates that tests in the current directory should be run. Here's
what happens when Urchin runs.

1. Urchin looks inside the current directory for a file named `setup`. If it
    exists, it sources setup (`source setup`).
2. Urchin looks for files in the current directory with "test" in their names.
    It includes directories and symlinks in this search. It runs them in order.
    It runs files by simply executing the file and looking at the exit code.
    To run directories, it enters the directory and follows the three steps
    of which we are currently on the second, and then goes back up out of the
    directory.
3. Urchin looks for a file named `teardown` and runs it if it exists.

Throughout the test-running, urchin reports test results.
