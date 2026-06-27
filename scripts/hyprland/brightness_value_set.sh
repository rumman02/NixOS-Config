#!/usr/bin/env bash

SLEEP_DURATION=2
BRIGHTNESS_STEP=5
SLEEP_PID_FILE="/tmp/brightness_sleep_pid"
FILE_PATH="/tmp/brightness_value.txt"

# get value from file and set brightness by ddcutil
set_brightness() {
    # Check if the file exists and read the brightness value
    if [ -f "$FILE_PATH" ]; then
        VALUE=$(<"$FILE_PATH")

        # Set the brightness using ddcutil
        ddcutil setvcp 10 "$VALUE"
        echo "Brightness set to $VALUE."
    else
        echo "Brightness value file does not exist."
    fi
}

# need to wait when calling that script many times at once to set ddcutil,
# because of ddcutil is so much slow to set get value of brightness
set_after_sleep() {
    start_sleep() {
        sleep "$SLEEP_DURATION"
        set_brightness
        rm -f "$SLEEP_PID_FILE"
    }

    # Check if the sleep process is running
    if [ -f "$SLEEP_PID_FILE" ] && kill -0 "$(cat $SLEEP_PID_FILE)" 2>/dev/null; then
        kill -9 "$(cat $SLEEP_PID_FILE)" 2>/dev/null
        rm -f "$SLEEP_PID_FILE"
    fi

    # Start a new sleep in the background
    start_sleep &
    echo $! >"$SLEEP_PID_FILE"
}

# for increase_brightness
increase_brightness() {
    BRIGHTNESS=$(<"$FILE_PATH")
    NEW_BRIGHTNESS=$((BRIGHTNESS + BRIGHTNESS_STEP))

    if [ "$NEW_BRIGHTNESS" -gt 100 ]; then
        NEW_BRIGHTNESS=100
    fi

    echo "$NEW_BRIGHTNESS" >"$FILE_PATH"

    set_after_sleep
}

# for decrease_brightness
decrease_brightness() {
    BRIGHTNESS=$(<"$FILE_PATH")
    NEW_BRIGHTNESS=$((BRIGHTNESS - BRIGHTNESS_STEP))

    if [ "$NEW_BRIGHTNESS" -lt 0 ]; then
        NEW_BRIGHTNESS=0
    fi

    echo "$NEW_BRIGHTNESS" >"$FILE_PATH"

    set_after_sleep
}

# run script with this inputs (increase / decrease)
case "$1" in
increase)
    increase_brightness
    ;;
decrease)
    decrease_brightness
    ;;
*)
    echo "Usage: $0 {increase|decrease}"
    ;;
esac
