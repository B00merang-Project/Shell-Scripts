#!/bin/bash

# Unistallation script for Windows 10 TransPack
# Author: Elbullazul (Christian Medel)
# Date: 10/26/16

# Defining global variables
Website="http://b00merang.weebly.com"
LOG="$PWD/uninstall.log"

# Red font color
tput setaf 1
echo "Starting uninstallation..." | tee -a "$LOG"

now="$(date +%Y-%m-%d_%k:%M:%S)"
echo "Uninstalled on: $now" >"$LOG"

case $1 in
# Local uninstall
  -l)
  if [ $1 == '-l' ]; then
    echo "Local uninstall selected" >>"$LOG"

    rm -rf /home/$USER/.themes/Windows\ 10\ Light /home/$USER/.themes/Windows\ 10\ Dark /home/$USER/.icons/Windows\ 10 /home/$USER/.icons/win8 >>"$LOG"
    if [ -d "/home/$USER/.fluxbox/styles/Windows 10" ]; then
      rm -rf /home/$USER/.fluxbox/styles/Windows\ 10 /home/$USER/.fluxbox/styles/Windows\ 10\ Dark >>"$LOG"
    fi

    # Remove Cinnamon applets
    if [ -d "/home/$USER/.local/share/cinnamon/applets" ]; then
      rm -rf /home/$USER/.local/share/cinnamon/applets/WindowListGroup@jake.phy@gmail.com /home/$USER/.local/share/cinnamon/applets/slingshot@jfarthing84 >>"$LOG"
    fi
  fi
  ;;

# No flags
  *)
    echo "Root rights needed to uninstall..." | tee -a "$LOG"
    sudo echo "Proceeding..." | tee -a "$LOG"

    sudo rm -rf /usr/share/themes/Windows\ 10\ Light /usr/share/themes/Windows\ 10\ Dark /usr/share/icons/Windows\ 10 /usr/share/icons/win8 /usr/share/wallpapers/windows-10 >>"$LOG"

    if [ -d "/usr/share/styles/Windows 10" ]; then
      sudo rm -rf /usr/share/styles/Windows\ 10 >>"$LOG"
      sudo rm -rf /usr/share/styles/Windows\ 10\ Dark >>"$LOG"
    fi

    # Remove Cinnamon applets
    if [ -d "/usr/share/cinnamon/" ]; then
      sudo rm -rf /usr/share/cinnamon/applets/WindowListGroup@jake.phy@gmail.com
      sudo rm -rf /usr/share/cinnamon/applets/slingshot@jfarthing84
    fi
  ;;
esac

# Disable global theme

FILE="/home/$USER/.config/gtk-3.0/settings.ini"

if [ -f "$FILE" ]; then
  sed -i 's/gtk-application-prefer-dark-theme=1/gtk-application-prefer-dark-theme=0/g' "$FILE"
fi

# Green success color
tput setaf 2
echo "Windows 10 TransPack uninstalled successfully. Visit $Website for more info" | tee -a "$LOG"
