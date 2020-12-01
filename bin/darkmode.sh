#!/bin/bash

if [[ "$1" == "" ]]; then
  echo "Invalid theme (must be in ~/.themes)"
  exit
elif [[ "$2" != "on" ]] || [[ "$2" != "off" ]]; then
  echo "Invalid action (on/off)"
  exit
fi

cd $HOME/.themes/$1

if [[ $2 == "on" ]]
then
  echo "On"
  mv $HOME/.themes/$1/gtk-3.0/gtk.css $HOME/.themes/$1/gtk-3.0/gtk-orig.css
  mv $HOME/.themes/$1/gtk-3.0/gtk-dark.css $HOME/.themes/$1/gtk-3.0/gtk.css

  mv $HOME/.themes/$1/gtk-3.20/gtk.css $HOME/.themes/$1/gtk-3.20/gtk-orig.css
  mv $HOME/.themes/$1/gtk-3.20/gtk-dark.css $HOME/.themes/$1/gtk-3.20/gtk.css
elif [[ $2 == "off" ]]
then
  echo "Off"
  mv $HOME/.themes/$1/gtk-3.0/gtk.css $HOME/.themes/$1/gtk-3.0/gtk-dark.css
  mv $HOME/.themes/$1/gtk-3.0/gtk-orig.css $HOME/.themes/$1/gtk-3.0/gtk.css

  mv $HOME/.themes/$1/gtk-3.20/gtk.css $HOME/.themes/$1/gtk-3.20/gtk-dark.css
  mv $HOME/.themes/$1/gtk-3.20/gtk-orig.css $HOME/.themes/$1/gtk-3.20/gtk.css
fi
