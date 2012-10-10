#!/bin/sh

# Run this on an urchin1 file to convert it to an urchin2 directory of the
# same name; the urchin1 file will be renamed to "${name}.old".
set -e
[ "$#" != '1' ] && echo 'Specify a filename.' && exit 1

file="$1"
mv "$file" "$old".old
mkdir "$file".new

# Setup function
sed -n '1,/}/ p' "$file".old |
  sed -e 's/setup *() *{//' > "$file.new/setup"

# Teardown function
sed -n '/teardown()/,$ p' "$file".old |
  sed -e 's/teardown *() *{//' > "$file.new/teardown"

# Fake assert function
assert() {
  filename=$(echo "$1"| tr -d \/ )
  shift
  filecontents="$*"
  echo "$filecontents" > "$file.new/$filename"
}

tmp=$(mktemp)
# Other functions
while
    grep -m1 assert $file.old > $tmp
  do
    cat $tmp
    . $tmp
    sed -i '0,/assert/{/assert/d}' $file.old
done
