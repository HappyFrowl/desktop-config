#!/usr/bin/env bash
# System update script
set -e

# Set the environment variable to noninteractive
export DEBIAN_FRONTEND=noninteractive

# Set paths
LOGFILE="/var/log/update/update.log"
ERRORLOG="/var/log/update/error.log"

# Functions:

update() {
	echo -e "Please provide password\n"
    sudo apt update
    echo -e  "\nApt packages:" | tee -a ${LOGFILE}
    sudo apt dist-upgrade -y 2>>${ERRORLOG} | tee -a ${LOGFILE}
}

cleanup() {
    sudo apt autoremove -yy 2>>${ERRORLOG} | tee -a ${LOGFILE}
	sudo apt autoclean 2>>${ERRORLOG} | tee -a ${LOGFILE}
}

update_flatpak() {
	echo -e "\nFlatPak updates:" | tee -a ${LOGFILE}
	flatpak update -y  | tee -a ${LOGFILE}
}

cleanup_flatpak() {
	flatpak uninstall --unused -y | tee -a  ${LOGFILE}
}

# Execution

echo "Welcome to Update Manager"
echo -e "\n$(date)" | tee -a ${LOGFILE}
START_TIME=$SECONDS

update
cleanup
update_flatpak
cleanup_flatpak

echo "----------------------------------------"
echo "-        Update completed              -"
echo "----------------------------------------"
echo -e "\nTime taken to run updates:"
ELPASED_TIME=$((${SECONDS} - ${START_TIME}))
echo "${ELPASED_TIME} seconds"

exit
