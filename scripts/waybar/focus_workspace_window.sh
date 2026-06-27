#!/usr/bin/env bash

address=$1
button=$2

if [ $button -eq 1 ]; then
	# Left click: focus window
	hyprctl keyword cursor:no_warps true
	hyprctl dispatch focuswindow address:$address
	hyprctl keyword cursor:no_warps false
elif [ $button -eq 2 ]; then
	# Middle click: close window
	hyprctl dispatch closewindow address:$address
fi

