#!/bin/bash
# script extracting all photos and videos from Android phone

# Define source and destination path
SOURCES=("/storage/sdcard0/DCIM/Camera/" "/storage/sdcard0/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Images")
DESTINATION="$HOME/Pictures/phone"

# Transfer paths to destination
for SOURCE in $SOURCES; do
	adb pull -a $SOURCE $DESTINATION
done

# Define source and destination directories
SRC="$HOME/Pictures/phone/Camera"
FILES="$(ls $SRC)"
DEST="$HOME/Pictures/phone/here"

# Copy all unique regular files to destination directory
for FILE in $FILES; do
	if [ ! -e "$DEST/$FILE" ] && [ -f "$SRC/$FILE" ]; then
		cp -n "$FILE" "$DEST"
		echo "Copied $FILE"
	elif [ -d "$SRC/$FILE" ]; then
		echo "$FILE is a directory, skipping..."
	elif [ -e "$DEST/$FILE" ]; then
		echo "$FILE already exists, skipping..."
	else
		echo "$FILE is neither a directory or existing at destination, but still skipping..."
	fi
done
