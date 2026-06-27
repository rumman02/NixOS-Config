#!/usr/bin/env bash

hyprctl dispatch submap reset

active_window=$(hyprctl -j activeworkspace | jq ".windows")
selected_app=$(rofi -show drun -run-command "echo {cmd}")

# Check if user cancelled rofi
if [ -z "$selected_app" ]; then
    exit 0
fi


hyprctl dispatch hy3:changefocus tabnode
eval "$selected_app" &
sleep 2
hyprctl dispatch hy3:focustab l
hyprctl dispatch hy3:changefocus bottom
hyprctl dispatch hy3:focustab r

