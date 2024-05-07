#!/usr/bin/env bash

# System update script
set -e

START_TIME=$SECONDS

set -e

echo "Welcome to Update Manager"

update_system() {

	echo "Starting system update"
	sleep 1
	echo "Please provide password"
	echo ""

	sudo apt update
	echo ""
	echo -e "Apt packages:\n" > ~/Desktop/testy/outcome
	sudo apt dist-upgrade -y 2>/dev/null | tee -a  ~/Desktop/testy/outcome
	echo ""

	sudo apt autoremove -y 2>/dev/null | tee -a ~/Desktop/testy/outcome
	echo ""
}

error_handling() {
	echo "An error has occurred: $1"
	exit 1
}

trap 'error_handling "Line $LINENO: Command failed with exit code $?"' ERR

update_system || error_handling "issues encountered"

echo "Starting with FlatPak updates:"
echo -e "FlatPak:\n" >> ~/Desktop/testy/outcome
sudo flatpak update -y | tee -a ~/Desktop/testy/outcome
sudo flatpak uninstall --unused

echo ""
echo "Time taken to run updates:"
ELPASED_TIME=$(($SECONDS - $START_TIME))
echo $ELPASED_TIME seconds

exit
