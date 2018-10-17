#!/bin/bash

killall update-manager
sudo apt remove update-manager
sudo apt-add-repository ppa:flexiondotorg/awf
sudo apt update
sudo apt install -y awf gtk-3-examples gnome-tweaks git gcc make perl gnome-shell-extensions
sudo apt upgrade -y
