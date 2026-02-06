#!/usr/bin/env bash
# System update script
set -e

#region Function Definitions:
handle_error(){
	# Function handling errors
	echo -e "\e[31mError: $1"
	echo -e "\e]31mAborting...\e[0m"
	exit 1
}



update() {
	echo -e "Please provide password\n"
	sudo apt update || handle_error "Failed to update packages" 
	echo -e  "\nApt packages:" | tee -a ${LOGFILE} 
	sudo apt dist-upgrade -y | tee -a ${LOGFILE} || handle_error "Failed to upgrade packages" 
}

cleanup() {
	sudo apt autoremove -yy 2>>${ERRORLOG} | tee -a ${LOGFILE} || handle_error "Failed to autoremove packages"
	sudo apt autoclean 2>>${ERRORLOG} | tee -a ${LOGFILE} || handle_error "Failed to autoclean" 
}

update_flatpak() {
	echo -e "\nFlatPak updates:" | tee -a ${LOGFILE}  
	flatpak update -y  | tee -a ${LOGFILE} || handle_error "Failed to update Flatpak" 
}

cleanup_flatpak() {
	flatpak uninstall --unused -y | tee -a ${LOGFILE} || handle_error "Failed to uninstall Flatpak"
}

#endregion 
#region init 

# Set the environment variable to noninteractive
export DEBIAN_FRONTEND=noninteractive

# Set paths
LOGFILE="/var/log/update/update.log"
ERRORLOG="/var/log/update/error.log"

# Check for file existence and create it not exists
FILES=("$LOGFILE" "$ERRORLOG")
for file in "${FILES[@]}"; do
	DIR=$(dirname $file)
	sudo mkdir -p $DIR || handle_error "Failed to create directory $DIR"

	if [ ! -f $file ]; then
		sudo touch $FILE || handle_error "Failed to create file $FILE"
	fi
done
#endregion init

#region Function Execution
echo "Welcome to Update Manager"
echo -e "\n$(date)" | tee -a $LOGFILE
START_TIME=$SECONDS

update
cleanup

if which flatpak ; then
	update_flatpak
	cleanup_flatpak
fi

echo "----------------------------------------"
echo "-           Update completed           -"
echo "----------------------------------------"
echo -e "\nTime taken to run updates:"
ELPASED_TIME=$((${SECONDS} - ${START_TIME}))
echo "${ELPASED_TIME} seconds"
#endregion Function Execution
exit 0
