#!/bin/bash

# download from Github, extract and move to ~/.themes

# create temporary work directory
cd /tmp
mkdir windows-10
cd windows-10

# get source
wget https://github.com/B00merang-Project/Windows-10/archive/master.zip -q --show-progress

# extract without verbose
unzip -qq master.zip

# create .themes if not exist
if [ ! -d "$HOME/.themes" ]
then
  mkdir "$HOME/.themes"
fi

# rename and move to $HOME/.themes
mv Windows-10-master "$HOME/.themes/Windows 10"

# delete temporary directory
rm -rf /tmp/windows-10

echo "Install finished. Check your distro's customization tool to apply changes"
