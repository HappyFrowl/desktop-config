#!/bin/bash
#script for removing unused kernels

#kernel in use
CURRENT=$(uname -v | awk '{print $5}')
echo "Kernel currently in use is $CURRENT"
echo ""

#old kernel
OLD=$(
	dpkg --list |
		grep 'linux-headers-\|linux-image-' |
		grep -v $CURRENT |
		awk '{print $2}'
)

echo "Old kernels on the system:"
echo ""
echo $OLD

if [ "$1" == "exec" ]; then
	if [ -n "$OLD" ]; then
		for EACH in $OLD; do
			yes | apt purge "$EACH"
		done
	else
		echo "There are no unused kernels"
	fi
else
	echo ""
	echo "To remove kernels, run as: sudo remove-unusedkernels.sh exec"
fi
