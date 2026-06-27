#!/usr/bin/env bash

# can't support float number
gap_value=1

# Function to increase window blur size
increase_window_blur_size() {
    current_size=$(hyprctl getoption decoration:blur:size | awk 'NR==1 {print $2}')
    new_size=$((current_size + $gap_value))
    hyprctl keyword decoration:blur:size "$new_size"
    echo "Window blur size increased to $new_size."
}

# Function to decrease window blur size
decrease_window_blur_size() {
    current_size=$(hyprctl getoption decoration:blur:size | awk 'NR==1 {print $2}')

    # Prevent window blur size from going below 0
    if [ "$current_size" -gt 0 ]; then
        new_size=$((current_size - $gap_value))
        hyprctl keyword decoration:blur:size "$new_size"
        echo "Window blur size decreased to $new_size."
    else
        echo "Window blur size cannot go below 0."
    fi
}

# Function to increase window blur passes
increase_window_blur_passes() {
    current_passes=$(hyprctl getoption decoration:blur:passes | awk 'NR==1 {print $2}')
    new_passes=$((current_passes + $gap_value))
    hyprctl keyword decoration:blur:passes "$new_passes"
    echo "Window blur passes increased to $new_passes."
}

# Function to decrease window blur passes
decrease_window_blur_passes() {
    current_passes=$(hyprctl getoption decoration:blur:passes | awk 'NR==1 {print $2}')

    # Prevent window blur passes from going below 0
    if [ "$current_passes" -gt 0 ]; then
        new_passes=$((current_passes - $gap_value))
        hyprctl keyword decoration:blur:passes "$new_passes"
        echo "Window blur passes decreased to $new_passes."
    else
        echo "Window blur passes cannot go below 0."
    fi
}

# Main logic
case "$1" in
window_blur_size_plus)
    increase_window_blur_size
    ;;
window_blur_size_minus)
    decrease_window_blur_size
    ;;
window_blur_passes_plus)
    increase_window_blur_passes
    ;;
window_blur_passes_minus)
    decrease_window_blur_passes
    ;;
*)
    # echo "Usage: $0 {border_size_plus|border_size_minus|active_opacity_plus|active_opacity_minus}"
    ;;
esac
