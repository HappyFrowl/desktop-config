#!/usr/bin/env bash
# Password generator script
set -e

echo "Enter password length:"
read length

CHAR="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-=''[]{}|;:,.<>?~"
REQUIRED=(
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
		CONTAINS_REQUIRED=false
		for (( i = 0; i < ${#password}; i++ )); do
			for EACH in "$REQUIRED"; do
				if [[ "$EACH" == *"${password:$i:1}"* ]]; then
					CONTAINS_REQUIRED=true
				fi
			done
		done
		if $CONTAINS_REQUIRED; then
			break
		fi
	done
	echo "$password"
fi

