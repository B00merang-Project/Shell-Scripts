#!/bin/bash

# Installation script based on WinX TP script, from B00merang
# Author: Elbullazul (Christian Medel)
# Date: 10/24/16

# Defining global variables
Website="http://b00merang.weebly.com"
LOG="$PWD/install.log"

# Installation paths
t2url="/usr/share/tint2"
themeurl="/usr/share/themes"
iconurl="/usr/share/icons"
imgurl="/usr/share/wallpapers"
appleturl="/usr/share/cinnamon/applets"
stylesurl="/usr/share/styles"

# Set themes to install
theme="Windows 10 Light" #alternative: Windows 10 Dark
icon_theme="Windows 10"

# Developers only - enable testing mode, now file download required
testing="no"

# Variable defining whether install is local/global
locvar="global"

# TransPack versioning variables
version="1.2.1-release"

# Force install a DE
override='false'

# ------------------------------ PREPARING TMP ENVIRONMENT FUNCTION ------------------------------- #
get_tmp() {

  # Switch to green text
  tput setaf 2;

  # Add state to log
  echo 'Creating TMP environment' >>"$LOG"

  # Remove TMP if present, avoid duplicates

  if [ -d tmp ]; then
    echo "Removing previous installation resources..." | tee -a "$LOG"
    rm -rf tmp
  fi

  # Create and enter TMP folder
  mkdir tmp
  cd tmp

  # If not in testing, get files
  if [ "$testing" == "no" ]; then
    get_zip
  else
    echo "Getting files locally..."
    printf "\n"
    cp ../RES/* "$TMP"
  fi

  # checksums verification
#  sumcheck="$(cat "$1" | grep SHA512)"
#  sum=${sumcheck#"SHA512: "}

#  chk="$(sha512sum $pkg)"
#  chk=${chk%" $pkg"}
#  if [ $chk == $sum ]; then
#    echo "Package integrity procedure passed. Installing..."
#  else
#    echo "Package integrity procedure failed. Update database!"
#    exit
#  fi

  # 

  # Verify files are REALLY here and avoid continuing if not
  if [ ! -e master.zip ]; then
    tput setaf 1; echo "" | tee -a "$LOG"
    exit
  fi

  if [ ! -e icons.zip ]; then
    tput setaf 1; echo "File download failed. Check internet connection" | tee -a "$LOG"
    exit
  fi

  if [ ! -e windows_x11.zip ]; then
    tput setaf 1; echo "File download failed. Check internet connection" | tee -a "$LOG"
    exit
  fi

  # Unzip files
  zipgtk=$(unzip master.zip | sed -n '1p')
  zipicon=$(unzip icons.zip | sed -n '1p')
  zipx11=$(unzip windows_x11.zip | sed -n '1p')

  # Register first line of unzip command to get eventual errors
  echo "$zipgtk" >>"$LOG"
  echo "$zipicon" >>"$LOG"
  echo "$zipx11" >>"$LOG"

  # Rename themes Folder
  mv Windows-10-master GTK

  # Rename Icon folder
  mv Windows-10-icons "$icon_theme"

  # Go to white text
  tput setaf 7;

  # Security for function operation
  cd "$TMP"

}

# ---------------------------- DOWNLOAD ZIP FILES FUNCTION ----------------------------- #

get_zip() {

  # Download from rolling branch
  echo "Downloading archives..." | tee -a "$LOG"

  # Get GTK theme
  wget https://github.com/B00merang-Project/Windows-10/archive/master.zip -q --show-progress

  # Get icon theme
  wget https://github.com/B00merang-Project/Windows-10/archive/icons.zip -q --show-progress

  # Get X11 theme from website (no other hosting)
  wget http://b00merang.weebly.com/uploads/1/6/8/1/16813022/windows_x11.zip -q --show-progress

}

# ------------------------------ REMOVE CLUTTER FUNCTION ------------------------------- #

clean() {

# Security measure
  cd "$TMP"

# Variables allowing to pass all parameters
  runtimes="$1"
  runs=1

# Parameters array for easier processing
  declare -a files
  files=("$@")

  cd GTK

# Remove files light/dark theme
  while [[ $runs -le $runtimes ]]
  do
    rm -rf */"${files[$runs]}"
    runs=$(($runs+1))
  done

#  cd "../Windows 10 Dark"

# Remove same files in dark theme
#  runs=1
#  while [[ $runs -le $runtimes ]]
#  do
#    rm -rf "${files[$runs]}"
#    runs=$(($runs+1))
#  done

# Returning to TMP

  cd "$TMP"
}

# ------------------------------ GLOBAL THEME INSTALL FUNCTION ------------------------------- #

install_theme() {

  cd "$TMP/GTK"

# Move theme folders to chosen emplacement
  sudo cp -f -a Windows\ 10\ Light "$themeurl"
  sudo cp -f -a Windows\ 10\ Dark "$themeurl"

# Make readable for all users
  sudo chown root "$themeurl/Windows 10 Light" "$themeurl/Windows 10 Dark"
  sudo chmod +wr -R "$themeurl/Windows 10 Light" "$themeurl/Windows 10 Dark"

# Install Icon & X11 themes
  cd ..
  sudo cp -f -a "$icon_theme" "$iconurl"

  # Since X11 theme is not in rolling state, we can disable force-install
  if [ ! -d "$iconurl/win8" ]; then
    sudo cp -a win8 "$iconurl"
    sudo chown root "$iconurl/win8"
    sudo chmod +r -R "$iconurl/win8"
  fi

# Make icon theme readable for all users
  sudo chown root "$iconurl/$icon_theme"
  sudo chmod +r -R "$iconurl/$icon_theme"
}

# ------------------------------ LOCAL THEME APPLIANCE FUNCTION ------------------------------- #

install_theme_local() {
  cd "$TMP/GTK"

# Copy theme files to corresponding folders
  cp -a Windows\ 10\ Light "$themeurl"
  cp -a Windows\ 10\ Dark "$themeurl"
  cd ..

# Copy icon theme to corresponding folders
  cp -a "$icon_theme" "$iconurl"

ls

  # Since X11 theme is not in rolling state, we can disable force-install
  if [ ! -d "$iconurl/win8" ]; then
    cp -a win8 "$iconurl"
  fi

}

# ------------------------------ APPLET DOWNLOAD FUNCTION ------------------------------- #

applet_get() {

  # Window-list
  wget -q --show-progress http://b00merang.weebly.com/uploads/1/6/8/1/16813022/windowlistgroup_jake.phy_gmail.com.zip

  zipwlg=$(unzip windowlistgroup_jake.phy_gmail.com.zip | sed -n '1p')

  # Slingshot launcher
  wget -q --show-progress http://b00merang.weebly.com/uploads/1/6/8/1/16813022/slingshot_jfarthing84.zip

  zipsng=$(unzip slingshot_jfarthing84.zip | sed -n '1p')

  # Save unzip result
  echo "$zipwlg" >>"$LOG"
  echo "$zipsng" >>"$LOG"
}

# ------------------------------ THEME APPLIANCE FUNCTION ------------------------------- #

apply_theme() {

# Here is where DE variable gets important

  tput setaf 3; echo "Applying changes to $DE" | tee -a "$LOG"

  case $DE in

    cinnamon)
      gsettings set org.cinnamon.theme name "$theme"
      gsettings set org.cinnamon.desktop.interface gtk-theme "$theme"
      gsettings set org.cinnamon.desktop.wm.preferences theme "$theme"
      gsettings set org.cinnamon.desktop.interface icon-theme "$icon_theme"

      # Code fetched from Feren OS Themer (https://github.com/feren-OS/feren-Themer-Source-Code)
      # Make Cinnamon panel look like Windows 10 Taskbar
      # Install Cinnamon applets

      # Install applets, global or local
      if [ $locvar == "global" ]; then

        # See if WindowListGroup is installed
        if [ -d "$appleturl/WindowListGroup@jake.phy@gmail.com" ]; then
          echo "Removing WindowListGroup applet previously installed" >>"$LOG"
          sudo rm -rf "$appleturl/WindowListGroup@jake.phy@gmail.com"
        fi

        # See if Slingshot is installed
        if [ -d "$appleturl/slingshot@jfarthing84" ]; then
          echo "Removing WindowListGroup applet previously installed" >>"$LOG"
          sudo rm -rf "$appleturl/slingshot@jfarthing84"
        fi

        # Install applets
        applet_get
        
        # Save installation message
        wlgmv=$(sudo mv WindowListGroup@jake.phy@gmail.com "$appleturl")
        sngmv=$(sudo mv slingshot@jfarthing84 "$appleturl")

      else

        # For user-ease, no remove if locally installed
        if [ ! -d "$appleturl/WindowListGroup@jake.phy@gmail.com" ] || [ ! -d "$appleturl/slingshot@jfarthing84" ]; then
          # Get applet zip file
          applet_get        

          # Move applets to local applet folder
          wlgmv=$(mv WindowListGroup@jake.phy@gmail.com "$appleturl")
          sngmv=$(mv slingshot@jfarthing84 "$appleturl")

        fi
      fi

      # Save installation message to LOG
      echo "$wlgmv" >>"$LOG"
      echo "$sngmv" >>"$LOG"

      # Use GSettings to change panel config
      gsettings set org.cinnamon enabled-applets "['panel1:left:0:slingshot@jfarthing84', 'panel1:left:1:WindowListGroup@jake.phy@gmail.com', 'panel1:right:0:notifications@cinnamon.org', 'panel1:right:1:user@cinnamon.org', 'panel1:right:2:removable-drives@cinnamon.org', 'panel1:right:3:keyboard@cinnamon.org', 'panel1:right:4:bluetooth@cinnamon.org', 'panel1:right:5:network@cinnamon.org', 'panel1:right:6:sound@cinnamon.org', 'panel1:right:7:power@cinnamon.org', 'panel1:right:8:systray@cinnamon.org', 'panel1:right:9:calendar@cinnamon.org', 'panel1:right:10:windows-quick-list@cinnamon.org']"

      # Apply wallpaper
      gsettings set org.cinnamon.desktop.background picture-uri  "file://$imgurl/windows-10/wallpaper.jpg"
      ;;

     gnome)
      # Install user theme extension (disabled, still searching to get correct package manager

      # Code from http://unix.stackexchange.com/questions/46081/identifying-the-system-package-manager
      # Search for correct package manager
      declare -A osInfo;
      osInfo[/etc/redhat-release]=yum
      osInfo[/etc/arch-release]=pacman
      osInfo[/etc/gentoo-release]=emerge
      osInfo[/etc/SuSE-release]=zypper
      osInfo[/etc/fedora-release]=dnf
      osInfo[/etc/debian_version]=apt-get

      # Default pakage manager is APT
      pkgman='apt'

      for f in ${!osInfo[@]}
      do
        if [[ -f $f ]];then
          echo "Package manager: ${osInfo[$f]}" >>"$LOG"
          pkgman="${osInfo[$f]}"
        fi
      done
      
      # Proceed with installation
      tput setaf 2
      echo "Installing User Theme extension for Gnome Shell" | tee -a "$LOG"

      sudo "$pkgman" install gnome-shell-extension-user-theme >>"$LOG"
      tput setaf 7

      # Apply theme
      gsettings set org.gnome.shell.extensions.user-theme name "$theme"
      gsettings set org.gnome.desktop.interface gtk-theme "$theme"
      gsettings set org.gnome.desktop.wm.preferences theme "$theme"
      gsettings set org.gnome.desktop.interface icon-theme "$icon_theme"

      # Apply Wallpaper
      gsettings set org.gnome.desktop.background picture-uri "file://$imgurl/windows-10/wallpaper.jpg"
      ;;

     lxde)
      # Configuration file edition required
      tput setaf 3; echo "Lxde supports only manual input to change themes. Please do so by opening the corresponding Tweak tool"; tput setaf 7
      ;;

     mate)
      # Maybe this is REALLY outdated...
      tput setaf 3; echo "The method used to apply icons may not be the latest. If it does not work, please apply the themes yourself"; tput setaf 7

      mateconftool-2 --type=string --set /desktop/mate/interface/gtk_theme "$theme"
      mateconftool-2 --type=string --set /apps/marco/general/theme "$theme"
      # Search for way to set icon theme from terminal
      ;;

     unity)
      gsettings set org.gnome.desktop.interface gtk-theme "$theme"
      gsettings set org.gnome.desktop.wm.preferences theme "$theme"
      gsettings set org.gnome.desktop.interface icon-theme "$icon_theme"

      # Set Unity to be a little more Windowish
      gsettings set com.canonical.Unity.Launcher launcher-position Bottom
      gsettings set com.canonical.Unity form-factor 'Desktop'

      # Apply Wallpaper
      gsettings set org.gnome.desktop.background picture-uri "file://$imgurl/windows-10/wallpaper.jpg"
      ;;

     xfce)
      xfconf-query -c xsettings -p /Net/ThemeName -s "$theme"
      xfconf-query -c xfwm4 -p /general/theme -s "$theme"
      xfconf-query -c xsettings -p /Net/IconThemeName -s "$icon_theme"
      ;;

     *)
      tput setaf 3; echo "Cannot apply changes for your current configuration: $DE"; tput setaf 7
      echo "Unsupported Desktop environment: $DESKTOP_SESSION" >>"$LOG"
#      return [n]
      ;;

  esac

# Apply Windows Aero X11 theme (disabled for now)

  echo "X11 cursor theme is installed, but cannot be applied automatically. Please do so in your System settings or tweak tool"

# Create security copy
#  sudo cp "$iconurl"/default/index.theme "$iconurl"/default/my-index.theme

# Create file and replace instead
#  echo '[Icon Theme]' >index.theme
#  echo 'Inherits=win8' >>index.theme

# Copy file over
#  sudo cp -rf index.theme "$iconurl"/default/index.theme

# Create index for user only, because X.org...
#  if [ ! -d ~/.icons ]; then
#    mkdir ~/.icons
#    mkdir ~/.icons/default
#  fi

# Make backup if custom cursor is set
#  if [ -a ~/.icons/default/index.theme ]; then
#    cp ~/.icons/default/index.theme ~/.icons/default/index2.theme 
#  fi

#  printf '[Icon Theme]\nInherits=win8' >~/.icons/default/index.theme
#  echo "X11 theme applied successfully" >>"$LOG"

#  tput setaf 2; echo "Changes applied successfully" | tee -a "$LOG"
#  printf "\nFinishing configuration..."
}

# ------------------------------ GET FLAGS FUNCTION ------------------------------- #

get_flags() {

  declare -a flags
  flags=("$@")

# We used getopts to manage flags, but DE override says no
  for f in ${!flags[@]}
  do
    case ${flags[$f]} in

    -h)
      # Help for TransPack
      printf "Available flags\n -h         Show help\n"
      printf " -t         Enable testing mode for development, or installation from local resources\n"
      printf " -w         Option coming soon...\n"
      printf " -v         Get TransPack versioning and information\n"
      echo "More info or help @ $Website/TransPack.html"

      exit
      ;;

    --set-de)
      # Force install some DE

      echo "User chose to force override DE: ${flags["$f+1"]}" >"$LOG"
      override="${flags["$f+1"]}"

      declare -A deskenv;
      deskenv[gnome]="gnome-shell"
      deskenv[cinnamon]="mutter"
      deskenv[unity]="compiz"
      deskenv[lxde]="openbox"
      deskenv[fluxbox]="fluxbox"
      deskenv[mate]="marco"
      deskenv[xfce]="xfce"

      for f in ${!deskenv[@]}
      do
        if [[ $override == $f ]];then
          echo "WM set to $f"
          new_WM=${deskenv[$f]}
        fi
      done
      ;;

    -v)
      # Versioning info
      tput setaf 4;
      echo "B00merang TransPack $version"
      echo "----------------------------"
      tput setaf 6;
      echo "Transformation Pack script for Linux desktop. Compatibility list found @ $Website/TransPack.html"
      exit
      ;;

    -l)
      # Reset paths to local folders
      locvar="local"
      t2url="/home/$USER/.config/tint2"
      themeurl="/home/$USER/.themes"
      iconurl="/home/$USER/.icons"
      appleturl="/home/$USER/.local/share/cinnamon/applets"
      stylesurl="/home/$USER/.fluxbox/styles"
      imgurl="/home/$USER/.local/share/wallpapers"
      ;;

    -t)
      # Enable testing mode to install from local resources
      tput setaf 3
      echo "Testing mode enabled" | tee -a "$LOG"
      testing="yes"
      tput setaf 7
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

#-------------------------------- AUTHENTIFY INSTALL FUNCTION ---------------------------------#

verify() {

  isok="ok"

# Verify if themes installed OK
  if [ ! -d "$themeurl/Windows 10 Light" ]; then
    isok='GTK theme'
    return
  fi

# Verify if icon theme OK
  if [ ! -d "$iconurl/Windows 10" ]; then
    isok='Icon theme'
    return
  fi

# Verify if X11 theme OK
  if [ ! -d "$iconurl/win8" ]; then
    isok='X11 theme'
    return
  fi

# Verify wallpaper OK
  if [ ! -f "$imgurl/windows-10/wallpaper.jpg" ]; then
    isok='Wallpaper'
    return
  fi

  return

}

#------------------------------------- THEME CHOSE FUNCTION ------------------------------------#

theme() {

  if [ $DE == 'gnome' ]; then
    read -n 1 -p "Windows 10 Light = 1   Windows 10 Dark = 2   Metro Dark = 3 [1]:" choice
    max=3
  else
    read -n 1 -p "Windows 10 Light = 1   Windows 10 Dark = 2 [1]:" choice
    max=2
  fi

  # Check if input is supported integer
  if ! [[ "$choice" =~ ^[1-"$max"]+$ ]]; then
    printf "\nPlease chose a number between 1 and $max!\n"
    theme #Re-ask for theme choice
  fi

  # Assign choices according to user input; default is 1
  case $choice in
    2)
      theme="Windows 10 Dark"
    ;;
    3)
      echo "User selected Global Dark theme" >>"$LOG"
      theme="Windows 10 Dark"

      # Making GTK apply Dark theme everywhere (restart required?)
      echo "[Settings]" > "/home/$USER/.config/gtk-3.0/settings.ini"
      echo "gtk-application-prefer-dark-theme=1" >> "/home/$USER/.config/gtk-3.0/settings.ini"
    ;;
  esac
}

# ------------------------------ HERE STARTS EXECUTION ------------------------------- #

# Apply flags (if any)
  if [ ! $# -eq 0 ]; then
    get_flags $@
  fi

# Welcome message
  tput setaf 4; echo "Welcome to the B00merang Theme Installer. For usability support, visit $Website/TransPack.html"; printf "\n"; tput setaf 7

# Wait for user input
  read -n 1 -s -p "Press any key to continue"
  printf "\n"

# Create log file
  touch "$LOG"

# Some basic information to log
  today=`date +%Y-%m-%d_%k:%M:%S`
  echo "Installation process started: $today" >"$LOG"

# Some compatibility measures
  bash_v="$(echo "$BASH_VERSION" | cut -c1-1)"
  
  if [ $bash_v -lt 4 ]; then
    tput setaf 1
    echo "GNU Bash 4.0 or higher is needed to execute this script correctly. You have $BASH_VERSION" | tee -a "$LOG"
    exit #Useless to continue execution
  else
    tput setaf 2
    echo "GNU Bash is compatible: $BASH_VERSION" | tee -a "$LOG"
  fi

# Check Internet connection
  echo -e "GET http://github.com HTTP/1.0\n\n" | nc github.com 80 > /dev/null 2>&1

  if [ $? -eq 0 ]; then
    tput setaf 2; echo "Internet connection detected" | tee -a "$LOG"; tput setaf 7
  else
    tput setaf 1; echo "Internet connection needed. Please connect and retry" | tee -a "$LOG"
    exit
  fi

# Get Window manager Name
  WM="$(xprop -id $(xprop -root -notype | awk '$1=="_NET_SUPPORTING_WM_CHECK:"{print $5}') -notype -f _NET_WM_NAME 8t | grep _NET_WM_NAME)"

# Get NET name
  WM=${WM#'_NET_WM_NAME = "'}
  WM=${WM%'"'}

# Lower case WM name
  WM=${WM,,}
  printf "\n"

# Notify Window manager
  tput setaf 3; echo "Identified Window manager. Waiting for association..." | tee -a "$LOG"; tput setaf 7

# Desktop Environment variable
  DE="Unknown" #Avoid getting NULL value somewhere

# Shortcut to avoid 'cd ../../..'
  TMP=$PWD/tmp

# register work folder
  echo "Work directory is: $TMP" >>"$LOG"

# Preparing tmp environment
  get_tmp

# Obtain root permissions only if Global installed selected
  if [ $locvar == "global" ]; then
    tput setaf 1; echo "Root access is required for a system-wide installation. Please authentify to continue" | tee -a "$LOG"
    sudo echo "Access acquired. Proceeding with installation" | tee -a "$LOG"
    tput setaf 2;
  fi

# copy wallpaper, first see if directories exist

  wlp='false' #Assuming folder exists doesn't exist
  winwlp='false' #Assuming windows-10 wallpaper folder doesn't exist

  # Check if folders exist
  if [ -d "$imgurl" ]; then
    wlp='true'
  fi

  if [ -d "$imgurl/windows-10" ]; then
    winwlp='true'
  fi

  # Make corresponding folders according to install choice
  if [ "$locvar" == "global" ]; then

    case $wlp in
      false) sudo mkdir "$imgurl";;
    esac
    case $winwlp in
      false) sudo mkdir "$imgurl/windows-10";;
    esac

    # Copy image
    cd GTK/Windows\ 10\ Light
    sudo cp -f wallpaper.jpg "$imgurl/windows-10"

  else

    case $wlp in
      false) mkdir "$imgurl";;
    esac
    case $winwlp in
      false) mkdir "$imgurl/windows-10";;
    esac

    # Copy image
    cd GTK/Windows\ 10\ Light
    cp -f wallpaper.jpg "$imgurl/windows-10"
  fi

# return to TMP
  cd "$TMP"

# Function if user wants forced install
  if [ "$override" != 'false' ]; then
    WM=$new_WM
  fi

# Case to clean unnecessary stuff & launch installation
  case $WM in

    *muffin*)
      DE="cinnamon"
      clean 11 extra-icons fluxbox gnome-shell openbox-3 Plasma\ 5 README.md tint2 unity xfce-notify-4.0 xfwm4 wallpaper.jpg
      ;;

    *gnome*)
      DE="gnome"
      clean 12 cinnamon extra-icons fluxbox metacity-1 openbox-3 Plasma\ 5 README.md tint2 unity xfce-notify-4.0 xfwm4 wallpaper.jpg
      ;;

    *xfwm*)
      DE="xfce"
      clean 11 cinnamon extra-icons fluxbox gnome-shell metacity-1 openbox-3 Plasma\ 5 README.md tint2 unity wallpaper.jpg
      ;;

    *compiz*)
      DE="unity"
      clean 12 cinnamon extra-icons fluxbox gnome-shell metacity-1 openbox-3 Plasma\ 5 README.md tint2 xfce-notify-4.0 xfwm4 wallpaper.jpg
      ;;

    *marco*)
      DE="mate"
      clean 12 cinnamon extra-icons fluxbox gnome-shell openbox-3 Plasma\ 5 README.md tint2 unity xfce-notify-4.0 xfwm4 wallpaper.jpg
      ;;

    *openbox*)
      DE="lxde" # May or may not be LXDE, need to add confirmation code here
      clean 11 cinnamon extra-icons fluxbox gnome-shell metacity-1 Plasma\ 5 README.md unity xfce-notify-4.0 xfwm4 wallpaper.jpg

      # Remove or not tint2rc if tint2 is installed
      if [ -a /usr/bin/tint2 ]; then
        mkdir "$t2url/Windows-10"
        cd GTK/Windows\ 10\ Light/tint2
        sudo cp tint2rc "$t2url/Windows-10"
      fi

      # Remove folder anyways to save space
      cd "$TMP/GTK/Windows 10 Light"
      rm -rf tint2
      cd ../Windows\ 10\ Dark
      rm -rf tint2
      ;;

    *fluxbox*)
      DE="fluxbox"
      clean 12 cinnamon extra-icons fluxbox gnome-shell metacity-1 openbox-3 Plasma\ 5 README.md tint2 unity xfce-notify-4.0 xfwm4 wallpaper.jpg

      # Copy styles to styles folder, and remove from GTK block

      if [ $locvar == "global" ]; then
        # For global installation, SUDO is required

        cd GTK/Windows\ 10\ Light/fluxbox
        sudo cp -a Windows\ 10 "$stylesurl"

        cd ../../Windows\ 10\ Dark/fluxbox
        sudo cp -a Windows\ 10 Dark "$stylesurl"

        # Delete both folders same time
        cd "$TMP/GTK"
        rm -rf */fluxbox

      else

        # Local install to home folder
        cd GTK/Windows\ 10\ Light/fluxbox
        cp -a Windows\ 10 "$stylesurl"

        cd ../../Windows\ 10\ Dark/fluxbox
        cp -a Windows\ 10 Dark "$stylesurl"

        # Delete both folders same time
        cd "$TMP/GTK"
        rm -rf */fluxbox

      fi

      # Go back to TMP
      cd "$TMP"
      ;;

    *)
      # Install GTK theme only, if no DE recognized
      tput setaf 1; echo "We have been unable to associate your Desktop Environment. Executing Legacy Installation"; tput setaf 7
      echo "Unknown Desktop Environment. Proceeding with Legacy installation..." >>"$LOG"
      ;;
  esac

# debugging purposes
  if [ "$WM" != "Unknown" ]; then
    echo "$WM detected as Window manager, assuming $DE" >>"$LOG"
  else
    echo "$WM has no known DE associated with it" >>"$LOG"
  fi

# Call theme chose function
  echo "You can apply a Dark or a Light variant of this theme. Both will be installed anyways"
  theme

# Call theme install function according to install choice
  echo "User selected $locvar installation" >>"$LOG"
  if [ $locvar == "global" ]; then
    install_theme
  else
    install_theme_local
  fi

# Check if all files are really where they should
  verify

  if [ "$isok" != "ok" ]; then
    echo ""
    echo "$isok theme didn't install correctly. Exiting..." >>"$LOG"
    tput setaf 1; echo "$isok installation failed. Check log to get more details"; tput setaf 7
    exit
  fi

# Apply themes
  apply_theme

# Removing TMP files
  tput setaf 3
  printf "Removing temporary files...\n" | tee -a "$LOG"
  cd "$TMP/.."
  rm -rf tmp

# Success color
  tput setaf 2
  echo "The theme was successfully installed and applied. Thank you for using our theme installer!"
  echo "Installation successful. Exiting..." >>"$LOG"; tput setaf 7

  sleep 5
