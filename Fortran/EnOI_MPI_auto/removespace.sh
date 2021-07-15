#!/bin/bash

files="./*.for"

for i in $files
do
  sed -e 's/^ *//g' -e 's/ *$//g' $i > $i
done
