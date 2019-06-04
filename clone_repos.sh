#!/bin/bash

read -p "Repos will be cloned here. Continue? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  wget https://gist.githubusercontent.com/Elbullazul/e5182157a7b8762a2941cd52ee6f7f25/raw/6b0825cb200f4b2af760f94fa67d0c54120bda1e/themes.index

  while read p; do
  git clone "$p"
done <themes.index

rm themes.index
else
  echo "Aborted."
fi

