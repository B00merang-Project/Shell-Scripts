#!/bin/bash

themes=(
'Android'
'BeOS R5'
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
'Unity 7'
'Unity 8'
'watchOS'
'tvOS'
'Wear OS'
'Windows 3.11'
'Windows 95'
'Windows Vista'
'Windows 7'
'Windows 8.1'
'Windows 8.1 Metro'
'Windows Phone 8.1'
'Windows 10'
'Windows 10 Dark'
'Windows 10 Mobile'
'Windows 10 Mobile Dark'
'Windows Whistler'
'Windows XP Themes'
)

repos=(
'https://github.com/B00merang-Project/Android'
'https://github.com/B00merang-Project/BeOS-R5'
'https://github.com/B00merang-Project/Chrome-OS'
'https://github.com/B00merang-Project/Fuchsia'
'https://github.com/B00merang-Project/iOS'
'https://github.com/B00merang-Project/iOS-4'
'https://github.com/B00merang-Project/Windows-Longhorn'
'https://github.com/B00merang-Project/macOS'
'https://github.com/B00merang-Project/macOS-Dark'
'https://github.com/B00merang-Project/Mac-OS-X-Cheetah'
'https://github.com/B00merang-Project/OS-X-Leopard'
'https://github.com/B00merang-Project/OS-X-Mavericks'
'https://github.com/B00merang-Project/OS-X-Yosemite'
'https://github.com/B00merang-Project/Redmond-Server-Themes'
'https://github.com/B00merang-Project/Redmond-Themes'
'https://github.com/B00merang-Project/Solaris-10'
'https://github.com/B00merang-Project/Solaris-11'
'https://github.com/B00merang-Project/Unity-7'
'https://github.com/B00merang-Project/Unity-8'
'https://github.com/B00merang-Project/watchOS'
'https://github.com/B00merang-Project/tvOS'
'https://github.com/B00merang-Project/Wear-OS'
'https://github.com/B00merang-Project/Windows-3.11'
'https://github.com/B00merang-Project/Windows-95'
'https://github.com/B00merang-Project/Windows-Vista'
'https://github.com/B00merang-Project/Windows-7'
'https://github.com/B00merang-Project/Windows-8.1'
'https://github.com/B00merang-Project/Windows-8.1-Metro'
'https://github.com/B00merang-Project/Windows-Phone-8.1'
'https://github.com/B00merang-Project/Windows-10'
'https://github.com/B00merang-Project/Windows-10-Dark'
'https://github.com/B00merang-Project/Windows-10-Mobile'
'https://github.com/B00merang-Project/Windows-10-Mobile-Dark'
'https://github.com/B00merang-Project/Windows-Whistler'
'https://github.com/B00merang-Project/Windows-XP'
)

tLen=${#themes[@]}

for (( i=0; i<${tLen}; i++ ));
do
  echo "-----------------------------------------"
  echo "Processing ${themes[$i]}"

  mkdir "${themes[$i]}"
  cd "${themes[$i]}"
  
  git init
  git remote add origin ${repos[$i]}
  git pull origin master
  
  cd ..
done
