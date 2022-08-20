#!/usr/bin/env bash

# Check if Backboard is already installed
if [ -d "$HOME/.local/share/backboard" ];
then
	echo -e "Backboard is already installed!\n"
	zenity --info --text="Backboard is already installed!"
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
zenity --question --text="Are you sure you would like to install Backboard?"
if ! [[ "$?" == "0" ]];
then
	echo -e "Exiting (user request)...\n"
	exit
fi

# Inform user of installation
zenity --info --text="Installing Backboard..."

# Clone repository
echo Cloning Backboard repository...
zenity --info --text="Cloning Backboard repository..."
git clone --recurse-submodules https://gitlab.com/nickgirga/steam-deck-backboard.git "$HOME/.local/share/backboard"

# Check the exit code of git
git_exit_code="$?"
if ! [[ "$git_exit_code" == "0" ]];
then
	echo -e "ERROR!: Something happened while cloning the repository (exit code $git_exit_code)!\n"
	zenity --error --text="ERROR!: Something happened while cloning the repository (exit code $git_exit_code)!"
	exit 4
fi

echo -e "Finished cloning repository!\n"
zenity --info --text="Finished cloning repository!"

# Symlink desktop file to applications directory
ln -s "$HOME/.local/share/backboard/tools/backboard.desktop" "$HOME/.local/share/applications/backboard.desktop"

# Check the exit code of ln
ln_exit_code="$?"
if ! [[ "$ln_exit_code" == "0" ]];
then
	echo -e "ERROR!: Something happened while creating a symbolic link for the applications directory (exit code $ln_exit_code)!\n"
	zenity --error --text="ERROR!: Something happened while creating a symbolic link for the applications directory (exit code $ln_exit_code)!"
	exit 5
fi

echo -e "Created symbolic link for applications directory!\n\nDone!\n"
zenity --info --text="Created symbolic link for applications directory!"
zenity --info --text="Finished installing Backboard!"
