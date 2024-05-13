#!/usr/bin/env bash
# Password generator script
set -e

echo "Enter password length:"
read length

CHAR="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-=''[]{}|;:,.<>?~"
REQ=(
		"!@#$%^&*()_+-=''[]{}|;:,.<>?~"
		"1234567890"
		"abcdefghijklmnopqrstuvwxyz"
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
)

if [ "$length" -gt 128 ]; then
	echo "A password length of $length is too long. It must be max 128 characters"
elif [ "$length" -lt 4 ]; then
	echo "A password length of $length is too short. It must be at least 4 characters"
else
	while true; do
		password=$(openssl rand -base64 128 | tr -dc "$CHAR" | head -c "$length")
		CONTAINS_REQ=false
		for (( i = 0; i < ${#password}; i++ )); do
			for n in "$REQ"; do
				if [[ "$n" == *"${password:$i:1}"* ]]; then
					CONTAINS_REQ=true
				fi
			done
		done
		if $CONTAINS_REQ; then
			break
		fi
	done
	echo "$password"
fi

exit 0
