#!/bin/bash

# Software variables
version="R7.1"

LOG="$PWD/install.log"
path="/usr/share/themes"
t2path="/usr/share/tint2"
iconpath="/usr/share/icons"
stylepath="/usr/share/styles"

theme_name="Windows 10 Light"
icon_theme="Windows 10 Icons"

WM="Unknown"
DE="Unknown"

check_net=true
testing=false

Website="http://b00merang.weebly.com"

# --- Misc functions to simplify programming ---
download() {

 wget $1 -q --show-progress

 file="$(basename $1)"
 mv "$file" $2

}

color() {

 # keep colors here in array to facilitate stuff
 declare -a colors
 colors=( black red green yellow blue magenta cyan white gray )
 found=false

 for f in "${!colors[@]}"
 do
  if [ "$1" == "${colors[$f]}" ]; then
   tput setaf $f
   found=true
  fi
 done

 if [ "$found" = true ]; then
  log 'Wrong color number'
 fi

}

output() {
 echo "$1: $2" | tee -a "$LOG"
}

log() {
 echo "$1" >> "$LOG"
}

# --- Verification and integrity functions ---

check_bash() {

 bash_v="$(echo "$BASH_VERSION" | cut -c1-1)" # since we need bash 4.x, get first name

 if [ "$bash_v" -lt 4 ]; then
  color red
  output "GNU Bash 4.0 or higher is needed to execute this script correctly. You have $BASH_VERSION"
  exit # Useless to continue execution
 else
  color green
  output "GNU Bash is compatible: $BASH_VERSION"
 fi

}

check_connection() {

 if [ "$check_net" = true ]; then

   echo -e "GET http://github.com HTTP/1.0\n\n" | nc github.com 80 > /dev/null 2>&1

   # If there is any value > 0 in ? variable
   if [ $? -eq 0 ]; then
    color green
    output "Internet connection detected"
    color white
   else
    color red
    output "Internet connection needed. Please connect and retry"
    exit
   fi
 else
  log 'Check_connection was disabled for this run'
 fi

}

check_dependencies() {

  # xprop
  if [ -a /usr/bin/xprop ]; then
   log "xprop is installed. Proceding..."
  else
   color red
   output "Xprop is needed to detect your DE. Please install it or use manual DE override to install this theme (-h to see help)"
  fi

  # netcat (nc)
  if [ -a /bin/nc ]; then
   log "netcat is installed. Proceding..."
  else
   output "Netcat is needed to test your internet connection. Please install it or use no-check mode (-h to see help)"
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
   output "Something went wrong while installing: $isok. Aborting..."
   exit
  else
   log "All files installed correctly"
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

 output "Themes uninstalled successfully"
 
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
      printf "\nAvailable flags\n"
      printf " -h         Show help\n"
      printf " -t         Enable testing mode for development\n"
      printf " -v         Get TransPack versioning and information\n"
      printf " -l         Install themes to local folders\n"
      printf " -n         Doesn't check for internet connection\n"
      printf " --set-de   Force install theme for specific Desktop environment\n"

      color blue
      printf "\n***supported DEs***\n"

      color white
      printf " - gnome\n - unity\n - cinnamon\n - lxde\n - fluxbox\n - openbox\n - mate"

      color yellow
      printf " (experimental)\n\n"

      color white
      echo "More info or help @ $Website/TransPack.html"

      exit
      ;;

    --set-de)
      # Force install some DE
      log "User chose to force override DE: ${flags["$f+1"]}"

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
      color blue
      echo -e "B00merang TransPack $version\n"
      color cyan
      echo -e "Transformation Pack script for Linux desktops \nCompatibility list found @ $Website/TransPack.html"


      color white
      echo -e "\n***Credits***\nChristian Medel (Elbullazul)\nBrandon Camilleri (brandleesee)\nXavier Brusselaers (GroumphyOriginal)\nManuel Transfeld (auipga)"
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
    -n|--no-check)
      check_net=false
      ;;

    # Avoid breaking execution for supported DEs for force install
    gnome|cinnamon|lxde|mate|unity|fluxbox|xfce)
      ;;

    *)
      output "Unvalid option/argument. Aborting..."
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
  y|Y) log "User selected auto-application"
   echo "Themes available:"
   color white
   echo " (1) Windows 10 Light"

   color gray
   echo " (2) Windows 10 Dark"

   color black
   echo " (3) Windows 10 Metro"
   color white

   # Loop while theme is not what we listed
   get_input
   apply
  ;;

  n|N)
   output "No theme will be applied"
  ;;
 esac

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

 if [ "$testing" = false ]; then

  output 'Downloading files...'

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

 fi

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
  color yellow
  output "Identified Window manager. Waiting for association..."
  color white

  echo "" # new line

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
      color red
      echo "We have been unable to associate your Desktop Environment. Executing Legacy Installation"
      color white
      log "Unknown Desktop Environment. Proceeding with Legacy installation..."
      ;;
  esac

 # Record to log which WM is detected and if any association has occurred
  if [ "$WM" != "Unknown" ]; then
    log "$WM detected as Window manager, assuming $DE"
  else
    log "$WM has no known DE associated with it"
  fi

}

inflate() {

 log "Extracting files"

  # Unzip files & store first output line to variable
  zipgtk=$(unzip light.zip | sed -n '1p')
  zipgtk=$(unzip dark.zip | sed -n '1p')
  zipgtk=$(unzip metro.zip | sed -n '1p')
  zipicon=$(unzip icons.zip | sed -n '1p')
  zipx11=$(unzip win8.zip | sed -n '1p')

 log "Renaming files"

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

 log "Installing themes in $path and icons in $iconpath"
 
}

apply() {

# Here is where DE variable gets important
  color yellow
  output "Applying $theme_name to: $DE"

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
      color yellow
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
      color white
      ;;

     mate)
      # Maybe this is REALLY outdated...
      color yellow
      echo "The method used to apply icons may not be the latest. If it does not work, please apply the themes yourself"
      color white

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
      log "Unsupported Desktop environment: $DESKTOP_SESSION"
      ;;
  esac

  color cyan

  # User must manually choose X11 theme, but it's a big mess anyways...
  echo "X11 cursor theme is installed, but cannot be applied automatically. Please do so in your System settings or tweak tool"

  color white

}

welcome() {

# Welcome message
 color blue
 printf "Welcome to the B00merang Theme Installer\n"
 color white

# Create log file
 if [ -a 'install.log' ]; then
  rm -rf "install.log"
 fi

 touch "$LOG"

# Wait for user input
 read -n 1 -s -p "Press any key to continue"
 printf "\n"

# Some basic information to log
 today=$(date +%Y-%m-%d_%k:%M:%S)
 log "Installation process started: $today"

}

dev_mode() {

 color red
 output "Developer mode active"
 color white

 # remove previous installation files (if any)
 if [ -d TMP ]; then
  rm -rf TMP
 fi

 mkdir TMP
 cp -a TMP2/* TMP

 # Fictional folders to avoid breaking Github repos
 path="$HOME/mydir"
 iconpath="$HOME/myicondir"
 stylepath="$HOME/mystyles"

 testing=true

}

main() {

 color white
 process_flags $@

 check_dependencies
 check_bash
 check_connection

 welcome

 if [ ! -d TMP ]; then
  mkdir TMP
 fi

 cd TMP

 get_files
 inflate

 detect_wm
 associate

 install_themes
 prompt_theme

 verify

 cd ..
 rm -rf TMP

 log "Installation completed successfully"

 printf "\nFor support visit $Website\n"
 sleep 5

}

# Call main function
main $@
