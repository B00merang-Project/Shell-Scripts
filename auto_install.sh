#!/bin/bash

# download from Github, extract and move to ~/.themes

# create temporary work directory
cd /tmp
mkdir windows-10
cd windows-10

# get source
wget https://github.com/B00merang-Project/Windows-10

# extract
unzip master.zip

# rename and move to $HOME/.themes
mv Windows-10-master Windows\ 10
mv Windows\ 10 ~/.themes

echo "Install finished. Check your distro's customization tool to apply changes"
