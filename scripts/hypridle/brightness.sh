#!/usr/bin/env bash

FILE_PATH="/tmp/brightness_value.txt"

case "$1" in
    "on_timeout")
        # Read current brightness value from file
        if [ -f "$FILE_PATH" ]; then
            current_brightness=$(cat $FILE_PATH)

            # Check if brightness > 40, if yes set to 40
            if [ $current_brightness -gt 0 ]; then
                brightnessctl set 0%
                ddcutil setvcp 10 0
            fi
        fi
        ;;

    "on_resume")
        # Read previous brightness value from file and restore it
        if [ -f "$FILE_PATH" ]; then
            previous_brightness=$(cat $FILE_PATH)
            brightnessctl set ${previous_brightness}%
            ddcutil setvcp 10 ${previous_brightness}
        fi
        ;;

    *)
        exit 1
        ;;
esac

