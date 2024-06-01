#!/usr/bin/env bash
#Script for removing unused kernels and modules
set -e

#Kernel in use
IN_USE=$(uname -v | awk '{print $5}')
DEB=$(uname -r)
echo "In use kernel version: $IN_USE"
echo "Debian release: $DEB"

#Old kernels
OLD_KERNELS=$(
	dpkg --list |
		grep -Ei 'linux-headers-|linux-image-' |
		grep -v $IN_USE |
		awk '{print $2}'
)

echo -e "\nOld kernels present:"
echo $OLD_KERNELS

#Old modules
OLD_MODULES=$(ls /lib/modules |
	grep -v $DEB || true
)
echo "Old modules present:"
echo "$OLD_MODULES"

#Dry run without exec
if [ "$1" == "exec" ]; then
	if [ -n "$OLD_KERNELS" ]; then
		for each in $OLD_KERNELS; do
			yes | sudo apt purge "$each"
		done
	else
		echo "There are no unused kernels, skipping..."
	fi

#Remove unused modules
	for module in $OLD_MODULES; do
		sudo rm -rf /lib/modules/$module
		echo "Removed $module"
	done
else
	echo -e "\nTo remove, run as: $0 exec"
fi
exit
