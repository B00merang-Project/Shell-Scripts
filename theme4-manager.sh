#!/bin/bash

# declare variables
declare -a GTK4_CONFIG
declare -a USER_THEMES
declare -a SHARED_THEMES

GTK4_CONFIG="$HOME/.config/gtk-4.0"

# uninstall theme if received argument
[ "$1" == '-u' ] || [ "$1" == "--uninstall" ] && [ ! -z $GTK4_CONFIG ] && rm -rf $GTK4_CONFIG/* && echo "Uninstalled GTK4 theme" && exit

# show help
[ "$1" == '-h' ] || [ "$1" == '--help' ] && echo "Available options: [ -h | --help ] [ -u | --uninstall ]" && exit

# greet the user!
echo "  _        ___     ___                                                    
 | |__    / _ \   / _ \   _ __ ___     ___   _ __    __ _   _ __     __ _ 
 | '_ \  | | | | | | | | | '_ \` _ \   / _ \ | '__|  / _\` | | '_ \   / _\` |
 | |_) | | |_| | | |_| | | | | | | | |  __/ | |    | (_| | | | | | | (_| |
 |_.__/   \___/   \___/  |_| |_| |_|  \___| |_|     \__,_| |_| |_|  \__, |
                                                                    |___/ "

echo "Welcome to b00merang's GTK 4 theme installer"
read -n 1 -s -r -p "Press any key to continue..."

# check if gtk-4.0 folder present, create it if not
[ ! -d "$GTK4_CONFIG" ] && mkdir "$GTK4_CONFIG"

# TODO: override with `/usr/share/themes` if flag received
theme_folder="$HOME/.themes"

# find theme folders found in ~/.themes with a `gtk-4.0` folder and `gtk-4.0/gtk.css` file
if [ -d $theme_folder ]; then
  for theme in "$theme_folder/"*; do
    [ ! -d "$theme/gtk-4.0" ] && continue
    [ ! -f "$theme/gtk-4.0/gtk.css" ] && continue

    # store paths in array
    USER_THEMES+=("$theme")
  done
else
  echo "$theme_folder does not exist, try again"
  exit
fi

# erase press to continue line
printf "\rList of available themes:"
echo

# show themes in 2 columns with a number
pr -2T <<< $(for (( t=1; t<=${#USER_THEMES[@]}; t++ )); do
  echo "  $t `basename "${USER_THEMES[$(($t - 1))]}"`"
done)

input=""
theme_count=${#USER_THEMES[@]}

# ask for user choice and check if answer is valid
while true; do
  read -p "Enter number of theme to install (1-$theme_count) " input
  if [ $input -gt 0 ] && [ $input -le $theme_count ]; then
    break;
  fi

  # if answer not correct, keep asking until it is, or user closes script
  echo "Invalid number: $input"
done

selected_theme=${USER_THEMES[$input - 1]}

# if another theme is already present in ~/gtk-4.0, ask for confirmation
if [ -f "$GTK4_CONFIG/gtk.css" ]; then
  read -p "A theme is already installed, do you want to overwrite it? (y/N) " yesno

  [[ ! $yesno =~ ^[Yy]$ ]] && echo "Operation was cancelled" && exit
fi

# copy everything in $selected_theme/gtk-4.0 to ~/.config/gtk-4.0
cp -R "$selected_theme/gtk-4.0/"* "$GTK4_CONFIG"

echo "Copied theme '`basename "$selected_theme"`'"
