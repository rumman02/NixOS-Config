#!/usr/bin/env bash

# # Variables to define sleep duration and the PID file
# SLEEP_DURATION=2  # Change this value to set the sleep duration (in seconds)
# SLEEP_PID_FILE="/tmp/sleep_pid"
#
# # Function to reset the submap
# reset_submap() {
# 	hyprctl dispatch submap reset
# }
#
# # Function to start sleep
# start_sleep() {
# 	# echo "Sleeping for $SLEEP_DURATION seconds..."
#
# 	sleep "$SLEEP_DURATION"
# 	reset_submap
# 	rm -f "$SLEEP_PID_FILE"  # Remove the PID file after completion
# }
#
# # Check if the sleep process is running
# if [ -f "$SLEEP_PID_FILE" ] && kill -0 "$(cat $SLEEP_PID_FILE)" 2>/dev/null; then
# 	# echo "Resetting sleep..."
# 	kill -9 "$(cat $SLEEP_PID_FILE)" 2>/dev/null
# 	rm -f "$SLEEP_PID_FILE"
# fi
#
# # Start a new sleep in the background
# start_sleep & echo $! > "$SLEEP_PID_FILE"

SLEEP_DURATION=5 # Change this value to set the sleep duration (in seconds)
SLEEP_PID_FILE="/tmp/sleep_pid"

reset_submap() {
    hyprctl dispatch submap reset
}

active_submap_reset() {
    # Function to reset the submap
    # reset_submap() {
    #     hyprctl dispatch submap reset
    # }

    # Function to start sleep
    start_sleep() {
        sleep "$SLEEP_DURATION"
        reset_submap
        rm -f "$SLEEP_PID_FILE" # Remove the PID file after completion
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

exit_submap_immediately() {
    # Check if the PID file exists
    if [ -f "$SLEEP_PID_FILE" ]; then
        # Get the PID and kill the sleep process
        PID=$(cat "$SLEEP_PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            kill -9 "$PID" 2>/dev/null
        fi
        # Remove the PID file
        rm -f "$SLEEP_PID_FILE"
        reset_submap
    fi
}

case "$1" in
active)
    active_submap_reset
    ;;
exited)
    exit_submap_immediately
    ;;
*)
    # echo ""
    ;;
esac
