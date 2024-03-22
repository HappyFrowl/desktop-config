#! /bin/bash

# System update script

set -e

echo "Welcome to Update Manager"
echo ""

update_system() {
	echo "Starting system update"
	sleep 1
	echo "Please provide password"
	echo ""

	sudo apt update
	echo ""

	sudo apt upgrade -y
	echo ""

	sudo apt dist-upgrade -y
	echo ""

	sudo apt autoremove -y
	echo ""
}

error_handling() {
	echo "An error has occurred: $1"
	exit 1
}

trap 'error_handling "Line $LINENO: Command failed with exit code $?"' ERR

update_system || error_handling "issues encountered" 

echo "Starting with FlatPak updates"

sudo flatpak update -y
sudo flatpak uninstall --unused


exit
