#!/bin/bash

# Software variables
version="R5"

LOG="$PWD/install.log"
path="/usr/share/themes"
t2path="/usr/share/tint2"
iconpath="/usr/share/icons"
stylepath="/usr/share/styles"

theme_name="Windows 10 Light"
icon_theme="Windows 10 Icons"

WM="Unknown"
DE="Unknown"

Website="http://b00merang.weebly.com"

# --- Misc functions to simplify programming ---
download() {

 wget $1 -q --show-progress
 mv master.zip $2

}

color() {
 tput setaf $1
}

# --- Verification and integrity functions ---

check_bash() {

 bash_v="$(echo "$BASH_VERSION" | cut -c1-1)" # since we need bash 4.x, get first name

 if [ "$bash_v" -lt 4 ]; then
  color 1
  echo "GNU Bash 4.0 or higher is needed to execute this script correctly. You have $BASH_VERSION" | tee -a "$LOG"
  exit # Useless to continue execution
 else
  color 2
  echo "GNU Bash is compatible: $BASH_VERSION" | tee -a "$LOG"
 fi

}

check_connection() {

 echo -e "GET http://github.com HTTP/1.0\n\n" | nc github.com 80 > /dev/null 2>&1

 # If there is any value > 0 in ? variable
 if [ $? -eq 0 ]; then
  color 2; echo "Internet connection detected" | tee -a "$LOG"; color 7
 else
  color 1; echo "Internet connection needed. Please connect and retry" | tee -a "$LOG"
  exit
 fi

}

verify() {
  
  # Variable to see if all is OK, else it returns what's missing
  isok="ok"

# Verify if themes installed OK
  declare -a themes
  themes=( Windows\ 10\ Light Windows\ 10\ Dark Windows\ 10\ Metro )

 # Process all file names passed in arguments 
  for f in ${!themes[@]}
  do
   if [ ! -d "$path/${themes[$f]}" ]; then
    isok='GTK theme'
   fi
  done

# Verify if icon theme OK
  if [ ! -d "$iconpath/$icon_theme" ]; then
    isok='Icon theme'
  fi

# Verify if X11 theme OK
  if [ ! -d "$iconpath/win8" ]; then
    isok='X11 theme'
  fi

  if [ "$isok" != "ok" ]; then
   echo "Something went wrong while installing: $isok. Aborting..." | tee -a "$LOG"
   exit
  else
   echo "All files installed correctly" >> "$LOG"
  fi

}

# --- Program functions ---

uninstall() {

 case $path in
  "/usr/share/themes")
    sudo rm -rf "$path/Windows 10 Light"
    sudo rm -rf "$path/Windows 10 Dark"
    sudo rm -rf "$path/Windows 10 Metro"
    sudo rm -rf "$iconpath/Windows 10 Icons"
    sudo rm -rf "$iconpath/win8"

    if [ -d "$stylepath/Windows 10" ]; then
     sudo rm -rf "$stylepath/Windows 10"
     sudo rm -rf "$stylepath/Windows 10 Dark"
    fi

    if [ -a "$t2path/wintint2" ]; then
     sudo rm -rf "$t2path/wintint2"
    fi
  ;;

  *)
    rm -rf "$path/Windows 10 Light"
    rm -rf "$path/Windows 10 Dark"
    rm -rf "$path/Windows 10 Metro"
    rm -rf "$iconpath/Windows 10 Icons"
    rm -rf "$iconpath/win8"

    if [ -d "$stylepath/Windows 10" ]; then
     rm -rf "$stylepath/Windows 10"
     rm -rf "$stylepath/Windows 10 Dark"
    fi

    if [ -a "$t2path/wintint2" ]; then
     rm -rf "$t2path/wintint2"
    fi
  ;;
 esac

 echo "Themes uninstalled successfully" | tee -a "$LOG"
 
 exit

}

process_flags() {

  declare -a flags # Declare a new array
  flags=("$@")     # Host all flags in the array

  # Process each passed flag from main
  for f in "${!flags[@]}"
  do
    case ${flags[$f]} in

    -h)
      # Help for TransPack
      printf "Available flags\n -h         Show help\n"
      printf " -t         Enable testing mode for development\n"
      printf " -v         Get TransPack versioning and information\n"
      printf " -l         Install themes to local folders\n"
      printf " --set-de   Force install theme for specific Desktop environment\n"
      color 4
      printf "\n---supported DEs---\n"; color 7; printf " gnome unity cinnamon lxde fluxbox\n openbox mate"; color 3; printf " (experimental)\n\n"
      color 7
      echo "More info or help @ $Website/TransPack.html"

      exit
      ;;

    --set-de)
      # Force install some DE
      echo "User chose to force override DE: ${flags["$f+1"]}" >"$LOG"

      declare -A deskenv; # New array hosting supported DEs
      deskenv[gnome]="gnome-shell"
      deskenv[cinnamon]="mutter"
      deskenv[unity]="compiz"
      deskenv[lxde]="openbox"
      deskenv[fluxbox]="fluxbox"
      deskenv[mate]="marco"
      deskenv[xfce]="xfwm"

      override="${flags["$f+1"]}"
      for f in "${!deskenv[@]}" # for every item in the array
      do
       if [[ $override == "$f" ]];then # assign WM value if DE matches parameter
        echo "WM set to $f"
        WM=${deskenv[$f]}
       fi
      done
      ;;

    -v)
      # Versioning info
      color 4;
      echo "B00merang TransPack $version"
      echo "----------------------------"
      color 6;
      echo "Transformation Pack script for Linux desktop. Compatibility list found @ $Website/TransPack.html"
      exit
      ;;

    -l)
      # Reset paths to local folders
      path="$HOME/.themes"
      t2path="$HOME/.config/tint2"
      iconpath="$HOME/.icons"
      stylepath="$HOME/.fluxbox/styles"
      ;;

    -t)
      # Enable testing mode to install from local resources
      dev_mode
      ;;

    -u)
      uninstall
      ;;

    # Avoid breaking execution for supported DEs for force install
    gnome|cinnamon|lxde|mate|unity|fluxbox|xfce)
      ;;

    *)
      echo "Unvalid option/argument. Aborting..." | tee -a "$LOG"
      exit
      ;;

    esac
  done

}

get_input() {

 read -p "Please choose which theme you want to apply (1/2/3): " selectheme

 case $selectheme in
  1) theme_name="Windows 10 Light";;
  2) theme_name="Windows 10 Dark";;
  3) theme_name="Windows 10 Metro";;
  *) get_input;;
 esac

}

prompt_theme() {

 read -p "Do you want to apply a theme after installation? (y/n): " yesno

 case $yesno in
  y|Y) echo "User selected auto-application" >> "$LOG";;
  n|N) echo "No theme will be applied" | tee -a "$LOG"; return;;
 esac

 echo "Themes available:"
 color 7
 echo " (1) Windows 10 Light"
 color 8
 echo " (2) Windows 10 Dark"
 color 0
 echo " (3) Windows 10 Metro"
 color 7

 # Loop while theme is not what we listed
 get_input
 apply

}

install_fluxbox() {

 case $path in
  "/usr/share/themes")
    sudo cp -a Windows\ 10\ Light/fluxbox/Windows\ 10 "$stylepath"
    sudo cp -a Windows\ 10\ Dark/fluxbox/Windows\ 10\ Dark "$stylepath"
  ;;
  *)
    cp -a Windows\ 10\ Light/fluxbox/Windows\ 10 "$stylepath"
    cp -a Windows\ 10\ Dark/fluxbox/Windows\ 10\ Dark "$stylepath"
  ;;
 esac

 clean fluxbox

}

install_tint2() {

  # Remove or not tint2rc if tint2 is installed
  if [ -a /usr/bin/tint2 ]; then
    case $t2path in
     "/usr/share/tint2")
      sudo cp Windows\ 10\ Light/tint2/tint2rc "$t2path/wintint2"
     ;;
     *)
      cp Windows\ 10\ Light/tint2/tint2rc "$t2path/wintint2"
     ;;
    esac

   echo "Tint2 theme saved @ $t2path/wintint2"

  fi

}

get_files() {
 echo "Download files">> "$LOG"

  # Get GTK Light theme
  download https://github.com/B00merang-Project/Windows-10/archive/master.zip light.zip

  # Get GTK Dark theme
  download https://github.com/B00merang-Project/Windows-10-Dark/archive/master.zip dark.zip

  # Get GTK Metro theme
  download https://github.com/B00merang-Project/Windows-10-Metro/archive/master.zip metro.zip

  # Get icon theme
  download https://github.com/B00merang-Project/Windows-10-icons/archive/master.zip icons.zip

  # Get X11 theme from website (no other hosting)
  download http://b00merang.weebly.com/uploads/1/6/8/1/16813022/windows_x11.zip win8.zip

 echo "Done"

}

clean() {

 # Parameters array for easier processing
  declare -a files     # define a new bash array
  files=("$@")         # give

 # Process all file names passed in arguments 
  for f in ${!files[@]}
  do
   # remove directories in active array item in all sub-folders
   rm -rf */"${files[$f]}"
  done

}

detect_wm() {

if [ $WM != "Unknown" ]; then
 return
fi

# Get Window manager Name
  WM="$(xprop -id $(xprop -root -notype | awk '$1=="_NET_SUPPORTING_WM_CHECK:"{print $5}') -notype -f _NET_WM_NAME 8t | grep _NET_WM_NAME)"

# Get NET name (remove clutter at start of string)
  WM=${WM#'_NET_WM_NAME = "'}
  WM=${WM%'"'} # remove last "

# Lower case WM name
  WM=${WM,,}

# Notify Window manager
  color 3; printf "Identified Window manager. Waiting for association...\n" | tee -a "$LOG"; color 7

# Desktop Environment variable
  DE="Unknown" #Avoid getting NULL value somewhere

}

associate() {

# Case to clean unnecessary stuff & launch installation
  case $WM in

    *muffin*)
      DE="cinnamon"
      clean extra-icons fluxbox gnome-shell openbox-3 Plasma\ 5 README.md tint2 unity xfce-notify-4.0 xfwm4 wallpaper.jpg
      ;;

    *gnome*)
      DE="gnome"
      clean cinnamon extra-icons fluxbox metacity-1 openbox-3 Plasma\ 5 README.md tint2 unity xfce-notify-4.0 xfwm4 wallpaper.jpg
      ;;

    *xfwm*)
      DE="xfce"
      clean cinnamon extra-icons fluxbox gnome-shell metacity-1 openbox-3 Plasma\ 5 README.md tint2 unity wallpaper.jpg
      ;;

    *compiz*|*unity*)
      DE="unity"
      clean cinnamon extra-icons fluxbox gnome-shell metacity-1 openbox-3 Plasma\ 5 README.md tint2 xfce-notify-4.0 xfwm4 wallpaper.jpg
      ;;

    *marco*)
      DE="mate"
      clean cinnamon extra-icons fluxbox gnome-shell openbox-3 Plasma\ 5 README.md tint2 unity xfce-notify-4.0 xfwm4 wallpaper.jpg
      ;;

    *openbox*)
      DE="lxde" # May or may not be LXDE, need to add confirmation code here

      install_tint2
      clean cinnamon extra-icons openbox-3 fluxbox gnome-shell metacity-1 Plasma\ 5 README.md unity xfce-notify-4.0 xfwm4 wallpaper.jpg
      ;;

    *fluxbox*)
      DE="fluxbox"

      install_fluxbox
      clean cinnamon extra-icons fluxbox gnome-shell metacity-1 openbox-3 Plasma\ 5 README.md tint2 unity xfce-notify-4.0 xfwm4 wallpaper.jpg
      ;;

    *)
      # Install GTK theme only, if no DE recognized
      color 1; echo "We have been unable to associate your Desktop Environment. Executing Legacy Installation"; color 7
      echo "Unknown Desktop Environment. Proceeding with Legacy installation..." >>"$LOG"
      ;;
  esac

 # Record to log which WM is detected and if any association has occurred
  if [ "$WM" != "Unknown" ]; then
    echo "$WM detected as Window manager, assuming $DE" >>"$LOG"
  else
    echo "$WM has no known DE associated with it" >>"$LOG"
  fi

}

inflate() {

 echo "Extracting files">> "$LOG"

  # Unzip files & store first output line to variable
  zipgtk=$(unzip light.zip | sed -n '1p')
  zipgtk=$(unzip dark.zip | sed -n '1p')
  zipgtk=$(unzip metro.zip | sed -n '1p')
  zipicon=$(unzip icons.zip | sed -n '1p')
  zipx11=$(unzip win8.zip | sed -n '1p')

 echo "Renaming files">> "$LOG"

 mv Windows-10-master Windows\ 10\ Light
 mv Windows-10-Dark* Windows\ 10\ Dark
 mv Windows-10-Metro* Windows\ 10\ Metro
 mv Windows-10-Icons* Windows\ 10\ Icons

}

install_themes() {
 
 # rm -rf *.zip

 case $path in
  "/usr/share/themes")
     sudo mv Windows\ 10\ Light "$path"
     sudo mv Windows\ 10\ Dark "$path"
     sudo mv Windows\ 10\ Metro "$path"
     sudo mv Windows\ 10\ Icons "$iconpath"
     sudo mv win8 "$iconpath"

    # make root own this files to avoid permissions bug
    sudo chown root "$path/Windows 10 Light" "$path/Windows 10 Dark" "$path/Windows 10 Metro" "$iconpath/$icon_theme" "$iconpath/win8"

    # add Read attributes to selected folders
    sudo chmod +wr -R "$path/Windows 10 Light" "$path/Windows 10 Dark" "$path/Windows 10 Metro" "$iconpath/$icon_theme" "$iconpath/win8"

  ;;

  *)
     mv Windows\ 10\ Light "$path"
     mv Windows\ 10\ Dark "$path"
     mv Windows\ 10\ Metro "$path"
     mv Windows\ 10\ Icons "$iconpath"
     mv win8 "$iconpath"
  ;;
 esac

 echo "Installing themes in $path and icons in $iconpath" >> "$LOG"
 
}

apply() {

# Here is where DE variable gets important
  color 3; echo "Applying $theme_name to: $DE" | tee -a "$LOG"

# Apply themes depending on Desktop environments
  case $DE in
    cinnamon)
      # Code fetched from Feren OS Themer (https://github.com/feren-OS/feren-Themer-Source-Code)
      gsettings set org.cinnamon.theme name "$theme_name"
      gsettings set org.cinnamon.desktop.interface gtk-theme "$theme_name"
      gsettings set org.cinnamon.desktop.wm.preferences theme "$theme_name"
      gsettings set org.cinnamon.desktop.interface icon-theme "$icon_theme"
      ;;

     gnome)
      # Display message why extension is needed
      color 3
      echo "The user themes extension must be enabled to apply the windows 10 shell theme"
      
      # Wait a bit, make shure user reads message
      sleep 5
      
      # Open webpage
      x-www-browser https://extensions.gnome.org/extension/19/user-themes
      
      # Apply theme
      gsettings set org.gnome.shell.extensions.user-theme name "$theme_name"
      gsettings set org.gnome.desktop.interface gtk-theme "$theme_name"
      gsettings set org.gnome.desktop.wm.preferences theme "$theme_name"
      gsettings set org.gnome.desktop.interface icon-theme "$icon_theme"
      ;;

     lxde)
      # Configuration file edition required (install using sed soon)
      tput setaf 3
      echo "Lxde supports only manual input to change themes. Please do so by opening the corresponding Tweak tool"
      color 7
      ;;

     mate)
      # Maybe this is REALLY outdated...
      color 3
      echo "The method used to apply icons may not be the latest. If it does not work, please apply the themes yourself"
      color 7

      # Set desktop & WM themes
      mateconftool-2 --type=string --set /desktop/mate/interface/gtk_theme "$theme_name"
      mateconftool-2 --type=string --set /apps/marco/general/theme "$theme_name"
      # Search for way to set icon theme from terminal
      ;;

     unity)
      # Set themes, same thing as gnome
      gsettings set org.gnome.desktop.interface gtk-theme "$theme_name"
      gsettings set org.gnome.desktop.wm.preferences theme "$theme_name"
      gsettings set org.gnome.desktop.interface icon-theme "$icon_theme"

      # Set Unity to be a little more Windowish
      gsettings set com.canonical.Unity.Launcher launcher-position Bottom
      gsettings set com.canonical.Unity form-factor 'Desktop' # Set Dash to be more like a start menu
      ;;

     xfce)
      # Set WM, GTK and icon themes
      xfconf-query -c xsettings -p /Net/ThemeName -s "$theme_name"
      xfconf-query -c xfwm4 -p /general/theme -s "$theme_name"
      xfconf-query -c xsettings -p /Net/IconThemeName -s "$icon_theme"
      ;;

     *)
      # Other DEs, generally unsupported for application
      echo "Cannot apply changes for your current configuration: $DE"
      echo "Unsupported Desktop environment: $DESKTOP_SESSION" >>"$LOG"
      ;;
  esac

  color 6

  # User must manually choose X11 theme, but it's a big mess anyways...
  echo "X11 cursor theme is installed, but cannot be applied automatically. Please do so in your System settings or tweak tool"

  color 7

}

welcome() {

# Welcome message
 color 4; echo "Welcome to the B00merang Theme Installer";
 printf "\n"; color 7

# Wait for user input
 read -n 1 -s -p "Press any key to continue"
 printf "\n"

# Create log file
 if [ -a "$LOG" ]; then
  rm -rf "$LOG"
 fi

 touch "$LOG"

# Some basic information to log
 today=$(date +%Y-%m-%d_%k:%M:%S)
 echo "Installation process started: $today" >"$LOG"

}

dev_mode() {

 color 1
 echo "Developer mode active" | tee -a "$LOG"
 color 7

 if [ -d TMP ]; then
  rm -rf TMP
 fi

 mkdir TMP
 cp -a TMP2/* TMP

 # Fictional folders to avoid breaking Github repos
 path="$HOME/mydir"
 iconpath="$HOME/myicondir"
 stylepath="$HOME/mystyles"

}

main() {

 color 7
 process_flags $@

 check_bash
 check_connection

 welcome

 if [ ! -d TMP ]; then
  mkdir TMP
 fi

 cd TMP

# get_files
 inflate

 detect_wm
 associate

 install_themes
 prompt_theme

 verify

 cd ..
 rm -rf TMP

 echo "Installation completed successfully" >> "$LOG"

 printf "\nFor support visit $Website\n"
 sleep 5

}

# Call main function
main $@
