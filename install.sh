#!/bin/bash

echo -n "Copying aliases... "
cp bash_aliases $HOME/.bash_aliases
echo "Done"

echo -n "Linking bin to local path (~/.local/bin)... "
ln -s $HOME/Github/Shell-Scripts/bin $HOME/.local/bin
echo "Done"
