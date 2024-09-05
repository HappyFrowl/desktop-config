#!/usr/bin/env bash
# Script extracting all photos and videos from Android phone
# Prerequisites are Developer Mode and USB debugging must be enabled on the phone
set -e

# Define source and destination path
SOURCES=("/storage/sdcard0/DCIM/Camera/" "/storage/sdcard0/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Images")
DESTINATION="$HOME/Pictures/temp"

# Transfer paths to destination
for SOURCE in $SOURCES; do
	if [ ! -d "$DESTINATION" ]; then
		mkdir -p "$DESTINATION"
	fi
	adb pull -a "$SOURCE" "$DESTINATION"
done

# Removed all trashed files
find "$DESTINATION" -type f -name *trashed* -delete

# Define source and destination directories for photos
SRC="$HOME/Pictures/temp/Camera/*"
DEST="$HOME/Pictures/testphotos/Camera"

# Set counter
TRANSFERRED=0

# Copy all unique regular files to destination directory
for FILE in $SRC; do
	BASE=$(basename "$FILE")
	if [ ! -e "$DEST/$BASE" ] && [ -f "$FILE" ]; then
		cp -n "$FILE" "$DEST"
		echo "Copied $FILE"
		TRANSFERRED=$((TRANSFERRED +1))
	elif [ -d "$FILE" ]; then
		echo "$FILE is a directory, skipping..."
	elif [ -e "$FILE" ]; then
		echo "$FILE already exists, skipping..."
	else
		echo "$FILE is neither a directory or existing at destination, but still skipping..."
	fi
done


# Define source and destination directories for WhatsApp files
SRC=("$HOME/Pictures/phone/here/*")
DEST="$HOME/Pictures/testphotos/here"

# Copy all unique regular files to destination directory
for FILE in $SRC; do
	BASE=$(basename "$FILE")
	if [ ! -e "$DEST/$BASE" ] && [ -f "$FILE" ]; then
		cp -n "$FILE" "$DEST"
		echo "Copied $FILE"
		TRANSFERRED=$((TRANSFERRED +1))
	elif [ -d "$FILE" ]; then
		echo "$FILE is a directory, skipping..."
	elif [ -e "$FILE" ]; then
		echo "$FILE already exists, skipping..."
	else
		echo "$FILE is neither a directory or existing at destination, but still skipping..."
	fi
done

# Empty adb directories
find $DESTINATION -mindepth 2 -type f -delete
echo "$DESTINATION has been emptied"

echo "$TRANSFERRED files have been transferred"

exit
