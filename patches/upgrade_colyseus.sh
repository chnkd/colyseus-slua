#!/usr/bin/env bash

wd=$(dirname $0)
myfile=$wd/../Assets/Scripts/lib/colyseus
version=$wd/version.txt
function rev() {
  git clone -q https://github.com/colyseus/colyseus-defold.git $1
  pushd . > /dev/null
  cd $1
  id=$(git log --reverse --ancestry-path $2..master --oneline | head -1 | cut -d' ' -f1)
  echo $id
  git reset -q --hard $id
  popd > /dev/null
}
function dir() {
  echo $wd/$*/colyseus
}
cur=$(cat $version)
echo $(rev youfile $(rev oldfile $cur^)) > $version
#for file in $(gfind $myfile -name "*.lua" -printf "%P\n"); do
#  diff3 -m $myfile/$file $(dir oldfile)/$file $(dir youfile)/$file | sponge $myfile/$file
#done
