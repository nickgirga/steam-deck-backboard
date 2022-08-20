#!/usr/bin/env bash

# Check if Backboard is already installed
if [ -d "$HOME/.local/share/backboard" ];
then
	echo -e "Backboard is already installed!\n"
	zenity --info --ellipsize --text="Backboard is already installed!"
	exit
fi

# Check for base64
if [ "`command -v base64`" == "" ];
then
    echo -e "Fatal Error: The \"base64\" command is not accessible! Cannot continue.\n"
	zenity --error --ellipsize --text="Fatal Error: The \"base64\" command is not accessible! Cannot continue."
	exit 1
fi

# Check if Decky is installed
if [ ! -d "$HOME/homebrew" ];
then
    echo -e "Fatal Error: Decky does not appear to be installed! Please install it before continuing.\n"
	zenity --error --ellipsize --text="Decky does not appear to be installed! Please <a href=\"https://github.com/SteamDeckHomebrew/decky-loader#installation\">install it</a> before continuing."
    exit 2
fi

# Check if CSS Loader is installed
if [ ! -d "$HOME/homebrew/plugins/SDH-CssLoader" ];
then
    echo -e "Fatal Error: CSS Loader does not appear to be installed! Please install it before continuing.\n"
	zenity --error --ellipsize --text="CSS Loader does not appear to be installed! Please <a href=\"https://github.com/suchmememanyskill/SDH-CssLoader#installation\">install it</a> before continuing."
	exit 3
fi

# Ask user if they would like to install
zenity --question --ellipsize --text="Are you sure you would like to install Backboard?"
if ! [[ "$?" == "0" ]];
then
	echo -e "Exiting (user request)...\n"
	exit
fi

# Inform user of installation
zenity --info --ellipsize --text="Installing Backboard..."

# Clone repository
echo Cloning Backboard repository...
zenity --info --ellipsize --text="Cloning Backboard repository. This may take a while..."
git clone --recurse-submodules https://gitlab.com/nickgirga/steam-deck-backboard.git "$HOME/.local/share/backboard"


# Check the exit code of git
git_exit_code="$?"
if ! [[ "$git_exit_code" == "0" ]];
then
	echo -e "ERROR!: Something happened while cloning the repository (exit code $git_exit_code)!\n"
	zenity --error --ellipsize --text="ERROR!: Something happened while cloning the repository (exit code $git_exit_code)!"
	exit 4
fi

# Find current commit hash from repository
TEMP_GIT_DIR="$GIT_DIR"
GIT_DIR="$HOME/.local/share/backboard"
version="`printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"`"
GIT_DIR="$TEMP_GIT_DIR"

# Update APP_VERSION with current commit hash
sed -i "8s/.*/APP_VERSION = \"git-$version\"/"

echo -e "Finished cloning repository at revision $version!\n"
zenity --info --ellipsize --text="Finished cloning repository at revision $version!"

# Symlink desktop file to applications directory
ln -s "$HOME/.local/share/backboard/tools/backboard.desktop" "$HOME/.local/share/applications/backboard.desktop"

# Check the exit code of ln
ln_exit_code="$?"
if ! [[ "$ln_exit_code" == "0" ]];
then
	echo -e "ERROR!: Something happened while creating a symbolic link for the applications directory (exit code $ln_exit_code)!\n"
	zenity --error --ellipsize --text="ERROR!: Something happened while creating a symbolic link for the applications directory (exit code $ln_exit_code)!"
	exit 5
fi

echo -e "Created symbolic link for applications directory!\n\nDone!\n"
zenity --info --ellipsize --text="Created symbolic link for applications directory!"
zenity --info --ellipsize --text="Finished installing Backboard revision $version!"
