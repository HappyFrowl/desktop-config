#!/usr/bin/env bash
# Password generator script
# It does not actually work for openssl rand -base64 only produces + / signs and still does not always produce each of the required character sets

set -e

# Specify password length, either by adding it as an argument or it will be prompted for
if [ -z $1 ]; then
	echo "Enter password length:"
	read length
else length="$1"
fi

# Define password character lists
CHAR="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-=''[]{}|;:,.<>?~"
REQ=(
		"!@#$%^&*()_+-=[]{}|;:,.<>?~"
		"1234567890"
		"abcdefghijklmnopqrstuvwxyz"
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
)

# Require password length to not null and equal or less than 128 characters
if [ -z "$length" ]; then
	echo "No password length was provided, exiting..."
elif [ "$length" -gt 128 ]; then
	echo "A password length of $length is too long. It must be max 128 characters"
elif [ "$length" -lt 4 ]; then
	echo "A password length of $length is too short. It must be at least 4 characters"
else
	# Generate password and match it the required characters
while true; do
		password=$(openssl rand -base64 128 | tr -dc "$CHAR" | head -c $length)
		CONTAINS_REQ=false
		for (( i = 0; i < ${#password}; i++ )); do
			for n in "$REQ"; do
				if [[ "$n" == *"${password:$i:1}"* ]]; then
					CONTAINS_REQ=true
				fi
			done
		done
		if $CONTAINS_REQ == true; then
			break
		fi
	done
	echo "$password"
fi

exit 0


