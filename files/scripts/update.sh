#!/usr/bin/env bash
# System update script
set -e

echo "Welcome to Update Manager"
sleep 0.5
START_TIME=$SECONDS

# Set the environment variable to noninteractive
#export DEBIAN_FRONTEND=noninteractive

update_system() {

	LOGFILE="/var/log/update/update.log"
	ERRORLOG="/var/log/update/error.log"

	echo -e "Please provide password\n"
	apt update
	echo -e "\n$(date)" >> $LOGFILE
	echo -e  "\nApt packages:" | tee -a $LOGFILE
	apt dist-upgrade -y 2>>$ERRORLOG | tee -a $LOGFILE
	echo ""
	apt autoremove -y 2>>$ERRORLOG  | tee -a $LOGFILE
}

error_handling() {
	echo "An error has occurred: $1"
	exit 1
}

trap 'error_handling "Line $LINENO: Command failed with exit code $?"' ERR

update_system || error_handling "issues encountered"

echo -e "\nFlatPak updates:" | tee -a $LOGFILE
flatpak update -y  | tee -a $LOGFILE
flatpak uninstall --unused | tee -a $LOGFILE

echo -e "\nTime taken to run updates:"
ELPASED_TIME=$(($SECONDS - $START_TIME))
echo $ELPASED_TIME seconds

exit
