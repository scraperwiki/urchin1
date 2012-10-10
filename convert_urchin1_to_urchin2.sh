#!/bin/sh

# Run this on an urchin1 file to convert it to an urchin2 directory of the
# same name; the urchin1 file will be renamed to "${name}.old".

old="$1"
mv "$old" "$old".old
mkdir "$old"

# Setup function
sed -n '1,/}/ p' "$old".old |
  sed -e 's/setup *() *{//' > "$old/setup"

# Teardown function
sed -n '/teardown()/,$ p' "$old".old |
  sed -e 's/teardown *() *{//' > "$old/teardown"

# Fake assert function
assert() {
  filename=$(echo "$1"| tr -d \/ )
  shift
  filecontents="$*"
  echo "$filecontents" > "$old/$filename"
}

tmp=$(mktemp)
# Other functions
while
    grep -m1 assert $old.old > $tmp
  do
    cat $tmp
    . $tmp
    sed -i '0,/assert /assert/d' $old.old
done
