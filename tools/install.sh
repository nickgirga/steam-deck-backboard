#!/usr/bin/env bash

# Check if Backboard is already installed
if [ -d "$HOME/.local/share/backboard" ];
then
	echo -e "Backboard is already installed!\n"
	zenity --info --text="Backboard is already installed!"
	exit
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
	exit 1
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
	exit 2
fi

echo -e "Created symbolic link for applications directory!\n\nDone!\n"
zenity --info --text="Created symbolic link for applications directory!"
zenity --info --text="Finished installing Backboard!"
