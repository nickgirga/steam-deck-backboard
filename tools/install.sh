#!/usr/bin/env bash

# Clone repository
echo Cloning Backboard repository...
git clone https://gitlab.com/nickgirga/steam-deck-backboard.git "$HOME/.local/share/backboard"

# Check the exit code of git
git_exit_code="$?"
if ! [[ "$git_exit_code" == "0" ]];
then
	echo -e "ERROR!: Something happened while cloning the repository (exit code $git_exit_code)!\n"
	exit 1
fi

echo -e "Finished cloning repository!\n"

# Symlink desktop file to applications directory
ln -s "$HOME/.local/share/backboard/tools/backboard.desktop" "$HOME/.local/share/applications/backboard.desktop"

# Check the exit code of ln
ln_exit_code="$?"
if ! [[ "$ln_exit_code" == "0" ]];
then
	echo -e "ERROR!: Something happened while creating a symbolic link for the applications directory (exit code $ln_exit_code)!\n"
	exit 2
fi

echo -e "Created symbolic link for applications directory!\n\nDone!\n"
