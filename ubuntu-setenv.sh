#!/bin/bash

killall update-manager
sudo apt remove update-manager gnome-shell-extension-desktop-icons gnome-shell-extension-ubuntu-dock/
sudo apt update
# gcc make perl are for VirtualBox guest additions
sudo apt install -y gtk-3-examples gnome-tweaks git gcc make perl gnome-shell-extensions sass
sudo apt upgrade -y
