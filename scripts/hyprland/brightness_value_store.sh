#!/usr/bin/env bash

# Define the file path
FILE_PATH="/tmp/brightness_value.txt"

# Get the current brightness value
BRIGHTNESS=$(ddcutil getvcp 10 | awk '/current value/ {gsub(",", "", $9); print $9}')

# Check if the file exists
if [ ! -f "$FILE_PATH" ]; then
    # Create the file and write the initial brightness value
    echo "$BRIGHTNESS" >"$FILE_PATH"
    echo "File created and brightness value set to $BRIGHTNESS."
else
    # Update the existing file with the new brightness value
    echo "$BRIGHTNESS" >"$FILE_PATH"
    echo "Brightness value updated to $BRIGHTNESS."
fi
