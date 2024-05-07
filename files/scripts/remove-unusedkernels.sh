#!/usr/bin/env bash
#script for removing unused kernels
set -e

#kernel in use
CURRENT=$(uname -v | awk '{print $5}')
DEB=$(uname -a | awk '{print $3}')
echo "Kernel version currently in use: $CURRENT"
echo "Debian release: $DEB"

#old kernel
OLD=$(
	dpkg --list |
		grep 'linux-headers-\|linux-image-' |
		grep -v $CURRENT |
		awk '{print $2}'
)

echo ""
echo "Old kernels on the system:"
echo $OLD

#Remove old kernels only when used with exec
if [ "$1" == "exec" ]; then
	if [ -n "$OLD" ]; then
		for EACH in $OLD; do
			yes | sudo apt purge "$EACH"
			sudo rm -rf /lib/modules/
		done
	else
		echo "There are no unused kernels, so nothing has been removed"
	fi

#Remove unused kernel directory
	for i in /lib/modules/*; do
		if [ $i != /lib/modules/$DEB ]; then
			sudo rm -rf $i
			echo "Removed $i"
		else echo "$i is being used and thus not removed"
		fi
	done
else
	echo ""
	echo "To remove kernels, run as: remove-unusedkernels.sh exec OR ruk exec"
fi

exit
