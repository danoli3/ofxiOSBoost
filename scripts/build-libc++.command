#!/bin/sh

here="`dirname \"$0\"`"
echo "cd-ing to $here"
cd "$here" || exit 1

./build-libc++.sh
