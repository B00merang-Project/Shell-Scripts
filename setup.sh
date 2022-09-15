#!/bin/bash

echo -n "Linking aliases file ($HOME/.b00merang_aliases)... "
if [ ! -f $HOME/.b00merang_aliases ]
then
  ln -s $PWD/b00merang_aliases $HOME/.b00merang_aliases
fi
echo "Done"

if [ ! -f $HOME/.bashrc ]
then
  echo "source $HOME/.b00merang_aliases" >>$HOME/.bashrc
fi

if [ ! -f $HOME.zshrc ]
then
  echo "source $HOME/.b00merang_aliases" >>$HOME/.zshrc
fi

echo "Linking commands ($HOME/.local/bin)... "
if [ ! -d $HOME/.local ]
then
  mkdir $HOME/.local
elif [ ! -d $HOME/.local/bin ]
then
  mkdir $HOME/.local/bin
fi

for file in bin/*
do
  echo "Linking $file"
  ln -s "$PWD/$file" $HOME/.local/bin/
done
echo "Done"

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
    sudo dnf install -y sassc gtk3-devel gtk4-devel ImageMagick
  fi
fi

echo "Done."
