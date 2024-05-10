#!/usr/bin/env bash
# Password generator script
set -e

echo "Enter password length:"
read length

CHAR="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-=''[]{}|;:,.<>?~"

if [ "$length" -gt 128 ]; then
	echo "A password length of $length is too long. It can be at most 128 characters"
else
	password=$(openssl rand -base64 128 | tr -dc "$CHAR" | head -c "$length")
	echo "$password"
fi

