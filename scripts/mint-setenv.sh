#!/bin/bash

sudo apt-add-repository ppa:flexiondotorg/awf
sudo apt update
# gcc make perl are for VirtualBox guest additions
sudo apt upgrade -y
sudo apt install -y awf gtk-3-examples gnome-tweaks git gcc make perl gnome-shell-extensions sass
