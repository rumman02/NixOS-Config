#!/usr/bin/env bash

# can't support float number
gap_value=1

# Function to increase window blur size
increase_window_shadow() {
    current_size=$(hyprctl getoption decoration:shadow:range | awk 'NR==1 {print $2}')
    new_size=$((current_size + $gap_value))
    hyprctl keyword decoration:shadow:range "$new_size"
    echo "Window shadow increased to $new_size."
}

# Function to decrease window blur size
decrease_window_shadow() {
    current_size=$(hyprctl getoption decoration:shadow:range | awk 'NR==1 {print $2}')

    # Prevent window shadow size from going below 0
    if [ "$current_size" -gt 0 ]; then
        new_size=$((current_size - $gap_value))
        hyprctl keyword decoration:shadow:range "$new_size"
        echo "Window shadow size decreased to $new_size."
    else
        echo "Window shadow size cannot go below 0."
    fi
}

# Main logic
case "$1" in
window_shadow_size_plus)
    increase_window_shadow
    ;;
window_shadow_size_minus)
    decrease_window_shadow
    ;;
*)
    # echo "Usage: $0 {border_size_plus|border_size_minus|active_opacity_plus|active_opacity_minus}"
    ;;
esac
