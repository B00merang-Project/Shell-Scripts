#!/bin/bash

themes=(
'Android'
'Chrome OS'
'Fuchsia'
'iOS'
'iOS 4'
'Longhorn Themes'
'macOS High Sierra'
'macOS High Sierra Dark'
'Mac OS X Cheetah'
'OS X Leopard'
'OS X Mavericks'
'OS X Yosemite'
'Redmond Server Themes'
'Redmond Themes'
'Solaris 10'
'Solaris 11'
'Unity 8'
'Windows 8.1 Metro'
'Windows 10'
'Windows 10 Dark'
'Windows 10 Mobile'
'Windows 10 Mobile Dark'
'Windows Whistler'
'Windows XP Themes'
)

repos=(
'https://github.com/B00merang-Project/Android'
'https://github.com/B00merang-Project/Chrome-OS'
'https://github.com/B00merang-Project/Fuchsia'
'https://github.com/B00merang-Project/iOS'
'https://github.com/B00merang-Project/iOS-4'
'https://github.com/Elbullazul/Longhorn-Collaboration'
'https://github.com/B00merang-Project/macOS-High-Sierra'
'https://github.com/B00merang-Project/macOS-High-Sierra-Dark'
'https://github.com/B00merang-Project/Mac-OS-X-Cheetah'
'https://github.com/B00merang-Project/OS-X-Leopard'
'https://github.com/B00merang-Project/OS-X-Mavericks'
'https://github.com/B00merang-Project/OS-X-Yosemite'
'https://github.com/B00merang-Project/Redmond-Server-Themes'
'https://github.com/B00merang-Project/Redmond-Themes'
'https://github.com/B00merang-Project/Solaris-10'
'https://github.com/B00merang-Project/Solaris-11'
'https://github.com/B00merang-Project/Unity8'
'https://github.com/B00merang-Project/Windows-8.1-Metro'
'https://github.com/B00merang-Project/Windows-10'
'https://github.com/B00merang-Project/Windows-10-Dark'
'https://github.com/B00merang-Project/Windows-10-Mobile'
'https://github.com/B00merang-Project/Windows-10-Mobile-Dark'
'https://github.com/B00merang-Project/Windows-Whistler'
'https://github.com/B00merang-Project/WinXP-themes'
)

tLen=${#themes[@]}

for (( i=0; i<${tLen}; i++ ));
do
  mkdir "${themes[$i]}"
  cd "${themes[$i]}"
  
  git init
  git remote add origin ${repos[$i]}
  git pull origin master
  
  cd ..
done
