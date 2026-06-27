#!/usr/bin/env bash

hyprctl dispatch submap reset

# Check if orientation argument is provided
if [ $# -eq 0 ] || { [ "$1" != "h" ] && [ "$1" != "v" ]; }; then
    echo "Usage: $0 {h|v}"
    echo "  h - horizontal group"
    echo "  v - vertical group"
    exit 1
fi

orientation="$1"
active_window=$(hyprctl -j activeworkspace | jq ".windows")
selected_app=$(rofi -show drun -run-command "echo {cmd}")

# Check if user cancelled rofi
if [ -z "$selected_app" ]; then
    exit 0
fi

if [ "$active_window" -eq 0 ]; then
    eval "$selected_app" &
    sleep 2
    hyprctl dispatch hy3:makegroup "$orientation"
    hyprctl dispatch hy3:changefocus top
    hyprctl dispatch hy3:changegroup tab
    hyprctl dispatch hy3:changefocus bottom
else
    hyprctl dispatch hy3:makegroup "$orientation"
    eval "$selected_app" &
    sleep 2
    hyprctl dispatch hy3:changefocus bottom
fi

