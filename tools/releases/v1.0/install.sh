#!/usr/bin/env bash

# The version to install
version="v1.0"

# Check if Backboard is already installed
if [ -d "$HOME/.local/share/backboard" ];
then
	echo -e "Backboard is already installed!\n"
	zenity --info --text="Backboard is already installed!"
	exit
fi

# Ask user if they would like to install
zenity --question --text="Are you sure you would like to install Backboard $version?"
if ! [[ "$?" == "0" ]];
then
	echo -e "Exiting (user request)...\n"
	exit
fi

# Inform user of installation
zenity --info --text="Installing Backboard $version..."

# Clone repository
echo Cloning $version Backboard repository...
zenity --info --text="Cloning $version Backboard repository..."
git clone --branch=$version --recurse-submodules https://gitlab.com/nickgirga/steam-deck-backboard.git "$HOME/.local/share/backboard"

# Check the exit code of git
git_exit_code="$?"
if ! [[ "$git_exit_code" == "0" ]];
then
	echo -e "ERROR!: Something happened while cloning the $version repository (exit code $git_exit_code)!\n"
	zenity --error --text="ERROR!: Something happened while cloning the $version repository (exit code $git_exit_code)!"
	exit 1
fi

echo -e "Finished cloning $version repository!\n"
zenity --info --text="Finished cloning $version repository!"

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
zenity --info --text="Finished installing Backboard $version!"
