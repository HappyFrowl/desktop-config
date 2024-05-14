#!/usr/bin/env bash

# System update script
set -e

echo "Welcome to Update Manager"

START_TIME=$SECONDS

update_system() {

	LOGFILE="$HOME/Desktop/testy/outcome"
	ERRORLOG="$HOME/Desktop/testy/error.log"

	sleep 1
	echo -e "Please provide password\n"
	sudo apt update
	echo $(date) >> $LOGFILE 
	echo -e "\nApt packages:\n" | tee -a $LOGFILE
	sudo apt dist-upgrade -y 2>>$ERRORLOG | tee -a  $LOGFILE
	echo ""
	sudo apt autoremove -y 2>>$ERRORLOG  | tee -a $LOGFILE
}

error_handling() {
	echo "An error has occurred: $1"
	exit 1
}

trap 'error_handling "Line $LINENO: Command failed with exit code $?"' ERR

update_system || error_handling "issues encountered"

echo -e "\nStarting with FlatPak updates:" | tee -a $LOGFILE
sudo flatpak update -y | tee -a $LOGFILE
sudo flatpak uninstall --unused | tee -a $LOGFILE

echo -e "\nTime taken to run updates:"
ELPASED_TIME=$(($SECONDS - $START_TIME))
echo $ELPASED_TIME seconds

exit
