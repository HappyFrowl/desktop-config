#!/usr/bin/env bash
# System update script
set -e

echo "Welcome to Update Manager"
sleep 0.5
START_TIME=$SECONDS

LOGFILE="/var/log/update/update.log"
ERRORLOG="/var/log/update/error.log"

echo -e "\n$(date)" | tee -a "${LOGFILE}"

# Set the environment variable to noninteractive
export DEBIAN_FRONTEND=noninteractive

update_system() {

        echo -e "Please provide password\n"
        sudo apt update
        echo -e  "\nApt packages:" | tee -a "${LOGFILE}"
        sudo apt dist-upgrade -y 2>>"${ERRORLOG}" | tee -a "${LOGFILE}"
        echo ""
        sudo apt autoremove -y 2>>"${ERRORLOG}" | tee -a "${LOGFILE}"
}

error_handling() {
        echo "An error has occurred: $1"
        exit 1
}

trap 'error_handling "Line $LINENO: Command failed with exit code $?"' ERR

update_system "$@"

echo -e "\nFlatPak updates:" | tee -a "${LOGFILE}"
flatpak update -y  | tee -a $LOGFILE
flatpak uninstall --unused -y | tee -a "${LOGFILE}"

echo -e "\nTime taken to run updates:"
ELPASED_TIME=$(("${SECONDS}" - "${START_TIME}"))
echo "${ELPASED_TIME}" seconds

exit
