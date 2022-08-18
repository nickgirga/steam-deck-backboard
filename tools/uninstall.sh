#!/usr/bin/env bash

# Check if Backboard is installed
if [ ! -d "$HOME/.local/share/backboard" ];
then
	echo -e "Backboard is not installed!\n"
	zenity --info --text="Backboard is not installed!"
	exit
fi

# Ask user if they would like to uninstall
zenity --question --text="Are you sure you would like to uninstall Backboard?"
if ! [[ "$?" == "0" ]];
then
	echo -e "Exiting (user request)...\n"
	exit
fi

# Inform user of uninstallation
zenity --info --text="Uninstalling Backboard..."

# Remove app data
echo Removing Backboard application data...
zenity --info --text="Removing Backboard application data..."
rm -rf "$HOME/.local/share/backboard"

# Check the exit code of rm
rm_exit_code="$?"
if ! [[ "$rm_exit_code" == "0" ]];
then
	echo -e "ERROR!: Something happened while removing the application data (exit code $rm_exit_code)!\n"
	zenity --error --text="ERROR!: Something happened while removing the application data (exit code $rm_exit_code)!"
	exit 1
fi

echo -e "Finished removing Backboard application data!\n"
zenity --info --text="Finished removing Backboard application data!"

# Remove symlink to applications directory
rm -f "$HOME/.local/share/applications/backboard.desktop"

# Check the exit code of rm
rm_exit_code="$?"
if ! [[ "$rm_exit_code" == "0" ]];
then
	echo -e "ERROR!: Something happened while removing the symbolic link for the applications directory (exit code $rm_exit_code)!\n"
	zenity --error --text="ERROR!: Something happened while removing the symbolic link for the applications directory (exit code $rm_exit_code)!"
	exit 2
fi

echo -e "Removed symbolic link for applications directory!\n\nDone!\n"
zenity --info --text="Removed symbolic link for applications directory!"
zenity --info --text="Finished uninstalling Backboard!"
