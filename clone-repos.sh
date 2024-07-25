#!/bin/bash

read -p "Repos will be cloned here. Continue? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  wget https://gist.githubusercontent.com/Elbullazul/3c5e746f224d8abde5b0e6a6d4809200/raw/f4098fa755038379d7095d4bb631e29a9e5a72af/themes.index
  
  while IFS= read -r url || [ -n "$url" ]; do
    git clone "$url"
  done < themes.index

  rm themes.index
else
  echo "Aborted."
fi

