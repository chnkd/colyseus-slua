#!/usr/bin/env bash

if [ -z "$*" ]; then
  echo "$0 <MYFILE> <OLDFILE> <YOURFILE>"
else
  wd=$(dirname $0)
  cur=$wd/$1/colyseus
  function rev() {
    echo $wd/../../$*/colyseus
  }
  for file in $(gfind $cur -name "*.lua" -printf "%P\n"); do
    diff3 -m $cur/$file $(rev $2)/$file $(rev $3)/$file | sponge $cur/$file
  done
fi
