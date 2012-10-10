#!/bin/sh

old="$1"
mv "$old" "$old".old
mkdir "$old"

# Teardown function
sed -n '/teardown()/,$ p' "$old".old|
  sed -e 's/teardown() *{//' > "$old/teardown"
