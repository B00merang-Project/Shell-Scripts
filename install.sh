#!/bin/bash

echo -n "Linking aliases file (~/.bash_aliases)... "
ln -s $PWD/bash_aliases $HOME/.bash_aliases
echo "Done"

echo -n "Linking bin to local path (~/.local/bin)... "
if [ ! -d $HOME/.local ]
then
  mkdir $HOME/.local
fi

ln -s $PWD/bin $HOME/.local

read -p "Install packages? (y/n/): " yesno

if [ $yesno == "y" ]
then
  if [ -f /bin/pacman ]
  then
    sudo pacman -Sy sassc gtk3-demos gtk4-demos imagemagick
  elif [ -f /bin/apt ]
  then
    sudo apt install -y sassc gtk-3-examples imagemagick
  elif [ -f /bin/dnf ]
  then
    sudo dnf install -y sassc gtk-devel imagemagick
  fi
fi

echo "Done."
