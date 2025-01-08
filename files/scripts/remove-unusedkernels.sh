#!/usr/bin/env bash
#Script for removing unused kernels and modules
set -e
IFS=$'\n'

#Kernel in use
IN_USE=$(uname -v | awk '{print $5}')
DEB=$(uname -r)
echo "In use kernel version: $IN_USE"
echo "Debian release: ${DEB}"

OLD_KERNELS=$(
	dpkg --list |
		grep -Ei 'linux-headers-|linux-image-' |
		grep -v $IN_USE |
		grep -vE "(linux-image-amd64|linux-headers-amd64)" |
		awk '{print $2}'
)
echo -e "\nOld kernels present:"
echo "${OLD_KERNELS}"

OLD_MODULES=$(ls /lib/modules |	grep -v $DEB || true)
echo "Old modules present:"
echo "${OLD_MODULES}"

#Dry run when used without exec
if [ "$1" == "exec" ]; then
	if [ -n "${OLD_KERNELS}" ]; then
	    IFS=$'\n'
	    for each in ${OLD_KERNELS}; do
	        yes | sudo apt purge "$each"
	        echo "Removed $each"
	    done
	    unset IFS
	else
	    echo "There are no unused kernels, skipping..."
	fi

	if [ -n "${OLD_MODULES}" ]; then
		for each in $OLD_MODULES; do
			sudo rm -rf /lib/modules/$each
			echo "Removed ${each}"
		done
	else
		echo "There are no unused modules, skipping..."
	fi
else
	echo "To remove, run: $0 exec"
fi
exit
